# Savlaq
# Build target-vowel planning table

source("R/import/join_recordings_to_master.R")

recording_database <- join_recordings_to_master(
  recording_directory = "data/examples",
  master_path = "data/metadata/Bilingual_Stimulus_Global_Master_v1.xlsx"
)

names(recording_database)[names(recording_database) == "orthographic_form"] <- "word"

target_vowel_plan <- recording_database[, c(
  "recording_file",
  "speaker_id",
  "source",
  "language_recording",
  "stimulus_id",
  "word",
  "citation_prompt",
  "syllable_count",
  "stress_pattern",
  "stressed_syllable_number",
  "vowel_pattern",
  "target_vowel_for_F1F2"
)]

write.table(
  target_vowel_plan,
  file = "output/target_vowel_plan.csv",
  sep = ",",
  row.names = FALSE,
  col.names = TRUE,
  quote = FALSE,
  na = ""
)

message("Savlaq target-vowel plan written to output/target_vowel_plan.csv")