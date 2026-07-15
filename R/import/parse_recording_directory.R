# Savlaq
# Parse all WAV filenames in a recording directory

source("R/import/parse_filenames.R")

parse_recording_directory <- function(directory = "data/examples") {
  wav_files <- list.files(
    path = directory,
    pattern = "\\.wav$",
    full.names = FALSE,
    ignore.case = TRUE
  )
  
  if (length(wav_files) == 0) {
    stop("No WAV files found in directory: ", directory)
  }
  
  parsed <- do.call(
    rbind,
    lapply(wav_files, parse_savlaq_filename)
  )
  
  rownames(parsed) <- NULL
  parsed
}

# Test
parse_recording_directory("data/examples")