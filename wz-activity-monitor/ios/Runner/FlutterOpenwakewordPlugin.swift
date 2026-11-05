import Flutter
import UIKit
import AVFoundation
import TensorFlowLite

public class FlutterOpenwakewordPlugin: NSObject, FlutterPlugin {
    private var wakeWordDetector: WakeWordDetector?
    private var channel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_openwakeword", binaryMessenger: registrar.messenger())
        let instance = FlutterOpenwakewordPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            handleInitialize(call: call, result: result)
        case "startListening":
            handleStartListening(result: result)
        case "stopListening":
            handleStopListening(result: result)
        case "isListening":
            result(wakeWordDetector?.isListening ?? false)
        case "setThreshold":
            handleSetThreshold(call: call, result: result)
        case "dispose":
            handleDispose(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleInitialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let melPath = args["melspectrogramModelPath"] as? String,
              let embeddingPath = args["embeddingModelPath"] as? String,
              let wakeWordPath = args["wakeWordModelPath"] as? String else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
            return
        }
        
        let threshold = args["threshold"] as? Double ?? 0.5
        
        do {
            wakeWordDetector = try WakeWordDetector(
                melspectrogramModelPath: melPath,
                embeddingModelPath: embeddingPath,
                wakeWordModelPath: wakeWordPath,
                threshold: threshold,
                channel: channel
            )
            result(true)
        } catch {
            result(FlutterError(code: "INIT_ERROR", message: "Failed to initialize: \(error.localizedDescription)", details: nil))
        }
    }
    
    private func handleStartListening(result: @escaping FlutterResult) {
        do {
            try wakeWordDetector?.startListening()
            result(true)
        } catch {
            result(FlutterError(code: "START_ERROR", message: "Failed to start: \(error.localizedDescription)", details: nil))
        }
    }
    
    private func handleStopListening(result: @escaping FlutterResult) {
        wakeWordDetector?.stopListening()
        result(true)
    }
    
    private func handleSetThreshold(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let threshold = args["threshold"] as? Double else {
            result(FlutterError(code: "INVALID_ARGS", message: "Invalid threshold", details: nil))
            return
        }
        
        wakeWordDetector?.setThreshold(threshold)
        result(true)
    }
    
    private func handleDispose(result: @escaping FlutterResult) {
        wakeWordDetector?.dispose()
        wakeWordDetector = nil
        result(nil)
    }
}

enum WakeWordLogLevel: Int, CustomStringConvertible {
    case none = 0
    case error = 1
    case warn = 2
    case info = 3
    case verbose = 4

    var description: String {
        switch self {
        case .none: return "NONE"
        case .error: return "ERROR"
        case .warn: return "WARN"
        case .info: return "INFO"
        case .verbose: return "VERBOSE"
        }
    }
}

class WakeWordDetector {
    private var melspectrogramInterpreter: Interpreter
    private var embeddingInterpreter: Interpreter
    private var wakeWordInterpreter: Interpreter
    
    private var audioEngine: AVAudioEngine?
    private var inputNode: AVAudioInputNode?
    private var threshold: Double
    private weak var channel: FlutterMethodChannel?
    
    private(set) var isListening = false
    
    // Audio parameters matching OpenWakeWord requirements
    private let sampleRate: Double = 16000.0
    private let frameSize = 512 + 160 * 4 // 1152 samples @ 16kHz = 72ms
    
    // OpenWakeWord frame accumulation constants (from reference implementation)
    private let MEL_OUTPUT_COUNT = 5  // mel model outputs 5 frames per inference
    private let MEL_FEATURE_SIZE = 32
    private let EMB_INPUT_COUNT = 76  // embedding model needs 76 frames of mel features
    private let EMB_OUTPUT_COUNT = 1
    private let EMB_FEATURE_SIZE = 96
    private let WAKE_INPUT_COUNT = 16 // wake word model needs 16 frames of embeddings
    
    // Accumulated features (ring buffers)
    private var accumulatedMelOutputs: [[Float]] = []
    private var accumulatedEmbOutputs: [[Float]] = []

    static var logLevel: WakeWordLogLevel = .warn

    private static func log(_ message: String, level: WakeWordLogLevel = .info) {
        guard level.rawValue <= WakeWordDetector.logLevel.rawValue else { return }
        print("[OWW:\(level)] \(message)")
    }
    
