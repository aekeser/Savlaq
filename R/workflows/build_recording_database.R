# Savlaq
# Build recording-level database

source("R/import/join_recordings_to_master.R")

recording_database <- join_recordings_to_master(
  recording_directory = "data/examples",
  master_path = "data/metadata/Bilingual_Stimulus_Global_Master_v1.xlsx"
)
names(recording_database)[names(recording_database) == "orthographic_form"] <- "word"
write.csv(
  recording_database,
  file = "output/recording_database.csv",
  row.names = FALSE
)

message("Savlaq recording database written to output/recording_database.csv")