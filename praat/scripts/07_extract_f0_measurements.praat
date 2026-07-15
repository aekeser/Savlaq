# Savlaq v0.7.0
# Extract F0 measurements from speech interval CSVs

form Extract F0 measurements
    sentence projectFolder C:\Users\emrek\OneDrive\Masaüstü\Savlaq
    positive pitchFloor 75
    positive pitchCeiling 500
endform

audioFolder$ = projectFolder$ + "\data\examples\"
intervalFolder$ = projectFolder$ + "\measurements\diagnostics\"
outputFolder$ = projectFolder$ + "\measurements\"
outputFile$ = outputFolder$ + "f0_measurements.csv"

filedelete 'outputFile$'
fileappend 'outputFile$' file,interval_index,start_time,end_time,measure,measure_value'newline$'

Create Strings as file list: "csvFiles", intervalFolder$ + "*_speech_intervals.csv"
numberOfFiles = Get number of strings

for f from 1 to numberOfFiles
    selectObject: "Strings csvFiles"
    csvName$ = Get string: f
    wavName$ = replace$ (csvName$, "_speech_intervals.csv", ".wav", 0)

    Read from file: audioFolder$ + wavName$
    soundName$ = selected$ ("Sound")

    To Pitch: 0, pitchFloor, pitchCeiling
    pitchName$ = selected$ ("Pitch")

    Read Table from comma-separated file: intervalFolder$ + csvName$
    tableName$ = selected$ ("Table")
    numberOfRows = Get number of rows

    for r from 1 to numberOfRows
        selectObject: "Table " + tableName$

        file$ = Get value: r, "file"
        intervalIndex = Get value: r, "interval_index"
        startTime = Get value: r, "start"
        endTime = Get value: r, "end"

        selectObject: "Pitch " + pitchName$

        meanF0 = Get mean: startTime, endTime, "Hertz"
        minF0 = Get minimum: startTime, endTime, "Hertz", "Parabolic"
        maxF0 = Get maximum: startTime, endTime, "Hertz", "Parabolic"

        fileappend 'outputFile$' 'file$','intervalIndex','startTime:6','endTime:6',mean_f0,'meanF0:6''newline$'
        fileappend 'outputFile$' 'file$','intervalIndex','startTime:6','endTime:6',min_f0,'minF0:6''newline$'
        fileappend 'outputFile$' 'file$','intervalIndex','startTime:6','endTime:6',max_f0,'maxF0:6''newline$'
    endfor

    selectObject: "Table " + tableName$
    Remove
    selectObject: "Pitch " + pitchName$
    Remove
    selectObject: "Sound " + soundName$
    Remove
endfor

selectObject: "Strings csvFiles"
Remove

writeInfoLine: "Savlaq F0 measurements written to: ", outputFile$