# Savlaq Core
# Measure F0 inside a previously localized measurement region.
#
# Outputs:
#   meanF0
#   minimumF0
#   maximumF0
#   f0Range
#   voicedFrameCoverage
#   pitchStatus$
#   pitchQcFlag$

procedure measureRegionF0: soundName$, measurementStart, measurementEnd, pitchFloor, pitchCeiling

    .meanF0 = undefined
    .minimumF0 = undefined
    .maximumF0 = undefined
    .f0Range = undefined
    .voicedFrameCoverage = undefined
    .pitchStatus$ = "failed"
    .pitchQcFlag$ = "pitch_not_measured"

    if measurementStart = undefined or measurementEnd = undefined
        .pitchQcFlag$ = "measurement_region_undefined"
    elsif measurementEnd <= measurementStart
        .pitchQcFlag$ = "invalid_measurement_region"
    else
        selectObject: "Sound " + soundName$
        To Pitch: 0, pitchFloor, pitchCeiling
        .pitchName$ = selected$ ("Pitch")

        .meanF0 = Get mean: measurementStart, measurementEnd, "Hertz"
        .minimumF0 = Get minimum: measurementStart, measurementEnd, "Hertz", "Parabolic"
        .maximumF0 = Get maximum: measurementStart, measurementEnd, "Hertz", "Parabolic"

        .numberOfFrames = Get number of frames
        .framesInRegion = 0
        .voicedFramesInRegion = 0

        for .frame from 1 to .numberOfFrames
            .frameTime = Get time from frame number: .frame

            if .frameTime >= measurementStart and .frameTime <= measurementEnd
                .framesInRegion = .framesInRegion + 1
                .frameF0 = Get value in frame: .frame, "Hertz"

                if .frameF0 <> undefined
                    .voicedFramesInRegion = .voicedFramesInRegion + 1
                endif
            endif
        endfor

        if .framesInRegion > 0
            .voicedFrameCoverage = .voicedFramesInRegion / .framesInRegion
        endif

        if .meanF0 <> undefined and .minimumF0 <> undefined and .maximumF0 <> undefined
            .f0Range = .maximumF0 - .minimumF0

            if .voicedFrameCoverage >= 0.8
                .pitchStatus$ = "accepted"
                .pitchQcFlag$ = ""
            elsif .voicedFrameCoverage >= 0.5
                .pitchStatus$ = "needs_review"
                .pitchQcFlag$ = "low_voiced_frame_coverage"
            else
                .pitchStatus$ = "rejected"
                .pitchQcFlag$ = "insufficient_voicing"
            endif
        else
            .pitchStatus$ = "rejected"
            .pitchQcFlag$ = "f0_undefined"
        endif

        selectObject: "Pitch " + .pitchName$
        Remove
    endif

endproc