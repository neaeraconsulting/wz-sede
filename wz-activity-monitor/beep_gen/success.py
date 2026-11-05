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
        
        # Add short, bright overtones for attack/sharpness
        attack_duration = int(len(t) * 0.3)  # Only first 30% of sound
        envelope = np.exp(-np.linspace(0, 5, attack_duration))  # Quick decay
        
        # High frequency overtones (only at the beginning)
        bright_overtone = np.zeros_like(t)
        bright_overtone[:attack_duration] = 0.5 * np.sin(2 * np.pi * freq * 3 * t[:attack_duration]) * envelope
        tone += bright_overtone
        
        bright_overtone2 = np.zeros_like(t)
        bright_overtone2[:attack_duration] = 0.3 * np.sin(2 * np.pi * freq * 5 * t[:attack_duration]) * envelope
        tone += bright_overtone2
        
        bright_overtone2 = np.zeros_like(t)
        bright_overtone2[:attack_duration] = 0.2 * np.sin(2 * np.pi * freq * 7 * t[:attack_duration]) * envelope
        tone += bright_overtone2
        
        bright_overtone2 = np.zeros_like(t)
        bright_overtone2[:attack_duration] = 0.2 * np.sin(2 * np.pi * freq * 11 * t[:attack_duration]) * envelope
        tone += bright_overtone2
        
        bright_overtone2 = np.zeros_like(t)
        bright_overtone2[:attack_duration] = 0.2 * np.sin(2 * np.pi * freq * 13 * t[:attack_duration]) * envelope
        tone += bright_overtone2
        
        bright_overtone2 = np.zeros_like(t)
        bright_overtone2[:attack_duration] = 0.2 * np.sin(2 * np.pi * freq * 15 * t[:attack_duration]) * envelope
        tone += bright_overtone2
        
        bright_overtone2 = np.zeros_like(t)
        bright_overtone2[:attack_duration] = 0.2 * np.sin(2 * np.pi * freq * 17 * t[:attack_duration]) * envelope
        tone += bright_overtone2
        
        bright_overtone2 = np.zeros_like(t)
        bright_overtone2[:attack_duration] = 0.2 * np.sin(2 * np.pi * freq * 19 * t[:attack_duration]) * envelope
        tone += bright_overtone2
        
        bright_overtone2 = np.zeros_like(t)
        bright_overtone2[:attack_duration] = 0.15 * np.sin(2 * np.pi * freq * 25 * t[:attack_duration]) * envelope
        tone += bright_overtone2
    
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
frequency_1 = 365  # Higher frequency (was 700)
frequency_2 = 497  # Higher frequency (was 850)
duration_1 = 80    # Shorter, crisper (was 200)
duration_2 = 200    # Shorter (was 300)
volume = 5         # Louder (was -5)
fade_duration = 200  # Much shorter fade for sharper sound (was 300)

# Generate tones with harmonics
tone1 = generate_tone(freq=frequency_1, duration_ms=duration_1, volume_db=volume, add_harmonics=True)
tone2 = generate_tone(freq=frequency_2, duration_ms=duration_2, volume_db=volume, add_harmonics=True)

# Combine tones with minimal fade
success_sound = tone1 + tone2.fade_out(fade_duration)

# Optional: Add high-pass filter to remove muddy low frequencies
success_sound = success_sound.high_pass_filter(800)

# Play the success sound
# play(success_sound)

# Save the success sound to a file
success_sound.export("success.mp3", format="mp3")