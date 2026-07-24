# Savlaq
# Stage 2: Build recording database

build_recording_database_stage <- function(validation) {
  
  if (!identical(validation$status, "validated")) {
    stop("Stage 2 requires successful Stage 1 validation.")
  }
  
  source("R/import/join_recordings_to_master.R")
  
  recording_database <- join_recordings_to_master(
    recording_directory = "data/examples",
    master_path = "data/metadata/Bilingual_Stimulus_Global_Master_v1.xlsx"
  )
  
  names(recording_database)[
    names(recording_database) == "orthographic_form"
  ] <- "word"
  
  output_file <- "output/recording_database.csv"
  
  write.csv(
    recording_database,
    file = output_file,
    row.names = FALSE
  )
  
  result <- list(
    status = "completed",
    recording_count = nrow(recording_database),
    output_file = normalizePath(
      output_file,
      winslash = "/",
      mustWork = TRUE
    )
  )
  
  message(
    "Savlaq Stage 2 passed: ",
    result$recording_count,
    " recordings written."
  )
  
  invisible(result)
}