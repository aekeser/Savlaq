# Savlaq
# Stage 3: Build target-vowel planning table

build_target_vowel_plan_stage <- function(validation) {
  
  if (!identical(validation$status, "validated")) {
    stop("Stage 3 requires successful Stage 1 validation.")
  }
  
  source("R/import/join_recordings_to_master.R")
  
  recording_database <- join_recordings_to_master(
    recording_directory = "data/examples",
    master_path = "data/metadata/Bilingual_Stimulus_Global_Master_v1.xlsx"
  )
  
  names(recording_database)[
    names(recording_database) == "orthographic_form"
  ] <- "word"
  
  required_columns <- c(
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
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(recording_database)
  )
  
  if (length(missing_columns) > 0L) {
    stop(
      "Stage 3 cannot build the target-vowel plan. Missing columns: ",
      paste(missing_columns, collapse = ", ")
    )
  }
  
  target_vowel_plan <- recording_database[, required_columns]
  
  output_file <- "output/target_vowel_plan.csv"
  
  write.table(
    target_vowel_plan,
    file = output_file,
    sep = ",",
    row.names = FALSE,
    col.names = TRUE,
    quote = FALSE,
    na = ""
  )
  
  if (!file.exists(output_file)) {
    stop("Stage 3 did not create target_vowel_plan.csv.")
  }
  
  result <- list(
    status = "completed",
    recording_count = nrow(target_vowel_plan),
    output_file = normalizePath(
      output_file,
      winslash = "/",
      mustWork = TRUE
    )
  )
  
  message(
    "Savlaq Stage 3 passed: ",
    result$recording_count,
    " target-vowel plans written."
  )
  
  invisible(result)
}