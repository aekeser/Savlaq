# Savlaq Core
# Measure F1 and F2 at the center of a previously localized region.
#
# Outputs:
#   f1
#   f2
#   formantStatus$
#   formantQcFlag$

procedure measureRegionFormants: soundName$, measurementStart, measurementEnd, maximumFormant, numberOfFormants, windowLength, preEmphasisFrom

    .f1 = undefined
    .f2 = undefined
    .formantStatus$ = "failed"
    .formantQcFlag$ = "formants_not_measured"

    if measurementStart = undefined or measurementEnd = undefined
        .formantQcFlag$ = "measurement_region_undefined"

    elsif measurementEnd <= measurementStart
        .formantQcFlag$ = "invalid_measurement_region"

    else
        .measurementCenter = (measurementStart + measurementEnd) / 2

        selectObject: "Sound " + soundName$
        To Formant (burg): 0, numberOfFormants, maximumFormant, windowLength, preEmphasisFrom
        .formantName$ = selected$ ("Formant")

        .f1 = Get value at time: 1, .measurementCenter, "Hertz", "Linear"
        .f2 = Get value at time: 2, .measurementCenter, "Hertz", "Linear"

        if .f1 <> undefined and .f2 <> undefined
            if .f1 > 0 and .f2 > .f1
                .formantStatus$ = "accepted"
                .formantQcFlag$ = ""
            else
                .formantStatus$ = "needs_review"
                .formantQcFlag$ = "implausible_formant_order"
            endif
        else
            .formantStatus$ = "rejected"
            .formantQcFlag$ = "formant_undefined"
        endif

        selectObject: "Formant " + .formantName$
        Remove
    endif

endproc