    init(melspectrogramModelPath: String,
         embeddingModelPath: String,
         wakeWordModelPath: String,
         threshold: Double,
         channel: FlutterMethodChannel?) throws {
        
        self.threshold = threshold
        self.channel = channel
        
        WakeWordDetector.log("WakeWordDetector init: Loading models")
        WakeWordDetector.log("  Melspectrogram: \(melspectrogramModelPath)")
        WakeWordDetector.log("  Embedding: \(embeddingModelPath)")
        WakeWordDetector.log("  Wake word: \(wakeWordModelPath)")
        WakeWordDetector.log("  Threshold: \(threshold)")
        WakeWordDetector.log("  Frame size: \(frameSize)")
        
        // Load melspectrogram model with dynamic input resizing
        WakeWordDetector.log("Loading melspectrogram model...")
        let melKey = FlutterDartProject.lookupKey(forAsset: melspectrogramModelPath)
        guard let melPath = Bundle.main.path(forResource: melKey, ofType: nil) else {
            throw NSError(domain: "WakeWordDetector", code: -1, 
                         userInfo: [NSLocalizedDescriptionKey: "Melspectrogram model not found: \(melspectrogramModelPath)"])
        }
        WakeWordDetector.log("  Resolved path: \(melPath)", level: .verbose)
        self.melspectrogramInterpreter = try Interpreter(modelPath: melPath)
        
        // CRITICAL: Resize input dimensions before allocating tensors
        try melspectrogramInterpreter.resizeInput(at: 0, to: [1, frameSize])
        try melspectrogramInterpreter.allocateTensors()
        WakeWordDetector.log("Melspectrogram model loaded, input resized to [1, \(frameSize)]")
        
        // Load embedding model
        WakeWordDetector.log("Loading embedding model...")
        let embKey = FlutterDartProject.lookupKey(forAsset: embeddingModelPath)
        guard let embPath = Bundle.main.path(forResource: embKey, ofType: nil) else {
            throw NSError(domain: "WakeWordDetector", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Embedding model not found: \(embeddingModelPath)"])
        }
        WakeWordDetector.log("  Resolved path: \(embPath)", level: .verbose)
        self.embeddingInterpreter = try Interpreter(modelPath: embPath)
        try embeddingInterpreter.allocateTensors()
        WakeWordDetector.log("Embedding model loaded successfully")
        
        // Load wake word model
        WakeWordDetector.log("Loading wake word model...")
        let wakeKey = FlutterDartProject.lookupKey(forAsset: wakeWordModelPath)
        guard let wakePath = Bundle.main.path(forResource: wakeKey, ofType: nil) else {
            throw NSError(domain: "WakeWordDetector", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Wake word model not found: \(wakeWordModelPath)"])
        }
        WakeWordDetector.log("  Resolved path: \(wakePath)", level: .verbose)
        self.wakeWordInterpreter = try Interpreter(modelPath: wakePath)
        try wakeWordInterpreter.allocateTensors()
        WakeWordDetector.log("Wake word model loaded successfully")
        
        // Initialize accumulation buffers
        accumulatedMelOutputs = Array(repeating: Array(repeating: 0.0, count: MEL_FEATURE_SIZE), count: EMB_INPUT_COUNT)
        accumulatedEmbOutputs = Array(repeating: Array(repeating: 0.0, count: EMB_FEATURE_SIZE), count: WAKE_INPUT_COUNT)
        
        WakeWordDetector.log("All models loaded successfully")
    }
    
    func startListening() throws {
        guard !isListening else { return }
        
        WakeWordDetector.log("startListening: Clearing accumulated features from previous session")
        clearAccumulatedFeatures()
        
        // Request microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            guard granted else {
                WakeWordDetector.log("Microphone permission denied", level: .warn)
                return
            }
            
            WakeWordDetector.log("Has permissions continuing with setup", level: .verbose)
            DispatchQueue.main.async {
                self?.setupAudioEngine()
            }
        }
        
        isListening = true
    }
    
