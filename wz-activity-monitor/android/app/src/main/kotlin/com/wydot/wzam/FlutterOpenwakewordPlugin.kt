package com.wydot.wzam

import android.content.Context
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.tensorflow.lite.Interpreter
import java.io.FileInputStream
import java.io.File
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.channels.FileChannel
import java.util.concurrent.atomic.AtomicInteger
import kotlin.concurrent.thread

class FlutterOpenwakewordPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var flutterAssets: FlutterPlugin.FlutterAssets
    private var wakeWordDetector: WakeWordDetector? = null
    
    companion object {
        private const val TAG = "FlutterOpenwakeword"
    }
    
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine: Plugin being attached to Flutter engine")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_openwakeword")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        flutterAssets = flutterPluginBinding.flutterAssets
        Log.d(TAG, "onAttachedToEngine: Plugin successfully attached, channel: flutter_openwakeword")
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.d(TAG, "onMethodCall: Received method call: ${call.method}")
        when (call.method) {
            "initialize" -> {
                Log.d(TAG, "initialize: Starting initialization")
                val melspectrogramPath = call.argument<String>("melspectrogramModelPath")!!
                val embeddingPath = call.argument<String>("embeddingModelPath")!!
                val wakeWordPath = call.argument<String>("wakeWordModelPath")!!
                val threshold = call.argument<Double>("threshold") ?: 0.5
                
                Log.d(TAG, "initialize: Model paths - Mel: $melspectrogramPath, Embedding: $embeddingPath, WakeWord: $wakeWordPath")
                Log.d(TAG, "initialize: Threshold: $threshold")
                
                try {
                    wakeWordDetector = WakeWordDetector(
                        context,
                        flutterAssets,
                        melspectrogramPath,
                        embeddingPath,
                        wakeWordPath,
                        threshold,
                        channel
                    )
                    Log.i(TAG, "initialize: WakeWordDetector successfully created")
                    result.success(true)
                } catch (e: Exception) {
                    Log.e(TAG, "initialize: Failed to initialize wake word detector", e)
                    result.error("INIT_ERROR", "Failed to initialize: ${e.message}", null)
                }
            }
            "startListening" -> {
                Log.d(TAG, "startListening: Attempting to start listening")
                try {
                    wakeWordDetector?.startListening()
                    Log.i(TAG, "startListening: Successfully started listening")
                    result.success(true)
                } catch (e: Exception) {
                    Log.e(TAG, "startListening: Failed to start listening", e)
                    result.error("START_ERROR", "Failed to start: ${e.message}", null)
                }
            }
            "stopListening" -> {
                Log.d(TAG, "stopListening: Attempting to stop listening")
                try {
                    wakeWordDetector?.stopListening()
                    Log.i(TAG, "stopListening: Successfully stopped listening")
                    result.success(true)
                } catch (e: Exception) {
                    Log.e(TAG, "stopListening: Failed to stop listening", e)
                    result.error("STOP_ERROR", "Failed to stop: ${e.message}", null)
                }
            }
            "isListening" -> {
                val listening = wakeWordDetector?.isListening ?: false
                Log.d(TAG, "isListening: Current state: $listening")
                result.success(listening)
            }
            "setThreshold" -> {
                val threshold = call.argument<Double>("threshold") ?: 0.5
                Log.d(TAG, "setThreshold: Setting new threshold: $threshold")
                wakeWordDetector?.setThreshold(threshold)
                result.success(true)
            }
            "dispose" -> {
                Log.d(TAG, "dispose: Disposing wake word detector")
                wakeWordDetector?.dispose()
                wakeWordDetector = null
                Log.i(TAG, "dispose: Successfully disposed")
                result.success(null)
            }
            else -> {
                Log.w(TAG, "onMethodCall: Unknown method called: ${call.method}")
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        wakeWordDetector?.dispose()
    }
}

