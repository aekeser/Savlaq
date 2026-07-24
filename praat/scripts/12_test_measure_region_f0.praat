# Savlaq
# Test runner connecting measurement-region localization to F0 measurement

include ../core/localize_measurement_region.praat
include ../core/measure_region_f0.praat

form Test localized F0 measurement
    sentence projectFolder C:\Users\emrek\OneDrive\Masaüstü\Savlaq
    sentence fileName F001_EN_HUMAN_EN_ADJ_001.wav
    positive expectedSyllables 3
    positive targetSyllable 1
    positive pitchFloor 75
    positive pitchCeiling 500
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

@measureRegionF0: soundName$, measurementStart, measurementEnd, pitchFloor, pitchCeiling

overallStatus$ = "accepted"
overallQcFlag$ = ""

if localizationStatus$ = "failed" or measureRegionF0.pitchStatus$ = "rejected"
    overallStatus$ = "rejected"
elsif localizationStatus$ = "needs_review" or measureRegionF0.pitchStatus$ = "needs_review"
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

writeInfoLine: "file = ", fileName$
appendInfoLine: ""
appendInfoLine: "Localization"
appendInfoLine: "measurementStart = ", fixed$ (measurementStart, 6)
appendInfoLine: "measurementEnd = ", fixed$ (measurementEnd, 6)
appendInfoLine: "measurementCenter = ", fixed$ (measurementCenter, 6)
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

selectObject: "Table " + tableName$
Remove

selectObject: "Sound " + soundName$
Remove

appendInfoLine: ""
appendInfoLine: "Overall"
appendInfoLine: "overallStatus = ", overallStatus$
appendInfoLine: "overallQcFlag = ", overallQcFlag$