# Savlaq Human–TTS Comparison Measures

## Objective

Extract directly comparable acoustic measures from the same linguistically defined target region in human and TTS speech.

## Measurement units

Savlaq should eventually support two complementary units:

1. Target-vowel steady-state region
2. Full target-vowel trajectory

## Core temporal measures

- Target-vowel duration
- Citation-word duration
- Target-vowel proportion of word duration

## F0 measures

- Mean F0
- Minimum F0
- Maximum F0
- F0 range
- F0 at 20%, 50%, and 80% of the target vowel
- F0 standard deviation
- F0 contour slope

## Intensity measures

- Mean intensity
- Maximum intensity
- Intensity range
- Intensity at 20%, 50%, and 80%
- Intensity standard deviation
- Intensity contour slope

## Formant measures

- F1 at 20%, 50%, and 80%
- F2 at 20%, 50%, and 80%
- Mean F1
- Mean F2
- F1 trajectory change
- F2 trajectory change
- Formant-track stability

## Signal-stability measures

- Within-vowel F0 variability
- Within-vowel intensity variability
- Within-vowel F1 variability
- Within-vowel F2 variability
- Proportion of voiced frames
- Number of pitch-tracking interruptions

## Quality-control fields

- expected_nuclei
- detected_nuclei
- nucleus_count_match
- target_region_status
- pitch_tracking_status
- formant_tracking_status
- qc_flag
- qc_notes

## Design principle

Human and TTS recordings must be processed with the same operational definitions and output schema. Differences in processing parameters must be explicitly recorded.