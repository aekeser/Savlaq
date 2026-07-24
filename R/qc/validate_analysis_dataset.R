# Savlaq
# Validate the analysis-ready dataset

analysis_dataset <- read.csv(
  "output/analysis_dataset.csv",
  stringsAsFactors = FALSE,
  check.names = FALSE
)

cat("\n==============================\n")
cat("Savlaq Validation Report\n")
cat("==============================\n\n")

cat("Total recordings:",
    nrow(analysis_dataset), "\n\n")

cat("Overall status\n")
print(table(analysis_dataset$overall_status))

cat("\nQC flags\n")
print(table(analysis_dataset$overall_qc_flag))

cat("\nAccepted recordings\n")
print(
  analysis_dataset[
    analysis_dataset$overall_status == "accepted",
    c("recording_file",
      "word",
      "overall_status")
  ]
)

cat("\nNeeds review\n")
print(
  analysis_dataset[
    analysis_dataset$overall_status == "needs_review",
    c("recording_file",
      "word",
      "overall_qc_flag")
  ]
)