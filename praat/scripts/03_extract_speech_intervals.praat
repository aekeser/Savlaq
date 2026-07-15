# Savlaq v0.3.0 diagnostic
# Extract and print speech intervals from one WAV file

form Extract speech intervals
    sentence projectFolder C:\Users\emrek\OneDrive\Masaüstü\Savlaq
    sentence fileName M001_EN_HUMAN_EN_ADJ_001.wav
endform

inputFolder$ = projectFolder$ + "\data\examples\"

Read from file: inputFolder$ + fileName$
soundName$ = selected$ ("Sound")

To TextGrid (silences): 100, 0, -25, 0.1, 0.1, "silent", "sounding"
silenceGridName$ = selected$ ("TextGrid")

numberOfIntervals = Get number of intervals: 1

writeInfoLine: "file,start,end,label"

for i from 1 to numberOfIntervals
    label$ = Get label of interval: 1, i

    if label$ = "sounding"
        startTime = Get start time of interval: 1, i
        endTime = Get end time of interval: 1, i

        appendInfoLine: fileName$, ",", fixed$ (startTime, 6), ",", fixed$ (endTime, 6), ",", label$
    endif
endfor

selectObject: "TextGrid " + silenceGridName$
Remove
selectObject: "Sound " + soundName$
Remove