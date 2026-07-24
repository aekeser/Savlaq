# Savlaq
# Stage 4: Run the Praat batch measurement engine

run_savlaq_praat <- function(
    validation,
    praat_script = "praat/scripts/14_batch_export_measurement_objects.praat"
) {
  if (is.null(validation$project_folder) ||
      is.null(validation$praat_executable)) {
    stop("Stage 4 requires the validated Stage 1 result.")
  }
  
  project_folder <- normalizePath(
    validation$project_folder,
    winslash = "/",
    mustWork = TRUE
  )
  
  praat_executable <- normalizePath(
    validation$praat_executable,
    winslash = "/",
    mustWork = TRUE
  )
  
  praat_script_path <- normalizePath(
    file.path(project_folder, praat_script),
    winslash = "/",
    mustWork = TRUE
  )
  
  expected_output <- file.path(
    project_folder,
    "output",
    "measurement_objects.csv"
  )
  
  previous_working_directory <- getwd()
  
  on.exit(
    setwd(previous_working_directory),
    add = TRUE
  )
  
  setwd(project_folder)
  
  message("Savlaq Stage 4: launching Praat measurement engine...")
  
  praat_result <- system2(
    command = praat_executable,
    args = c(
      "--run",
      shQuote(praat_script_path)
    ),
    stdout = TRUE,
    stderr = TRUE,
    wait = TRUE
  )
  
  exit_status <- attr(praat_result, "status")
  
  if (is.null(exit_status)) {
    exit_status <- 0L
  }
  
  if (exit_status != 0L) {
    error_output <- paste(praat_result, collapse = "\n")
    
    stop(
      "Praat processing failed with exit status ",
      exit_status,
      if (nzchar(error_output)) {
        paste0(":\n", error_output)
      } else {
        "."
      }
    )
  }
  
  if (!file.exists(expected_output)) {
    stop(
      "Praat finished without reporting an error, but the expected ",
      "measurement file was not created: ",
      expected_output
    )
  }
  
  measurement_data <- read.csv(
    expected_output,
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
  
  if (nrow(measurement_data) == 0L) {
    stop("The Praat measurement file contains no recording rows.")
  }
  
  result <- list(
    status = "completed",
    exit_status = exit_status,
    measurement_file = normalizePath(
      expected_output,
      winslash = "/",
      mustWork = TRUE
    ),
    measurement_count = nrow(measurement_data)
  )
  
  message(
    "Savlaq Stage 4 passed: ",
    result$measurement_count,
    " Measurement Objects exported."
  )
  
  invisible(result)
}