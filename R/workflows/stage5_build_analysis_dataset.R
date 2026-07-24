# Savlaq
# Stage 5: Build the analysis-ready dataset

build_analysis_dataset_stage <- function(
    validation,
    stage2_result,
    praat_result
) {
  if (!identical(validation$status, "validated")) {
    stop("Stage 5 requires successful Stage 1 validation.")
  }
  
  if (!identical(stage2_result$status, "completed")) {
    stop("Stage 5 requires successful Stage 2 completion.")
  }
  
  if (!identical(praat_result$status, "completed")) {
    stop("Stage 5 requires successful Stage 4 completion.")
  }
  
  recording_file <- stage2_result$output_file
  measurement_file <- praat_result$measurement_file
  output_file <- file.path(
    validation$project_folder,
    "output",
    "analysis_dataset.csv"
  )
  
  recording_database <- read.csv(
    recording_file,
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
  
  measurement_objects <- read.csv(
    measurement_file,
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
  
  if (anyDuplicated(recording_database$recording_file)) {
    stop(
      "Stage 5 found duplicate recording_file values in ",
      "recording_database.csv."
    )
  }
  
  if (anyDuplicated(measurement_objects$recording_file)) {
    stop(
      "Stage 5 found duplicate recording_file values in ",
      "measurement_objects.csv."
    )
  }
  
  unmatched_files <- setdiff(
    measurement_objects$recording_file,
    recording_database$recording_file
  )
  
  if (length(unmatched_files) > 0L) {
    stop(
      "Some Measurement Objects could not be matched to the ",
      "recording database: ",
      paste(unmatched_files, collapse = ", ")
    )
  }
  
  analysis_dataset <- merge(
    measurement_objects,
    recording_database,
    by = "recording_file",
    all.x = TRUE,
    sort = FALSE,
    suffixes = c("_measurement", "_metadata")
  )
  
  preferred_measurement_columns <- c(
    "speaker_id",
    "source",
    "stimulus_id",
    "word"
  )
  
  for (column_name in preferred_measurement_columns) {
    measurement_name <- paste0(column_name, "_measurement")
    metadata_name <- paste0(column_name, "_metadata")
    
    if (measurement_name %in% names(analysis_dataset)) {
      analysis_dataset[[column_name]] <-
        analysis_dataset[[measurement_name]]
    } else if (metadata_name %in% names(analysis_dataset)) {
      analysis_dataset[[column_name]] <-
        analysis_dataset[[metadata_name]]
    }
  }
  
  duplicate_columns <- unlist(
    lapply(
      preferred_measurement_columns,
      function(column_name) {
        c(
          paste0(column_name, "_measurement"),
          paste0(column_name, "_metadata")
        )
      }
    ),
    use.names = FALSE
  )
  
  analysis_dataset <- analysis_dataset[
    , !names(analysis_dataset) %in% duplicate_columns,
    drop = FALSE
  ]
  
  original_order <- match(
    measurement_objects$recording_file,
    analysis_dataset$recording_file
  )
  
  analysis_dataset <- analysis_dataset[
    original_order,
    ,
    drop = FALSE
  ]
  
  write.table(
    analysis_dataset,
    file = output_file,
    sep = ",",
    row.names = FALSE,
    col.names = TRUE,
    quote = FALSE,
    na = ""
  )
  
  result <- list(
    status = "completed",
    recording_count = nrow(analysis_dataset),
    variable_count = ncol(analysis_dataset),
    output_file = normalizePath(
      output_file,
      winslash = "/",
      mustWork = TRUE
    )
  )
  
  message(
    "Savlaq Stage 5 passed: ",
    result$recording_count,
    " recordings and ",
    result$variable_count,
    " variables written."
  )
  
  invisible(result)
}