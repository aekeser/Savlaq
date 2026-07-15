# Savlaq Vowel Localization Strategy

## Objective

Automatically locate the target vowel within the citation form.

## Available information

### From the recording

- Audio waveform
- Spectrogram
- Pitch
- Intensity

### From the master spreadsheet

- Word
- Language
- Syllable count
- Stress pattern
- Vowel pattern
- Target vowel
- IPA transcription

## Candidate localization methods

## Candidate localization methods

### Method 1: Manual vowel annotation

Human annotator opens each TextGrid and marks the target vowel manually.

Pros:
- Highest accuracy.
- Best for difficult tokens.

Cons:
- Slow.
- Does not solve the scaling problem.

### Method 2: Rule-guided acoustic localization

Savlaq uses the citation interval plus metadata such as syllable count, stress pattern, and vowel pattern to estimate where the target vowel should occur.

Pros:
- Uses our existing master spreadsheet.
- Can reduce manual work substantially.

Cons:
- Needs validation.
- May fail for variable speech rates or unusual productions.

### Method 3: Forced alignment

Savlaq uses an external aligner to align the known word/transcription to the audio, then imports vowel boundaries.

Pros:
- Most scalable if alignment quality is good.
- Can provide word/phone-level intervals automatically.

Cons:
- Requires additional software.
- Turkish and English may need different alignment resources.
- More complex infrastructure.

## Selected strategy

(To be determined)