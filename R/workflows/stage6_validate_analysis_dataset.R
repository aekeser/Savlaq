# Savlaq
# Stage 6: Validate the analysis-ready dataset and write QC reports

validate_analysis_dataset_stage <- function(
    validation,
    stage2_result,
    praat_result,
    stage5_result
) {
  required_statuses <- c(
    validation$status,
    stage2_result$status,
    praat_result$status,
    stage5_result$status
  )
  
  expected_statuses <- c(
    "validated",
    "completed",
    "completed",
    "completed"
  )
  
  if (!identical(required_statuses, expected_statuses)) {
    stop("Stage 6 requires successful completion of Stages 1–5.")
  }
  
  analysis_dataset <- read.csv(
    stage5_result$output_file,
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
  
  required_columns <- c(
    "recording_file",
    "overall_status",
    "overall_qc_flag",
    "mean_f0",
    "mean_intensity",
    "f1",
    "f2"
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(analysis_dataset)
  )
  
  if (length(missing_columns) > 0L) {
    stop(
      "Stage 6 found missing required columns: ",
      paste(missing_columns, collapse = ", ")
    )
  }
  
  expected_count <- validation$recording_count
  
  stage_counts <- c(
    stage1 = validation$recording_count,
    stage2 = stage2_result$recording_count,
    stage4 = praat_result$measurement_count,
    stage5 = stage5_result$recording_count
  )
  
  if (any(stage_counts != expected_count)) {
    stop(
      "Recording-count mismatch across stages: ",
      paste(
        names(stage_counts),
        stage_counts,
        sep = "=",
        collapse = ", "
      )
    )
  }
  
  if (anyDuplicated(analysis_dataset$recording_file)) {
    stop("Stage 6 found duplicate recording_file values.")
  }
  
  accepted_count <- sum(
    analysis_dataset$overall_status == "accepted",
    na.rm = TRUE
  )
  
  review_count <- sum(
    analysis_dataset$overall_status == "needs_review",
    na.rm = TRUE
  )
  
  missing_status_count <- sum(
    is.na(analysis_dataset$overall_status) |
      analysis_dataset$overall_status == ""
  )
  
  acoustic_columns <- c(
    "mean_f0",
    "mean_intensity",
    "f1",
    "f2"
  )
  
  missing_acoustic_count <- rowSums(
    is.na(analysis_dataset[, acoustic_columns, drop = FALSE])
  )
  
  review_report <- analysis_dataset[
    analysis_dataset$overall_status == "needs_review" |
      missing_acoustic_count > 0L,
    c(
      "recording_file",
      "word",
      "overall_status",
      "overall_qc_flag",
      acoustic_columns
    ),
    drop = FALSE
  ]
  
  summary_report <- data.frame(
    metric = c(
      "total_recordings",
      "accepted_recordings",
      "needs_review_recordings",
      "missing_status_recordings",
      "recordings_with_missing_acoustic_values"
    ),
    value = c(
      nrow(analysis_dataset),
      accepted_count,
      review_count,
      missing_status_count,
      sum(missing_acoustic_count > 0L)
    ),
    stringsAsFactors = FALSE
  )
  
  report_directory <- file.path(
    validation$project_folder,
    "validation",
    "reports"
  )
  
  dir.create(
    report_directory,
    recursive = TRUE,
    showWarnings = FALSE
  )
  
  summary_file <- file.path(
    report_directory,
    "validation_summary.csv"
  )
  
  review_file <- file.path(
    report_directory,
    "recordings_needing_review.csv"
  )
  
  write.csv(
    summary_report,
    summary_file,
    row.names = FALSE
  )
  
  write.csv(
    review_report,
    review_file,
    row.names = FALSE
  )
  
  result <- list(
    status = "completed",
    total_recordings = nrow(analysis_dataset),
    accepted_count = accepted_count,
    review_count = review_count,
    missing_acoustic_count = sum(missing_acoustic_count > 0L),
    summary_file = normalizePath(
      summary_file,
      winslash = "/",
      mustWork = TRUE
    ),
    review_file = normalizePath(
      review_file,
      winslash = "/",
      mustWork = TRUE
    )
  )
  
  message(
    "Savlaq Stage 6 passed: ",
    result$accepted_count,
    " accepted, ",
    result$review_count,
    " need review."
  )
  
  invisible(result)
}