# Savlaq
# Main workflow orchestrator

message("Starting Savlaq...")

source("R/workflows/stage1_validate_project.R")
source("R/workflows/stage2_build_recording_database.R")
source("R/workflows/stage3_build_target_vowel_plan.R")
source("R/workflows/stage4_run_praat.R")
source("R/workflows/stage5_build_analysis_dataset.R")
source("R/workflows/stage6_validate_analysis_dataset.R")

validation <- validate_savlaq_project()

if (!identical(validation$status, "validated")) {
  stop("Savlaq Stage 1 failed.")
}

message(
  "Stage 1 complete: project validated with ",
  validation$recording_count,
  " WAV recordings."
)

stage2_result <- build_recording_database_stage(validation)

if (!identical(stage2_result$status, "completed")) {
  stop("Savlaq Stage 2 failed.")
}

message(
  "Stage 2 complete: ",
  stage2_result$recording_count,
  " recordings written."
)

stage3_result <- build_target_vowel_plan_stage(validation)

if (!identical(stage3_result$status, "completed")) {
  stop("Savlaq Stage 3 failed.")
}

message(
  "Stage 3 complete: ",
  stage3_result$recording_count,
  " target-vowel plans written."
)

praat_result <- run_savlaq_praat(validation)

if (!identical(praat_result$status, "completed")) {
  stop("Savlaq Stage 4 failed.")
}

message(
  "Stage 4 complete: ",
  praat_result$measurement_count,
  " Measurement Objects exported."
)

stage5_result <- build_analysis_dataset_stage(
  validation = validation,
  stage2_result = stage2_result,
  praat_result = praat_result
)

if (!identical(stage5_result$status, "completed")) {
  stop("Savlaq Stage 5 failed.")
}

message(
  "Stage 5 complete: ",
  stage5_result$recording_count,
  " recordings and ",
  stage5_result$variable_count,
  " variables written."
)

stage6_result <- validate_analysis_dataset_stage(
  validation = validation,
  stage2_result = stage2_result,
  praat_result = praat_result,
  stage5_result = stage5_result
)

if (!identical(stage6_result$status, "completed")) {
  stop("Savlaq Stage 6 failed.")
}

message(
  "Stage 6 complete: ",
  stage6_result$accepted_count,
  " accepted, ",
  stage6_result$review_count,
  " need review."
)

message("Savlaq workflow completed successfully.")