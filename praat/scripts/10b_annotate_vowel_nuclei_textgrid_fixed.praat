# Savlaq v0.10b diagnostic
# Annotate vowel nuclei in TextGrid with corrected interval targeting

form Annotate vowel nuclei fixed
    sentence projectFolder C:\Users\emrek\OneDrive\Masaüstü\Savlaq
    sentence fileName M001_TR_HUMAN_TR_ADJ_001.wav
    positive nucleusWindow 0.03
    positive targetSyllable 3
endform

audioFolder$ = projectFolder$ + "\data\examples\"
textgridFolder$ = projectFolder$ + "\textgrids\"
peakFolder$ = projectFolder$ + "\measurements\diagnostics\"
outputFolder$ = projectFolder$ + "\textgrids\"

baseName$ = replace$ (fileName$, ".wav", "", 0)
textgridFile$ = textgridFolder$ + baseName$ + ".TextGrid"
peakFile$ = peakFolder$ + baseName$ + "_filtered_intensity_peaks.csv"
outputFile$ = outputFolder$ + baseName$ + "_vowel_nuclei_fixed.TextGrid"

Read from file: audioFolder$ + fileName$
soundName$ = selected$ ("Sound")

Read from file: textgridFile$
textgridName$ = selected$ ("TextGrid")

Read Table from comma-separated file: peakFile$
tableName$ = selected$ ("Table")

numberOfRows = Get number of rows

# First insert all boundaries
for r from 1 to numberOfRows
    selectObject: "Table " + tableName$
    nucleusTime = Get value: r, "time"

    startTime = nucleusTime - nucleusWindow
    endTime = nucleusTime + nucleusWindow

    selectObject: "TextGrid " + textgridName$

    Insert boundary: 5, startTime
    Insert boundary: 5, endTime
endfor

# Then label intervals by locating the interval containing each nucleus time
for r from 1 to numberOfRows
    selectObject: "Table " + tableName$
    nucleusTime = Get value: r, "time"

    selectObject: "TextGrid " + textgridName$
    intervalNumber = Get interval at time: 5, nucleusTime

    if r = targetSyllable
        label$ = "TARGET_VOWEL"
    else
        label$ = "V" + string$ (r)
    endif

    Set interval text: 5, intervalNumber, label$
endfor

Save as text file: outputFile$

selectObject: "Table " + tableName$
Remove
selectObject: "TextGrid " + textgridName$
Remove
selectObject: "Sound " + soundName$
Remove

writeInfoLine: "Savlaq fixed vowel nuclei TextGrid written to: ", outputFile$