# Savlaq
# Integrated test runner for one complete Measurement Object

include ../core/localize_measurement_region.praat
include ../core/measure_region_f0.praat
include ../core/measure_region_intensity.praat
include ../core/measure_region_formants.praat

form Test full measurement object
    sentence projectFolder C:\Users\emrek\OneDrive\Masaüstü\Savlaq
    sentence fileName F001_EN_HUMAN_EN_ADJ_001.wav

    positive expectedSyllables 3
    positive targetSyllable 1

    positive pitchFloor 75
    positive pitchCeiling 500

    positive intensityMinimumPitch 100

    positive maximumFormant 5500
    positive numberOfFormants 5
    positive formantWindowLength 0.025
    positive preEmphasisFrom 50
endform

audioFolder$ = projectFolder$ + "\data\examples\"
intervalFolder$ = projectFolder$ + "\measurements\diagnostics\"

intervalFile$ = intervalFolder$ + replace$ (fileName$, ".wav", "_speech_intervals.csv", 0)

Read from file: audioFolder$ + fileName$
soundName$ = selected$ ("Sound")

Read Table from comma-separated file: intervalFile$
tableName$ = selected$ ("Table")

selectObject: "Table " + tableName$
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

writeInfoLine: "file = ", fileName$

appendInfoLine: ""
appendInfoLine: "Localization"
appendInfoLine: "citationStart = ", fixed$ (citationStart, 6)
appendInfoLine: "citationEnd = ", fixed$ (citationEnd, 6)
appendInfoLine: "measurementStart = ", fixed$ (measurementStart, 6)
appendInfoLine: "measurementEnd = ", fixed$ (measurementEnd, 6)
appendInfoLine: "measurementCenter = ", fixed$ (measurementCenter, 6)
appendInfoLine: "measurementDuration = ", fixed$ (measurementDuration, 6)
appendInfoLine: "detectedNuclei = ", detectedNuclei
appendInfoLine: "localizationStatus = ", localizationStatus$
appendInfoLine: "localizationQcFlag = ", localizationQcFlag$

appendInfoLine: ""
appendInfoLine: "F0"
appendInfoLine: "meanF0 = ", fixed$ (measureRegionF0.meanF0, 6)
appendInfoLine: "minimumF0 = ", fixed$ (measureRegionF0.minimumF0, 6)
appendInfoLine: "maximumF0 = ", fixed$ (measureRegionF0.maximumF0, 6)
appendInfoLine: "f0Range = ", fixed$ (measureRegionF0.f0Range, 6)
appendInfoLine: "voicedFrameCoverage = ", fixed$ (measureRegionF0.voicedFrameCoverage, 6)
appendInfoLine: "pitchStatus = ", measureRegionF0.pitchStatus$
appendInfoLine: "pitchQcFlag = ", measureRegionF0.pitchQcFlag$

appendInfoLine: ""
appendInfoLine: "Intensity"
appendInfoLine: "meanIntensity = ", fixed$ (measureRegionIntensity.meanIntensity, 6)
appendInfoLine: "minimumIntensity = ", fixed$ (measureRegionIntensity.minimumIntensity, 6)
appendInfoLine: "maximumIntensity = ", fixed$ (measureRegionIntensity.maximumIntensity, 6)
appendInfoLine: "intensityRange = ", fixed$ (measureRegionIntensity.intensityRange, 6)
appendInfoLine: "intensityStatus = ", measureRegionIntensity.intensityStatus$
appendInfoLine: "intensityQcFlag = ", measureRegionIntensity.intensityQcFlag$

appendInfoLine: ""
appendInfoLine: "Formants"
appendInfoLine: "f1 = ", fixed$ (measureRegionFormants.f1, 6)
appendInfoLine: "f2 = ", fixed$ (measureRegionFormants.f2, 6)
appendInfoLine: "formantStatus = ", measureRegionFormants.formantStatus$
appendInfoLine: "formantQcFlag = ", measureRegionFormants.formantQcFlag$

appendInfoLine: ""
appendInfoLine: "Overall"
appendInfoLine: "overallStatus = ", overallStatus$
appendInfoLine: "overallQcFlag = ", overallQcFlag$

selectObject: "Table " + tableName$
Remove

selectObject: "Sound " + soundName$
Remove