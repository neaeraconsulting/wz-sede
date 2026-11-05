import numpy as np
from pydub import AudioSegment
from pydub.playback import play

def generate_tone(freq=1000, duration_ms=200, volume_db=-10, add_harmonics=True):
    sample_rate = 44100
    t = np.linspace(0, duration_ms / 1000, int(sample_rate * duration_ms / 1000), False)
    
    # Generate base tone
    tone = np.sin(2 * np.pi * freq * t)
    
    # Add harmonics for sharper sound
    if add_harmonics:
        tone += 0.15 * np.sin(2 * np.pi * freq * 4 * t)  # 2nd harmonic
        tone += 0.3 * np.sin(2 * np.pi * freq * 9.2 * t)  # 3rd harmonic
    
    # Normalize and convert to int16
    tone = (tone / np.max(np.abs(tone)) * 32767).astype(np.int16)
    
    audio = AudioSegment(
        tone.tobytes(), 
        frame_rate=sample_rate,
        sample_width=2, 
        channels=1
    ).apply_gain(volume_db)
    
    return audio

# Generate a sharper success sound with higher frequencies
frequency = 350  # Lower frequency for error tone
duration = 150  # Short duration for each burst
volume = -5  # Slightly louder
pause_duration = 60  # Pause between bursts (milliseconds)

# Generate tones with harmonics
burst1 = generate_tone(freq=frequency, duration_ms=duration, volume_db=volume, add_harmonics=True)
burst2 = generate_tone(freq=frequency, duration_ms=duration, volume_db=volume, add_harmonics=True)
pause = AudioSegment.silent(duration=pause_duration)

# Combine tones with minimal fade
error_sound = burst1 + pause + burst2

# # Play the error sound
# play(error_sound)

# Optionally save the error sound to a file
error_sound.export("error.mp3", format="mp3")