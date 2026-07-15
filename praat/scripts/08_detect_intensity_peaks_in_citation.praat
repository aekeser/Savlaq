# Savlaq v0.8.0 diagnostic
# Detect local intensity peaks inside the citation interval

form Detect intensity peaks in citation
    sentence projectFolder C:\Users\emrek\OneDrive\Masaüstü\Savlaq
    sentence fileName M001_TR_HUMAN_TR_ADJ_001.wav
    positive minimumPitch 100
    positive timeStep 0.01
endform

audioFolder$ = projectFolder$ + "\data\examples\"
intervalFolder$ = projectFolder$ + "\measurements\diagnostics\"
outputFolder$ = projectFolder$ + "\measurements\diagnostics\"

intervalFile$ = intervalFolder$ + replace$ (fileName$, ".wav", "_speech_intervals.csv", 0)
outputFile$ = outputFolder$ + replace$ (fileName$, ".wav", "_citation_intensity_peaks.csv", 0)

filedelete 'outputFile$'
fileappend 'outputFile$' file,time,intensity,label'newline$'

Read from file: audioFolder$ + fileName$
soundName$ = selected$ ("Sound")

To Intensity: minimumPitch, 0, "yes"
intensityName$ = selected$ ("Intensity")

Read Table from comma-separated file: intervalFile$
tableName$ = selected$ ("Table")

# Citation interval = interval_index 1
selectObject: "Table " + tableName$
citationStart = Get value: 1, "start"
citationEnd = Get value: 1, "end"

t = citationStart + timeStep

while t < citationEnd - timeStep
    selectObject: "Intensity " + intensityName$

    prevIntensity = Get value at time: t - timeStep, "Cubic"
    currentIntensity = Get value at time: t, "Cubic"
    nextIntensity = Get value at time: t + timeStep, "Cubic"

    if currentIntensity > prevIntensity and currentIntensity > nextIntensity
        fileappend 'outputFile$' 'fileName$','t:6','currentIntensity:6',intensity_peak'newline$'
    endif

    t = t + timeStep
endwhile

selectObject: "Table " + tableName$
Remove
selectObject: "Intensity " + intensityName$
Remove
selectObject: "Sound " + soundName$
Remove

writeInfoLine: "Savlaq intensity peak diagnostic written to: ", outputFile$