    private func setupAudioEngine() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement)
            try audioSession.setActive(true)
            
            audioEngine = AVAudioEngine()
            inputNode = audioEngine?.inputNode
            
            guard let inputNode = inputNode else { return }
            
            // Get the hardware format (likely 48kHz)
            let inputFormat = inputNode.outputFormat(forBus: 0)
            WakeWordDetector.log("Hardware input format: \(inputFormat)", level: .verbose)
            
            // Configure our desired format (16kHz)
            guard let desiredFormat = AVAudioFormat(
                commonFormat: .pcmFormatFloat32,
                sampleRate: sampleRate,
                channels: 1,
                interleaved: false
            ) else {
                WakeWordDetector.log("Failed to create desired audio format", level: .error)
                return
            }
            WakeWordDetector.log("Desired format: \(desiredFormat)", level: .verbose)
            
            // Create a converter node to resample from hardware rate to 16kHz
            guard let converter = AVAudioConverter(from: inputFormat, to: desiredFormat) else {
                WakeWordDetector.log("Failed to create audio converter", level: .error)
                return
            }
            
            // Audio buffer to accumulate samples
            var audioBuffer: [Float] = []
            
            inputNode.installTap(onBus: 0, bufferSize: 4096, format: inputFormat) { [weak self] (buffer, time) in
                guard let self = self, self.isListening else { return }
                
                // Convert the buffer to our desired format
                guard let convertedBuffer = AVAudioPCMBuffer(
                    pcmFormat: desiredFormat,
                    frameCapacity: AVAudioFrameCount(Double(buffer.frameLength) * self.sampleRate / inputFormat.sampleRate)
                ) else { return }
                
                var error: NSError?
                let inputBlock: AVAudioConverterInputBlock = { inNumPackets, outStatus in
                    outStatus.pointee = .haveData
                    return buffer
                }
                
                converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputBlock)
                
                if let error = error {
                    WakeWordDetector.log("Conversion error: \(error)", level: .error)
                    return
                }
                
                guard let channelData = convertedBuffer.floatChannelData?[0] else { return }
                let frameLength = Int(convertedBuffer.frameLength)
                
                // Append samples to buffer
                for i in 0..<frameLength {
                    audioBuffer.append(channelData[i])
                }
                
                // Process when we have enough samples
                while audioBuffer.count >= self.frameSize {
                    let frame = Array(audioBuffer.prefix(self.frameSize))
                    audioBuffer.removeFirst(self.frameSize)
                    
                    if let score = self.detectWakeWord(audioData: frame) {
                        if score > self.threshold {
                            self.notifyWakeWordDetected(wakeWord: "wake_word", score: score)
                        }
                    }
                }
            }
            
            audioEngine?.prepare()
            try audioEngine?.start()
            WakeWordDetector.log("Audio engine started successfully")
            
        } catch {
            WakeWordDetector.log("Failed to setup audio engine: \(error)", level: .error)
        }
    }
    
    func stopListening() {
        WakeWordDetector.log("stopListening: Stopping listening, current state: \(isListening)")
        isListening = false
        inputNode?.removeTap(onBus: 0)
        audioEngine?.stop()
        audioEngine = nil
        inputNode = nil
        
        // Clear accumulated feature buffers to prevent false triggers
        WakeWordDetector.log("stopListening: Clearing accumulated feature buffers")
        clearAccumulatedFeatures()
        
        WakeWordDetector.log("stopListening: Listening stopped successfully")
    }
    
    private func clearAccumulatedFeatures() {
        // Reset mel spectrogram accumulation buffer
        accumulatedMelOutputs = Array(repeating: Array(repeating: 0.0, count: MEL_FEATURE_SIZE), count: EMB_INPUT_COUNT)
        
        // Reset embedding accumulation buffer
        accumulatedEmbOutputs = Array(repeating: Array(repeating: 0.0, count: EMB_FEATURE_SIZE), count: WAKE_INPUT_COUNT)
        
        WakeWordDetector.log("clearAccumulatedFeatures: Feature buffers cleared", level: .verbose)
    }
    
    func setThreshold(_ newThreshold: Double) {
        threshold = newThreshold
    }
    
    private func detectWakeWord(audioData: [Float]) -> Double? {
        do {
            // Step 1: Compute melspectrogram
            let melInputData = Data(bytes: audioData, count: audioData.count * MemoryLayout<Float>.stride)
            try melspectrogramInterpreter.copy(melInputData, toInputAt: 0)
            try melspectrogramInterpreter.invoke()
            
            let melOutput = try melspectrogramInterpreter.output(at: 0)
            
            // Parse mel output into 2D array [MEL_OUTPUT_COUNT][MEL_FEATURE_SIZE]
            var melFrames: [[Float]] = []
            melOutput.data.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
                let floatPtr = ptr.bindMemory(to: Float.self)
                for frameIdx in 0..<MEL_OUTPUT_COUNT {
                    var frame: [Float] = []
                    for featureIdx in 0..<MEL_FEATURE_SIZE {
                        let value = floatPtr[frameIdx * MEL_FEATURE_SIZE + featureIdx]
                        // Normalize: (value / 10.0) + 2.0
                        frame.append((value / 10.0) + 2.0)
                    }
                    melFrames.append(frame)
                }
            }
            
            // Accumulate mel outputs (shift old frames, add new ones)
            for i in 0..<EMB_INPUT_COUNT {
                if i < EMB_INPUT_COUNT - MEL_OUTPUT_COUNT {
                    // Shift old frames forward
                    accumulatedMelOutputs[i] = accumulatedMelOutputs[i + MEL_OUTPUT_COUNT]
                } else {
                    // Add new frame
                    accumulatedMelOutputs[i] = melFrames[i - EMB_INPUT_COUNT + MEL_OUTPUT_COUNT]
                }
            }
            
            // Check if we have enough accumulated frames (first frame should be non-zero)
            if accumulatedMelOutputs[0].allSatisfy({ $0 == 0.0 }) {
                return 0.0 // Not fully initialized yet
            }
            
            // Step 2: Extract embeddings
            // Flatten accumulated mel outputs for input
            var flattenedMel: [Float] = []
            for frame in accumulatedMelOutputs {
                flattenedMel.append(contentsOf: frame)
            }
            let embInputData = Data(bytes: flattenedMel, count: flattenedMel.count * MemoryLayout<Float>.stride)
            try embeddingInterpreter.copy(embInputData, toInputAt: 0)
            try embeddingInterpreter.invoke()
            
            let embeddingOutput = try embeddingInterpreter.output(at: 0)
            
            // Parse embedding output
            var embFrame: [Float] = []
            embeddingOutput.data.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
                let floatPtr = ptr.bindMemory(to: Float.self)
                for i in 0..<EMB_FEATURE_SIZE {
                    embFrame.append(floatPtr[i])
                }
            }
            
            // Accumulate embedding outputs
            for i in 0..<WAKE_INPUT_COUNT {
                if i < WAKE_INPUT_COUNT - EMB_OUTPUT_COUNT {
                    // Shift old embeddings forward
                    accumulatedEmbOutputs[i] = accumulatedEmbOutputs[i + EMB_OUTPUT_COUNT]
                } else {
                    // Add new embedding
                    accumulatedEmbOutputs[i] = embFrame
                }
            }
            
            // Check if we have enough accumulated embeddings
            if accumulatedEmbOutputs[0].allSatisfy({ $0 == 0.0 }) {
                return 0.0 // Not fully initialized yet
            }
            
            // Step 3: Wake word prediction
            var flattenedEmb: [Float] = []
            for frame in accumulatedEmbOutputs {
                flattenedEmb.append(contentsOf: frame)
            }
            let wakeInputData = Data(bytes: flattenedEmb, count: flattenedEmb.count * MemoryLayout<Float>.stride)
            try wakeWordInterpreter.copy(wakeInputData, toInputAt: 0)
            try wakeWordInterpreter.invoke()
            
            let predictionOutput = try wakeWordInterpreter.output(at: 0)
            
            // Extract score from output
            let outputData = predictionOutput.data
            let score = outputData.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) -> Double in
                let floatPtr = ptr.bindMemory(to: Float.self)
                return Double(floatPtr[0])
            }
            
            return score
            
        } catch {
            WakeWordDetector.log("Error detecting wake word: \(error)", level: .error)
            return nil
        }
    }
    
    private func notifyWakeWordDetected(wakeWord: String, score: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.channel?.invokeMethod("onWakeWordDetected", arguments: [
                "wakeWord": wakeWord,
                "score": score
            ])
        }
    }
    
    func dispose() {
        stopListening()
    }
}