# Savlaq Vowel Nucleus Validation

## Goal

Validate whether Savlaq's predicted target-vowel nucleus corresponds to the intended acoustic vowel nucleus.

## Operational definition

The target-vowel nucleus is the point within the target syllable that best represents the vowel's acoustic steady-state region.

## Validation criteria

A predicted nucleus is acceptable if:

1. It falls inside the intended target vowel.
2. It occurs during voicing.
3. It is near a local intensity maximum.
4. F1 and F2 are visible/trackable.
5. Manual inspection confirms the point on a validation subset.

## Confidence level

Savlaq should not claim 100% certainty.

Instead, each predicted nucleus should receive a validation status:

- accepted
- needs_review
- rejected

## Next implementation goal

Automatically annotate candidate vowel nuclei in the TextGrid `vowels` tier so they can be visually inspected.