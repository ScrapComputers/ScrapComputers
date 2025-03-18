import mido
from mido import MidiFile
import json

PERCUSSION_MAP = {
    # Instrument 1 - Kicks (0.0-0.2083)
    35: (1001, 0.0),  # Acoustic Bass Drum (kick 1)
    36: (1001, 0.0417),  # Bass Drum 1 (kick 2)

    # Instrument 1 - Snares/Toms (0.25-0.4167)
    37: (1001, 0.25),  # Side Stick (snare 1)
    38: (1001, 0.3333),  # Acoustic Snare (snare 3)
    39: (1001, 0.25),  # Hand Clap (snare 1)
    40: (1001, 0.3333),  # Electric Snare (snare 3)
    41: (1001, 0.375),  # Low Floor Tom (snare 4)
    43: (1001, 0.375),  # High Floor Tom (snare 4)
    45: (1001, 0.375),  # Low Tom (snare 4)
    47: (1001, 0.375),  # Low-Mid Tom (snare 4)
    48: (1001, 0.4167),  # Hi Mid Tom (snare 5)
    50: (1001, 0.4167),  # High Tom (snare 5)
    52: (1001, 0.3333),  # Chinese Cymbal (snare 3)
    53: (1001, 0.4167),  # Ride Bell (snare 5)
    55: (1001, 0.3333),  # Splash Cymbal (snare 3)
    58: (1001, 0.6667),  # Vibraslap (16/24 exception)

    # Instrument 1 - Secondary Percussion
    56: (1001, 0.4167),  # Cowbell (snare 5)
    60: (1001, 0.2917),  # Hi Bongo (snare 2)
    61: (1001, 0.2917),  # Low Bongo (snare 2)
    62: (1001, 0.3333),  # Mute Hi Conga (snare 3)
    63: (1001, 0.3333),  # Open Hi Conga (snare 3)
    64: (1001, 0.3333),  # Low Conga (snare 3)
    65: (1001, 0.375),  # High Timbale (snare 4)
    66: (1001, 0.375),  # Low Timbale (snare 4)
    67: (1001, 0.4167),  # High Agogo (snare 5)
    68: (1001, 0.4167),  # Low Agogo (snare 5)
    75: (1001, 0.4167),  # Claves (snare 5)
    76: (1001, 0.375),  # Hi Wood Block (snare 4)
    77: (1001, 0.375),  # Low Wood Block (snare 4)

    # Instrument 6 - Hi-Hats/Cymbals (0.4583-0.625)
    42: (1006, 0.4583),  # Closed Hi-Hat (hi-hat 1)
    44: (1006, 0.5),  # Pedal Hi-Hat (hi-hat 2)
    46: (1006, 0.5417),  # Open Hi-Hat (hi-hat 3)
    49: (1006, 0.5833),  # Crash Cymbal 1 (hi-hat 4)
    51: (1006, 0.5),  # Ride Cymbal 1 (hi-hat 2)
    54: (1006, 0.5833),  # Tambourine (hi-hat 4)
    57: (1006, 0.5833),  # Crash Cymbal 2 (hi-hat 4)
    59: (1006, 0.5),  # Ride Cymbal 2 (hi-hat 2)
    69: (1006, 0.625),  # Cabasa (hi-hat 5)
    70: (1006, 0.625),  # Maracas (hi-hat 5)
}

