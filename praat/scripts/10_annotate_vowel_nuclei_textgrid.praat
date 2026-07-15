# Savlaq v0.10.0 diagnostic
# Annotate candidate vowel nuclei in the vowels tier

form Annotate vowel nuclei
    sentence projectFolder C:\Users\emrek\OneDrive\Masaüstü\Savlaq
    sentence fileName M001_TR_HUMAN_TR_ADJ_001.wav
    positive nucleusWindow 0.03
endform

audioFolder$ = projectFolder$ + "\data\examples\"
textgridFolder$ = projectFolder$ + "\textgrids\"
peakFolder$ = projectFolder$ + "\measurements\diagnostics\"
outputFolder$ = projectFolder$ + "\textgrids\"

baseName$ = replace$ (fileName$, ".wav", "", 0)
textgridFile$ = textgridFolder$ + baseName$ + ".TextGrid"
peakFile$ = peakFolder$ + baseName$ + "_filtered_intensity_peaks.csv"
outputFile$ = outputFolder$ + baseName$ + "_vowel_nuclei.TextGrid"

Read from file: audioFolder$ + fileName$
soundName$ = selected$ ("Sound")

Read from file: textgridFile$
textgridName$ = selected$ ("TextGrid")

Read Table from comma-separated file: peakFile$
tableName$ = selected$ ("Table")

numberOfRows = Get number of rows

for r from 1 to numberOfRows
    selectObject: "Table " + tableName$
    nucleusTime = Get value: r, "time"

    startTime = nucleusTime - nucleusWindow
    endTime = nucleusTime + nucleusWindow

    selectObject: "TextGrid " + textgridName$

    Insert boundary: 5, startTime
    Insert boundary: 5, endTime

    label$ = "V" + string$ (r)
    Set interval text: 5, r + 1, label$
endfor

# Mark the final nucleus as TARGET_VOWEL for this diagnostic case
selectObject: "Table " + tableName$
targetTime = Get value: numberOfRows, "time"

targetStart = targetTime - nucleusWindow
targetEnd = targetTime + nucleusWindow

selectObject: "TextGrid " + textgridName$
Set interval text: 5, numberOfRows + 1, "TARGET_VOWEL"

Save as text file: outputFile$

selectObject: "Table " + tableName$
Remove
selectObject: "TextGrid " + textgridName$
Remove
selectObject: "Sound " + soundName$
Remove

writeInfoLine: "Savlaq vowel nuclei TextGrid written to: ", outputFile$