# Savlaq
# Batch-export one complete Measurement Object per recording

include ../core/localize_measurement_region.praat
include ../core/measure_region_f0.praat
include ../core/measure_region_intensity.praat
include ../core/measure_region_formants.praat

# Non-interactive Savlaq settings

projectFolder$ = "C:/Users/emrek/OneDrive/Masaüstü/Savlaq"

pitchFloor = 75
pitchCeiling = 500
intensityMinimumPitch = 100

maximumFormant = 5500
numberOfFormants = 5
formantWindowLength = 0.025
preEmphasisFrom = 50

audioFolder$ = projectFolder$ + "\data\examples\"
intervalFolder$ = projectFolder$ + "\measurements\diagnostics\"
planFile$ = projectFolder$ + "\output\target_vowel_plan.csv"
outputFile$ = projectFolder$ + "\output\measurement_objects.csv"

filedelete 'outputFile$'
fileappend 'outputFile$' recording_file,speaker_id,source,language,stimulus_id,word,expected_syllables,target_syllable,citation_start,citation_end,measurement_start,measurement_end,measurement_center,measurement_duration,detected_nuclei,localization_status,localization_qc_flag,mean_f0,minimum_f0,maximum_f0,f0_range,voiced_frame_coverage,pitch_status,pitch_qc_flag,mean_intensity,minimum_intensity,maximum_intensity,intensity_range,intensity_status,intensity_qc_flag,f1,f2,formant_status,formant_qc_flag,overall_status,overall_qc_flag'newline$'

Read Table from comma-separated file: planFile$
planTableName$ = selected$ ("Table")
numberOfRecordings = Get number of rows

for r from 1 to numberOfRecordings
    selectObject: "Table " + planTableName$

    fileName$ = Get value: r, "recording_file"
    speakerId$ = Get value: r, "speaker_id"
    source$ = Get value: r, "source"
    language$ = Get value: r, "language_recording"
    stimulusId$ = Get value: r, "stimulus_id"
    word$ = Get value: r, "word"

    expectedSyllables = Get value: r, "syllable_count"
    targetSyllable = Get value: r, "stressed_syllable_number"

    intervalFile$ = intervalFolder$ + replace$ (fileName$, ".wav", "_speech_intervals.csv", 0)

    Read from file: audioFolder$ + fileName$
    soundName$ = selected$ ("Sound")

    Read Table from comma-separated file: intervalFile$
    intervalTableName$ = selected$ ("Table")

    selectObject: "Table " + intervalTableName$
    citationStart = Get value: 1, "start"
    citationEnd = Get value: 1, "end"

    @localizeMeasurementRegion: soundName$, citationStart, citationEnd, expectedSyllables, targetSyllable, 100, 0.01, 0.12, 0.03

    measurementStart = localizeMeasurementRegion.measurementStart
    measurementEnd = localizeMeasurementRegion.measurementEnd
    measurementCenter = localizeMeasurementRegion.measurementCenter
    detectedNuclei = localizeMeasurementRegion.detectedNuclei
    localizationStatus$ = localizeMeasurementRegion.localizationStatus$
    localizationQcFlag$ = localizeMeasurementRegion.qcFlag$

    measurementDuration = measurementEnd - measurementStart

    @measureRegionF0: soundName$, measurementStart, measurementEnd, pitchFloor, pitchCeiling
    @measureRegionIntensity: soundName$, measurementStart, measurementEnd, intensityMinimumPitch
    @measureRegionFormants: soundName$, measurementStart, measurementEnd, maximumFormant, numberOfFormants, formantWindowLength, preEmphasisFrom

    overallStatus$ = "accepted"
    overallQcFlag$ = ""

    if localizationStatus$ = "failed" or measureRegionF0.pitchStatus$ = "rejected" or measureRegionIntensity.intensityStatus$ = "rejected" or measureRegionFormants.formantStatus$ = "rejected"
        overallStatus$ = "rejected"
    elsif localizationStatus$ = "needs_review" or measureRegionF0.pitchStatus$ = "needs_review" or measureRegionIntensity.intensityStatus$ = "needs_review" or measureRegionFormants.formantStatus$ = "needs_review"
        overallStatus$ = "needs_review"
    endif

    if localizationQcFlag$ <> ""
        overallQcFlag$ = localizationQcFlag$
    endif

    if measureRegionF0.pitchQcFlag$ <> ""
        if overallQcFlag$ = ""
            overallQcFlag$ = measureRegionF0.pitchQcFlag$
        else
            overallQcFlag$ = overallQcFlag$ + ";" + measureRegionF0.pitchQcFlag$
        endif
    endif

    if measureRegionIntensity.intensityQcFlag$ <> ""
        if overallQcFlag$ = ""
            overallQcFlag$ = measureRegionIntensity.intensityQcFlag$
        else
            overallQcFlag$ = overallQcFlag$ + ";" + measureRegionIntensity.intensityQcFlag$
        endif
    endif

    if measureRegionFormants.formantQcFlag$ <> ""
        if overallQcFlag$ = ""
            overallQcFlag$ = measureRegionFormants.formantQcFlag$
        else
            overallQcFlag$ = overallQcFlag$ + ";" + measureRegionFormants.formantQcFlag$
        endif
    endif

    fileappend 'outputFile$' 'fileName$','speakerId$','source$','language$','stimulusId$','word$','expectedSyllables','targetSyllable','citationStart:6','citationEnd:6','measurementStart:6','measurementEnd:6','measurementCenter:6','measurementDuration:6','detectedNuclei','localizationStatus$','localizationQcFlag$','measureRegionF0.meanF0:6','measureRegionF0.minimumF0:6','measureRegionF0.maximumF0:6','measureRegionF0.f0Range:6','measureRegionF0.voicedFrameCoverage:6','measureRegionF0.pitchStatus$','measureRegionF0.pitchQcFlag$','measureRegionIntensity.meanIntensity:6','measureRegionIntensity.minimumIntensity:6','measureRegionIntensity.maximumIntensity:6','measureRegionIntensity.intensityRange:6','measureRegionIntensity.intensityStatus$','measureRegionIntensity.intensityQcFlag$','measureRegionFormants.f1:6','measureRegionFormants.f2:6','measureRegionFormants.formantStatus$','measureRegionFormants.formantQcFlag$','overallStatus$','overallQcFlag$''newline$'

    selectObject: "Table " + intervalTableName$
    Remove

    selectObject: "Sound " + soundName$
    Remove
endfor

selectObject: "Table " + planTableName$
Remove

writeInfoLine: "Savlaq batch export complete: ", numberOfRecordings, " Measurement Objects written to ", outputFile$