def get_scrap_instrument(midi_program):
    """Map MIDI program number to Scrap instrument ID based on GM categories"""
    if midi_program == 0:  # Special case for percussion channel
        return 0

    # General MIDI instrument categories mapping
    if 0 < midi_program <= 7:  # Piano
        return 3  # Sine wave
    elif 8 <= midi_program <= 15:  # Chromatic Percussion
        return 9  # Electronic pluck
    elif 16 <= midi_program <= 23:  # Organ
        return 8  # High pitched lead organ
    elif 24 <= midi_program <= 31:  # Guitar
        return 9  # Electronic pluck
    elif 32 <= midi_program <= 39:  # Bass
        return 5  # Wobble bass
    elif 40 <= midi_program <= 47:  # Strings
        return 2  # Sawtooth
    elif 48 <= midi_program <= 55:  # Ensemble
        return 7  # Triangle wave
    elif 56 <= midi_program <= 63:  # Brass
        return 7  # Triangle wave
    elif 64 <= midi_program <= 71:  # Reed
        return 7  # Triangle wave
    elif 72 <= midi_program <= 79:  # Pipe
        return 3  # Sine wave
    elif 80 <= midi_program <= 87:  # Synth Lead
        return 2  # Sawtooth
    elif 88 <= midi_program <= 95:  # Synth Pad
        return 4  # Broken
    elif 96 <= midi_program <= 103:  # Synth Effects
        return 4  # Broken
    elif 104 <= midi_program <= 111:  # Ethnic
        return 9  # Electronic pluck
    elif 112 <= midi_program <= 119:  # Percussive
        return 6  # Electronic percussion
    elif 120 <= midi_program <= 127:  # Sound Effects
        return 4  # Broken
    elif midi_program == 1001:
        return 1
    elif midi_program == 1006:
        return 6
    else:
        return 2

def midi_to_scrap_json(midi_path, output_path):
    mid = MidiFile(midi_path)
    ticks_per_beat = mid.ticks_per_beat

    current_time = 0.0
    current_tempo = 500000  # Default tempo (120 BPM)
    programs = [0] * 16  # Track program numbers for each channel
    active_notes = {}
    notes = []
    used_programs = set()

    # Process all messages in merged track
    for msg in mid.merged_track:
        # Convert delta time to seconds
        delta_time = (msg.time * current_tempo) / (1e6 * ticks_per_beat)
        current_time += delta_time

        if msg.type == 'set_tempo':
            current_tempo = msg.tempo
        elif msg.type == 'program_change':
            if msg.channel != 9:  # Ignore program changes on percussion channel
                programs[msg.channel] = msg.program
                used_programs.add(msg.program)
        elif msg.type == 'note_on' and msg.velocity > 0:
            # Handle note on
            channel = msg.channel
            note = msg.note
            instrument = 0 if channel == 9 else programs[channel]
            active_notes[(channel, note)] = (current_time, instrument)
        elif msg.type in ['note_off', 'note_on']:
            # Handle note off or note on with velocity 0
            key = (msg.channel, msg.note)
            if key in active_notes:
                start_time, instrument = active_notes.pop(key)
                duration = current_time - start_time

                if key[0] == 9:  # Percussion channel
                    percussion_data = PERCUSSION_MAP.get(key[1], None)
                    if not percussion_data:
                        continue  # Skip unmapped percussion
                    instrument, pitch = percussion_data
                    duration = max(3, duration)
                else:
                    if msg.note > 24:
                        pitch = (12 + msg.note % 12) / 24
                    else:
                        pitch = msg.note / 24
                notes.append({
                    'start': start_time,
                    'duration': duration,
                    'pitch': pitch,
                    'instrument': instrument
                })
                if instrument != 0:  # 0 is percussion, already handled
                    used_programs.add(instrument)

    # Convert to scrap ticks
    max_tick = max(int(note['start'] * 40) for note in notes) if notes else 0
    total_ticks = max_tick + 1
    json_notes = [[] for _ in range(total_ticks)]

    for note in notes:
        scrap_tick = int(note['start'] * 40)
        if 0 <= scrap_tick < total_ticks:
            duration_ticks = max(3, int(round(note['duration'] * 40)))
            json_notes[scrap_tick].append([
                round(note['pitch'], 4),
                note['instrument'],
                duration_ticks
            ])

    # Create instrument mapping (default: 0=percussion, others cycle through 2-9)
    instrument_map = {0: 1}
    for program in used_programs:
        instrument_map[program] = get_scrap_instrument(program)

    # Create output structure
    output_data = {
        "instrumentMap": instrument_map,
        "notes": json_notes
    }

    with open(output_path, 'w') as f:
        json.dump(output_data, f, separators=(',', ':'))


if __name__ == "__main__":
    midi_to_scrap_json("input.mid", "output.json")