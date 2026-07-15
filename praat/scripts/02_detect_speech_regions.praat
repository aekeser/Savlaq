# Savlaq v0.2.0
# Detect speech/silence regions for one WAV file

form Detect speech regions
    sentence projectFolder C:\Users\emrek\OneDrive\Masaüstü\Savlaq
    sentence fileName M001_EN_HUMAN_EN_ADJ_001.wav
endform

inputFolder$ = projectFolder$ + "\data\examples\"
outputFolder$ = projectFolder$ + "\textgrids\"

Read from file: inputFolder$ + fileName$
soundName$ = selected$ ("Sound")

To TextGrid (silences): 100, 0, -25, 0.1, 0.1, "silent", "sounding"

Save as text file: outputFolder$ + replace$ (fileName$, ".wav", "_silence_test.TextGrid", 0)

writeInfoLine: "Savlaq v0.2.0 test complete: silence-detection TextGrid created."