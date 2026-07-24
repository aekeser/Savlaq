# Savlaq Core
# Measure intensity inside a previously localized measurement region.
#
# Outputs:
#   meanIntensity
#   minimumIntensity
#   maximumIntensity
#   intensityRange
#   intensityStatus$
#   intensityQcFlag$

procedure measureRegionIntensity: soundName$, measurementStart, measurementEnd, minimumPitch

    .meanIntensity = undefined
    .minimumIntensity = undefined
    .maximumIntensity = undefined
    .intensityRange = undefined
    .intensityStatus$ = "failed"
    .intensityQcFlag$ = "intensity_not_measured"

    if measurementStart = undefined or measurementEnd = undefined
        .intensityQcFlag$ = "measurement_region_undefined"

    elsif measurementEnd <= measurementStart
        .intensityQcFlag$ = "invalid_measurement_region"

    else
        selectObject: "Sound " + soundName$
        To Intensity: minimumPitch, 0, "yes"
        .intensityName$ = selected$ ("Intensity")

        .meanIntensity = Get mean: measurementStart, measurementEnd, "energy"
        .minimumIntensity = Get minimum: measurementStart, measurementEnd, "Parabolic"
        .maximumIntensity = Get maximum: measurementStart, measurementEnd, "Parabolic"

        if .meanIntensity <> undefined and .minimumIntensity <> undefined and .maximumIntensity <> undefined
            .intensityRange = .maximumIntensity - .minimumIntensity
            .intensityStatus$ = "accepted"
            .intensityQcFlag$ = ""
        else
            .intensityStatus$ = "rejected"
            .intensityQcFlag$ = "intensity_undefined"
        endif

        selectObject: "Intensity " + .intensityName$
        Remove
    endif

endproc