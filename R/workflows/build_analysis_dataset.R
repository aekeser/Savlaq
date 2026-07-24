# Savlaq
# Build analysis-ready dataset by joining Measurement Objects
# with the full recording-level metadata database

recording_database <- read.csv(
  "output/recording_database.csv",
  stringsAsFactors = FALSE,
  check.names = FALSE
)

measurement_objects <- read.csv(
  "output/measurement_objects.csv",
  stringsAsFactors = FALSE,
  check.names = FALSE
)

analysis_dataset <- merge(
  measurement_objects,
  recording_database,
  by.x = "recording_file",
  by.y = "recording_file",
  all.x = TRUE,
  suffixes = c("_measurement", "_metadata")
)

analysis_dataset$speaker_id <- analysis_dataset$speaker_id_measurement
analysis_dataset$source <- analysis_dataset$source_measurement
analysis_dataset$stimulus_id <- analysis_dataset$stimulus_id_measurement
analysis_dataset$word <- analysis_dataset$word_measurement

analysis_dataset <- analysis_dataset[
  , !names(analysis_dataset) %in% c(
    "speaker_id_measurement",
    "speaker_id_metadata",
    "source_measurement",
    "source_metadata",
    "stimulus_id_measurement",
    "stimulus_id_metadata",
    "word_measurement",
    "word_metadata"
  )
]

if (any(is.na(analysis_dataset$stimulus_id_metadata))) {
  missing_files <- analysis_dataset$recording_file[
    is.na(analysis_dataset$stimulus_id_metadata)
  ]
  
  stop(
    "Some Measurement Objects could not be matched to the recording database: ",
    paste(unique(missing_files), collapse = ", ")
  )
}

write.table(
  analysis_dataset,
  file = "output/analysis_dataset.csv",
  sep = ",",
  row.names = FALSE,
  col.names = TRUE,
  quote = FALSE,
  na = ""
)

message(
  "Savlaq analysis dataset written to output/analysis_dataset.csv"
)