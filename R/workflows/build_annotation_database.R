# Savlaq
# Build annotation-level database from recording database and speech interval CSVs

recording_database <- read.csv(
  "output/recording_database.csv",
  stringsAsFactors = FALSE
)

interval_files <- list.files(
  path = "measurements/diagnostics",
  pattern = "_speech_intervals\\.csv$",
  full.names = TRUE
)

if (length(interval_files) == 0) {
  stop("No speech interval CSV files found in measurements/diagnostics.")
}

speech_intervals <- do.call(
  rbind,
  lapply(interval_files, read.csv, stringsAsFactors = FALSE)
)

annotation_database <- merge(
  speech_intervals,
  recording_database,
  by.x = "file",
  by.y = "recording_file",
  all.x = TRUE
)

annotation_database$task_region <- ifelse(
  annotation_database$interval_index == 1,
  "citation",
  "sentence_fragment"
)

annotation_database$annotation_status <- "auto_detected"
annotation_database$qc_flag <- NA
annotation_database$qc_notes <- NA

write.csv(
  annotation_database,
  file = "output/annotation_database.csv",
  row.names = FALSE
)

message("Savlaq annotation database written to output/annotation_database.csv")