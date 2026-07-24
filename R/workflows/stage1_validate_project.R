# Savlaq
# Stage 1: Validate project structure and required inputs

validate_savlaq_project <- function(
    config_path = "config/savlaq_config.tsv"
) {
  if (!file.exists(config_path)) {
    stop("Savlaq configuration file not found: ", config_path)
  }
  
  config <- read.delim(
    config_path,
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
  
  required_parameters <- c(
    "project_folder",
    "praat_executable"
  )
  
  missing_parameters <- setdiff(
    required_parameters,
    config$parameter
  )
  
  if (length(missing_parameters) > 0) {
    stop(
      "Missing configuration parameters: ",
      paste(missing_parameters, collapse = ", ")
    )
  }
  
  get_config_value <- function(parameter_name) {
    config$value[config$parameter == parameter_name][1]
  }
  
  project_folder <- get_config_value("project_folder")
  praat_executable <- get_config_value("praat_executable")
  
  required_paths <- c(
    project_folder = project_folder,
    praat_executable = praat_executable,
    master_spreadsheet = file.path(
      project_folder,
      "data",
      "metadata",
      "Bilingual_Stimulus_Global_Master_v1.xlsx"
    ),
    recordings_folder = file.path(
      project_folder,
      "data",
      "examples"
    ),
    output_folder = file.path(
      project_folder,
      "output"
    ),
    diagnostics_folder = file.path(
      project_folder,
      "measurements",
      "diagnostics"
    )
  )
  
  missing_paths <- names(required_paths)[
    !file.exists(required_paths)
  ]
  
  if (length(missing_paths) > 0) {
    stop(
      "Required Savlaq paths are missing: ",
      paste(missing_paths, collapse = ", ")
    )
  }
  
  wav_files <- list.files(
    required_paths[["recordings_folder"]],
    pattern = "\\.wav$",
    ignore.case = TRUE,
    full.names = TRUE
  )
  
  if (length(wav_files) == 0) {
    stop("No WAV recordings found in data/examples.")
  }
  
  result <- list(
    project_folder = project_folder,
    praat_executable = praat_executable,
    recording_count = length(wav_files),
    recording_files = basename(wav_files),
    status = "validated"
  )
  
  message(
    "Savlaq Stage 1 passed: ",
    length(wav_files),
    " WAV recordings found."
  )
  
  invisible(result)
}
