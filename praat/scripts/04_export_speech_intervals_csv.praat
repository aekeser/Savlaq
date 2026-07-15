# Savlaq v0.4.0
# Export detected speech intervals to CSV

form Export speech intervals CSV
    sentence projectFolder C:\Users\emrek\OneDrive\Masaüstü\Savlaq
    sentence fileName M001_EN_HUMAN_EN_ADJ_001.wav
endform

inputFolder$ = projectFolder$ + "\data\examples\"
outputFolder$ = projectFolder$ + "\measurements\diagnostics\"
outputFile$ = outputFolder$ + replace$ (fileName$, ".wav", "_speech_intervals.csv", 0)

filedelete 'outputFile$'
fileappend 'outputFile$' file,interval_index,start,end,duration,label'newline$'

Read from file: inputFolder$ + fileName$
soundName$ = selected$ ("Sound")

To TextGrid (silences): 100, 0, -25, 0.1, 0.1, "silent", "sounding"
silenceGridName$ = selected$ ("TextGrid")

numberOfIntervals = Get number of intervals: 1
speechIndex = 0

for i from 1 to numberOfIntervals
    label$ = Get label of interval: 1, i

    if label$ = "sounding"
        speechIndex = speechIndex + 1
        startTime = Get start time of interval: 1, i
        endTime = Get end time of interval: 1, i
        duration = endTime - startTime

        fileappend 'outputFile$' 'fileName$','speechIndex','startTime:6','endTime:6','duration:6','label$''newline$'
    endif
endfor

selectObject: "TextGrid " + silenceGridName$
Remove
selectObject: "Sound " + soundName$
Remove

writeInfoLine: "Savlaq exported speech intervals to: ", outputFile$