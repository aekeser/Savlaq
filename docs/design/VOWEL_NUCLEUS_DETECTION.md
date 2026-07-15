# Savlaq Vowel Nucleus Detection

## Objective

Automatically locate vowel nuclei inside the citation interval.

## Available acoustic information

- Waveform
- Spectrogram
- Intensity
- Pitch
- Formants

## Available linguistic information

- Language
- Orthographic form
- Syllable count
- Stress pattern
- Target vowel

## Candidate acoustic cues

- Intensity peaks
- Stable voicing
- Formant stability
- Spectral energy

## Validation strategy

Compare automatically detected vowel nuclei with manually inspected recordings.

## TextGrid annotation goal

Savlaq should automatically write candidate vowel nuclei into the `vowels` tier.

Initial annotation format:

- `V1`
- `V2`
- `V3`

Target vowel annotation format:

- `TARGET_VOWEL`

Example for sevecen:

- V1 = first /e/
- V2 = second /e/
- V3 = final /e/
- TARGET_VOWEL = V3