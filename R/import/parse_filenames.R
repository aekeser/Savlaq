# Savlaq
# Parse recording filenames into metadata fields

parse_savlaq_filename <- function(filename) {
  filename_base <- basename(filename)
  filename_no_ext <- sub("\\.wav$", "", filename_base, ignore.case = TRUE)

  parts <- strsplit(filename_no_ext, "_")[[1]]

  if (length(parts) < 6) {
    stop("Filename does not match Savlaq convention: ", filename_base)
  }

  data.frame(
    recording_file = filename_base,
    speaker_id = parts[1],
    language = parts[2],
    source = parts[3],
    stimulus_id = paste(parts[4:length(parts)], collapse = "_"),
    stringsAsFactors = FALSE
  )
}

# Test parser
parse_savlaq_filename("M001_EN_HUMAN_EN_ADJ_001.wav")