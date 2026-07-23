# Savlaq Core
# First production implementation of measurement-region localization.
#
# Strategy:
#   1. Search only inside the known citation interval.
#   2. Detect filtered local intensity peaks.
#   3. Number accepted candidates chronologically.
#   4. Select the candidate corresponding to targetSyllable.
#   5. Flag any mismatch between expected and detected nuclei.

procedure localizeMeasurementRegion: soundName$, citationStart, citationEnd, expectedSyllables, targetSyllable, minimumPitch, timeStep, minimumPeakDistance, nucleusWindow

    .measurementStart = undefined
    .measurementEnd = undefined
    .measurementCenter = undefined
    .detectedNuclei = 0
    .localizationStatus$ = "failed"
    .qcFlag$ = "target_not_found"

    selectObject: "Sound " + soundName$
    To Intensity: minimumPitch, 0, "yes"
    .intensityName$ = selected$ ("Intensity")

    .lastAcceptedPeakTime = -999
    .targetTime = undefined
    .t = citationStart + timeStep

    while .t < citationEnd - timeStep
        selectObject: "Intensity " + .intensityName$

        .previousIntensity = Get value at time: .t - timeStep, "Cubic"
        .currentIntensity = Get value at time: .t, "Cubic"
        .nextIntensity = Get value at time: .t + timeStep, "Cubic"

        .isLocalPeak = .currentIntensity > .previousIntensity and .currentIntensity > .nextIntensity
        .farEnough = .t - .lastAcceptedPeakTime >= minimumPeakDistance

        if .isLocalPeak and .farEnough
            .detectedNuclei = .detectedNuclei + 1
            .lastAcceptedPeakTime = .t

            if .detectedNuclei = targetSyllable
                .targetTime = .t
            endif
        endif

        .t = .t + timeStep
    endwhile

    selectObject: "Intensity " + .intensityName$
    Remove

    if .targetTime <> undefined
        .measurementCenter = .targetTime
        .measurementStart = max (citationStart, .targetTime - nucleusWindow)
        .measurementEnd = min (citationEnd, .targetTime + nucleusWindow)

        if .detectedNuclei = expectedSyllables
            .localizationStatus$ = "accepted"
            .qcFlag$ = ""
        else
            .localizationStatus$ = "needs_review"
            .qcFlag$ = "nucleus_count_mismatch"
        endif
    endif

endproc