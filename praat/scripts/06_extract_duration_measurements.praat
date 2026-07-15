# Savlaq v0.6.0
# Extract duration measurements from speech interval CSVs

form Extract duration measurements
    sentence projectFolder C:\Users\emrek\OneDrive\Masaüstü\Savlaq
endform

inputFolder$ = projectFolder$ + "\measurements\diagnostics\"
outputFolder$ = projectFolder$ + "\measurements\"
outputFile$ = outputFolder$ + "duration_measurements.csv"

filedelete 'outputFile$'
fileappend 'outputFile$' file,interval_index,start_time,end_time,duration,measure,measure_value'newline$'

Create Strings as file list: "csvFiles", inputFolder$ + "*_speech_intervals.csv"
numberOfFiles = Get number of strings

for f from 1 to numberOfFiles
    selectObject: "Strings csvFiles"
    csvName$ = Get string: f

    Read Table from comma-separated file: inputFolder$ + csvName$
    tableName$ = selected$ ("Table")

    numberOfRows = Get number of rows

    for r from 1 to numberOfRows
        file$ = Get value: r, "file"
        intervalIndex = Get value: r, "interval_index"
        startTime = Get value: r, "start"
        endTime = Get value: r, "end"
        duration = Get value: r, "duration"

        fileappend 'outputFile$' 'file$','intervalIndex','startTime:6','endTime:6','duration:6',duration,'duration:6''newline$'
    endfor

    selectObject: "Table " + tableName$
    Remove
endfor

selectObject: "Strings csvFiles"
Remove

writeInfoLine: "Savlaq duration measurements written to: ", outputFile$