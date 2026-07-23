# Savlaq
# Test runner for the core measurement-region localizer

include ../core/localize_measurement_region.praat

form Test measurement-region localization
    sentence projectFolder C:\Users\emrek\OneDrive\Masaüstü\Savlaq
    sentence fileName TM001_EN_ELEVENLABS_EN_ADJ_001.wav
    positive expectedSyllables 3
    positive targetSyllable 1
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

writeInfoLine: "file = ", fileName$
appendInfoLine: "citationStart = ", fixed$ (citationStart, 6)
appendInfoLine: "citationEnd = ", fixed$ (citationEnd, 6)
appendInfoLine: "measurementStart = ", fixed$ (localizeMeasurementRegion.measurementStart, 6)
appendInfoLine: "measurementEnd = ", fixed$ (localizeMeasurementRegion.measurementEnd, 6)
appendInfoLine: "measurementCenter = ", fixed$ (localizeMeasurementRegion.measurementCenter, 6)
appendInfoLine: "detectedNuclei = ", localizeMeasurementRegion.detectedNuclei
appendInfoLine: "localizationStatus = ", localizeMeasurementRegion.localizationStatus$
appendInfoLine: "qcFlag = ", localizeMeasurementRegion.qcFlag$

selectObject: "Table " + tableName$
Remove

selectObject: "Sound " + soundName$
Remove