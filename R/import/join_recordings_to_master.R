# Savlaq
# Join parsed recording metadata to master stimulus metadata

source("R/import/parse_recording_directory.R")
source("R/import/read_master_stimuli.R")

join_recordings_to_master <- function(
    recording_directory = "data/examples",
    master_path = "data/metadata/Bilingual_Stimulus_Global_Master_v1.xlsx"
) {
  recordings <- parse_recording_directory(recording_directory)
  stimuli <- read_master_stimuli(master_path)
  
  merged <- merge(
    recordings,
    stimuli,
    by = "stimulus_id",
    all.x = TRUE,
    suffixes = c("_recording", "_master")
  )
  
  if (any(merged$language_recording == "EN" & merged$language_master != "English")) {
    stop("Language mismatch detected for English recordings.")
  }
  
  if (any(merged$language_recording == "TR" & merged$language_master != "Turkish")) {
    stop("Language mismatch detected for Turkish recordings.")
  }
  
  if (any(is.na(merged$orthographic_form))) {
    missing_ids <- unique(merged$stimulus_id[is.na(merged$orthographic_form)])
    stop(
      "Some recording stimulus IDs were not found in the master spreadsheet: ",
      paste(missing_ids, collapse = ", ")
    )
  }
  
  merged
}

# Test
join_recordings_to_master()