class WakeWordDetector(
    private val context: Context,
    private val flutterAssets: FlutterPlugin.FlutterAssets,
    melspectrogramModelPath: String,
    embeddingModelPath: String,
    wakeWordModelPath: String,
    private var threshold: Double,
    private val channel: MethodChannel,
    private var logLevel: Int = Log.WARN
) {
    private val melspectrogramInterpreter: Interpreter
    private val embeddingInterpreter: Interpreter
    private val wakeWordInterpreter: Interpreter
    
    @Volatile private var audioRecord: AudioRecord? = null
    @Volatile public var isListening = false
    @Volatile private var processingThread: Thread? = null
    private val listeningSessionId = AtomicInteger(0)
    private val mainHandler = Handler(Looper.getMainLooper())
    
    // Audio parameters matching OpenWakeWord requirements
    private val sampleRate = 16000
    private val channels = AudioFormat.CHANNEL_IN_MONO
    private val audioFormat = AudioFormat.ENCODING_PCM_16BIT
    private val frameSize = 512 + 160 * 4 // 1152 samples @ 16kHz = 72ms
    private val bufferSize = AudioRecord.getMinBufferSize(sampleRate, channels, audioFormat)
    
    // OpenWakeWord frame accumulation constants (from reference implementation)
    private val MEL_OUTPUT_COUNT = 5  // mel model outputs 5 frames per inference
    private val MEL_FEATURE_SIZE = 32
    private val EMB_INPUT_COUNT = 76  // embedding model needs 76 frames of mel features
    private val EMB_OUTPUT_COUNT = 1
    private val EMB_FEATURE_SIZE = 96
    private val WAKE_INPUT_COUNT = 16 // wake word model needs 16 frames of embeddings
    
    // Accumulated features (ring buffers)
    private var accumulatedMelOutputs: Array<Array<FloatArray>> = Array(EMB_INPUT_COUNT) { arrayOf() }
    private var accumulatedEmbOutputs: Array<FloatArray> = Array(WAKE_INPUT_COUNT) { floatArrayOf() }
    
    companion object {
        private const val TAG = "WakeWordDetector"
    }

    private fun shouldLog(level: Int): Boolean = level >= logLevel

    private fun logV(message: String) {
        if (shouldLog(Log.VERBOSE)) Log.v(TAG, message)
    }

    private fun logD(message: String) {
        if (shouldLog(Log.DEBUG)) Log.d(TAG, message)
    }

    private fun logI(message: String) {
        if (shouldLog(Log.INFO)) Log.i(TAG, message)
    }

    private fun logW(message: String) {
        if (shouldLog(Log.WARN)) Log.w(TAG, message)
    }

    private fun logE(message: String, throwable: Throwable? = null) {
        if (!shouldLog(Log.ERROR)) return
        if (throwable != null) {
            Log.e(TAG, message, throwable)
        } else {
            Log.e(TAG, message)
        }
    }

    fun setLogLevel(newLogLevel: Int) {
        logLevel = when (newLogLevel) {
            Log.VERBOSE, Log.DEBUG, Log.INFO, Log.WARN, Log.ERROR, Log.ASSERT -> newLogLevel
            else -> Log.WARN
        }
    }
    
    init {
        logD("init: Creating WakeWordDetector")
        logD("init: Melspectrogram model: $melspectrogramModelPath")
        logD("init: Embedding model: $embeddingModelPath")
        logD("init: Wake word model: $wakeWordModelPath")
        logD("init: Threshold: $threshold")
        logD("init: Sample rate: $sampleRate, Frame size: $frameSize, Buffer size: $bufferSize")
        
        try {
            logD("init: Interpreter options configured - threads: 4, XNNPACK: disabled, NNAPI: disabled")
            
            // Load melspectrogram model with dynamic input resizing (critical for OpenWakeWord!)
            logD("init: Loading melspectrogram model...")
            val melModelBuffer = loadModelFile(melspectrogramModelPath)
            
            // Create interpreter with options to disable problematic delegates
            melspectrogramInterpreter = Interpreter(melModelBuffer)
            
            // CRITICAL: Resize input dimensions before allocating tensors
            // OpenWakeWord mel model has dynamic input shape that must be set
            melspectrogramInterpreter.resizeInput(0, intArrayOf(1, frameSize))
            melspectrogramInterpreter.allocateTensors()
            logD("init: Melspectrogram model loaded, input resized to [1, $frameSize]")
            
            // Load embedding model
            logD("init: Loading embedding model...")
            embeddingInterpreter = Interpreter(loadModelFile(embeddingModelPath))
            embeddingInterpreter.allocateTensors()
            logD("init: Embedding model loaded successfully")
            
            // Load wake word model
            logD("init: Loading wake word model...")
            wakeWordInterpreter = Interpreter(loadModelFile(wakeWordModelPath))
            wakeWordInterpreter.allocateTensors()
            logD("init: Wake word model loaded successfully")
            
            logI("init: All models loaded successfully")
        } catch (e: Exception) {
            logE("init: Failed to load models", e)
            throw e
        }
    }
    
    private fun loadModelFile(modelPath: String): ByteBuffer {
        // Use Flutter's asset path resolver to get the correct bundled asset path
        val assetPath = flutterAssets.getAssetFilePathBySubpath(modelPath)
        logD("loadModelFile: Loading model from path: $modelPath (resolved: $assetPath)")
        try {
            val fileDescriptor = context.assets.openFd(assetPath)
            logD("loadModelFile: File descriptor obtained, start offset: ${fileDescriptor.startOffset}, length: ${fileDescriptor.declaredLength}")
            val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
            val fileChannel = inputStream.channel
            val startOffset = fileDescriptor.startOffset
            val declaredLength = fileDescriptor.declaredLength
            
            // Map the file to read it
            val mappedBuffer = fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
            
            // CRITICAL: Copy to a direct ByteBuffer to avoid file descriptor lifetime issues
            // The mapped buffer becomes invalid when the file descriptor closes
            val modelBuffer = ByteBuffer.allocateDirect(declaredLength.toInt())
            modelBuffer.put(mappedBuffer)
            modelBuffer.rewind()
            
            // Clean up file resources
            inputStream.close()
            fileDescriptor.close()
            
            logD("loadModelFile: Model loaded successfully, buffer capacity: ${modelBuffer.capacity()}")
            return modelBuffer
        } catch (e: Exception) {
            logE("loadModelFile: Failed to load model from $assetPath (original: $modelPath)", e)
            throw e
        }
    }
    
    @Synchronized
    fun startListening() {
        logD("startListening: Checking if already listening...")
        if (isListening) {
            logW("startListening: Already listening, ignoring request")
            return
        }

        val sessionId = listeningSessionId.incrementAndGet()

        logD("startListening: Clearing accumulated features from previous session")
        clearAccumulatedFeatures()
        
        logD("startListening: Creating AudioRecord with sampleRate=$sampleRate, bufferSize=$bufferSize")
        try {
            audioRecord = AudioRecord(
                MediaRecorder.AudioSource.MIC,
                sampleRate,
                channels,
                audioFormat,
                bufferSize
            )
            
            val state = audioRecord?.state
            logD("startListening: AudioRecord state: $state (STATE_INITIALIZED=${AudioRecord.STATE_INITIALIZED})")
            
            if (state != AudioRecord.STATE_INITIALIZED) {
                logE("startListening: AudioRecord failed to initialize properly")
                throw IllegalStateException("AudioRecord not properly initialized")
            }
            
            isListening = true
            audioRecord?.startRecording()
            val recordingState = audioRecord?.recordingState
            logD("startListening: Recording state: $recordingState (RECORDSTATE_RECORDING=${AudioRecord.RECORDSTATE_RECORDING})")
            
            logI("startListening: Starting audio processing thread")
            processingThread = thread(name = "WakeWordDetector-$sessionId") {
                processAudio(sessionId)
            }
        } catch (e: Exception) {
            logE("startListening: Failed to start listening", e)
            isListening = false
            listeningSessionId.incrementAndGet()
            audioRecord?.release()
            audioRecord = null
            processingThread = null
            throw e
        }
    }
    
    @Synchronized
    fun stopListening() {
        logD("stopListening: Stopping listening, current state: $isListening")
        isListening = false
        val invalidatedSessionId = listeningSessionId.incrementAndGet()
        logD("stopListening: Invalidated listening session, new session id: $invalidatedSessionId")

        val currentAudioRecord = audioRecord
        try {
            currentAudioRecord?.stop()
            logD("stopListening: AudioRecord stopped")
        } catch (e: Exception) {
            logE("stopListening: Error stopping AudioRecord", e)
        }
        try {
            currentAudioRecord?.release()
            logD("stopListening: AudioRecord released")
        } catch (e: Exception) {
            logE("stopListening: Error releasing AudioRecord", e)
        }
        audioRecord = null
        processingThread = null

        // Clear accumulated feature buffers to prevent false triggers
        logD("stopListening: Clearing accumulated feature buffers")
        clearAccumulatedFeatures()
        
        logI("stopListening: Listening stopped successfully")
    }

    private fun clearAccumulatedFeatures() {
        // Reset mel spectrogram accumulation buffer
        accumulatedMelOutputs = Array(EMB_INPUT_COUNT) { arrayOf() }
        
        // Reset embedding accumulation buffer
        accumulatedEmbOutputs = Array(WAKE_INPUT_COUNT) { floatArrayOf() }
        
        logD("clearAccumulatedFeatures: Feature buffers cleared")
    }
    
    fun setThreshold(newThreshold: Double) {
        logD("setThreshold: Changing threshold from $threshold to $newThreshold")
        threshold = newThreshold
    }
    
    private fun processAudio(sessionId: Int) {
        logI("processAudio: Audio processing thread started for session $sessionId")
        val audioBuffer = ShortArray(frameSize)
        val floatBuffer = FloatArray(frameSize)
        var frameCount = 0
        
        while (isListening && listeningSessionId.get() == sessionId) {
            val currentAudioRecord = audioRecord ?: break
            val readSize = currentAudioRecord.read(audioBuffer, 0, frameSize)

            if (!isListening || listeningSessionId.get() != sessionId) {
                logD("processAudio: Session $sessionId stopped before processing read audio")
                break
            }
            
            if (readSize > 0) {
                frameCount++
                if (frameCount % 50 == 0) { // Log every 50 frames (~4 seconds)
                    logD("processAudio: Processed $frameCount frames, last read size: $readSize")
                }
                
                // Convert to float and normalize
                for (i in 0 until readSize) {
                    floatBuffer[i] = audioBuffer[i] / 32768.0f
                }
                
                // Process through models
                try {
                    val score = detectWakeWord(floatBuffer)

                    if (!isListening || listeningSessionId.get() != sessionId) {
                        logD("processAudio: Session $sessionId stopped before wake word notification")
                        break
                    }
                    
                    if (frameCount % 50 == 0) { // Log every 50 frames
                        logD("processAudio: Wake word score: $score, threshold: $threshold")
                    }
                    
                    if (score > threshold) {
                        logI("processAudio: WAKE WORD DETECTED! Score: $score (threshold: $threshold)")
                        notifyWakeWordDetected("wake_word", score, sessionId)
                    }
                } catch (e: Exception) {
                    logE("processAudio: Error detecting wake word", e)
                }
            } else if (readSize < 0) {
                logE("processAudio: Error reading audio data, code: $readSize")
            }
        }
        
        if (processingThread === Thread.currentThread()) {
            processingThread = null
        }
        logI("processAudio: Audio processing thread stopped for session $sessionId, processed $frameCount frames total")
    }
    
    private fun detectWakeWord(audioData: FloatArray): Double {
        try {
            // Step 1: Compute melspectrogram
            val melInput = arrayOf(audioData)
            val melOutput = Array(MEL_OUTPUT_COUNT) { FloatArray(MEL_FEATURE_SIZE) }
            
            melspectrogramInterpreter.run(melInput, arrayOf(arrayOf(melOutput)))
            logV("detectWakeWord: Melspectrogram inference complete, output count: $MEL_OUTPUT_COUNT")
            
            // Accumulate mel outputs (shift old frames, add new ones)
            for (i in 0 until EMB_INPUT_COUNT) {
                accumulatedMelOutputs[i] = if (i < EMB_INPUT_COUNT - MEL_OUTPUT_COUNT) {
                    // Shift old frames forward
                    accumulatedMelOutputs[i + MEL_OUTPUT_COUNT]
                } else {
                    // Add new frame with normalization: (value / 10.0) + 2.0
                    melOutput[i - EMB_INPUT_COUNT + MEL_OUTPUT_COUNT]
                        .map { floatArrayOf((it / 10.0f) + 2.0f) }
                        .toTypedArray()
                }
            }
            
            // Check if we have enough accumulated frames
            if (accumulatedMelOutputs[0].isEmpty()) {
                return 0.0 // Not fully initialized yet
            }
            
            // Step 2: Extract embeddings
            val embOutput = Array(EMB_OUTPUT_COUNT) { FloatArray(EMB_FEATURE_SIZE) }
            embeddingInterpreter.run(arrayOf(accumulatedMelOutputs), arrayOf(arrayOf(embOutput)))
            logV("detectWakeWord: Embedding inference complete")
            
            // Accumulate embedding outputs
            for (i in 0 until WAKE_INPUT_COUNT) {
                accumulatedEmbOutputs[i] = if (i < WAKE_INPUT_COUNT - EMB_OUTPUT_COUNT) {
                    // Shift old embeddings forward
                    accumulatedEmbOutputs[i + EMB_OUTPUT_COUNT]
                } else {
                    // Add new embedding
                    embOutput[i - WAKE_INPUT_COUNT + EMB_OUTPUT_COUNT]
                }
            }
            
            // Check if we have enough accumulated embeddings
            if (accumulatedEmbOutputs[0].isEmpty()) {
                return 0.0 // Not fully initialized yet
            }
            
            // Step 3: Wake word prediction
            val wakeOutput = FloatArray(1)
            wakeWordInterpreter.run(arrayOf(accumulatedEmbOutputs), arrayOf(wakeOutput))
            logV("detectWakeWord: Wake word inference complete, score: ${wakeOutput[0]}")
            
            return wakeOutput[0].toDouble()
        } catch (e: Exception) {
            logE("detectWakeWord: Exception during detection", e)
            return 0.0
        }
    }
    
    private fun notifyWakeWordDetected(wakeWord: String, score: Double, sessionId: Int) {
        logI("notifyWakeWordDetected: Notifying Flutter - wakeWord: $wakeWord, score: $score")
        mainHandler.post {
            if (!isListening || listeningSessionId.get() != sessionId) {
                logD("notifyWakeWordDetected: Dropping stale detection for session $sessionId")
                return@post
            }
            try {
                channel.invokeMethod("onWakeWordDetected", mapOf(
                    "wakeWord" to wakeWord,
                    "score" to score
                ))
                logD("notifyWakeWordDetected: Flutter notification sent successfully")
            } catch (e: Exception) {
                logE("notifyWakeWordDetected: Failed to send notification to Flutter", e)
            }
        }
    }
    
    fun dispose() {
        logD("dispose: Disposing WakeWordDetector")
        stopListening()
        try {
            melspectrogramInterpreter.close()
            embeddingInterpreter.close()
            wakeWordInterpreter.close()
            logI("dispose: All interpreters closed successfully")
        } catch (e: Exception) {
            logE("dispose: Error closing interpreters", e)
        }
    }
}