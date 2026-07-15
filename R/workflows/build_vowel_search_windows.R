# Savlaq
# Build approximate target-vowel search windows inside citation intervals

recording_database <- read.csv(
  "output/recording_database.csv",
  stringsAsFactors = FALSE
)

annotation_database <- read.csv(
  "output/annotation_database.csv",
  stringsAsFactors = FALSE
)

citation_intervals <- annotation_database[
  annotation_database$task_region == "citation",
  c("file", "start", "end")
]

names(citation_intervals) <- c(
  "recording_file",
  "citation_start",
  "citation_end"
)

vowel_plan <- merge(
  recording_database,
  citation_intervals,
  by = "recording_file",
  all.x = TRUE
)

vowel_plan$citation_duration <- vowel_plan$citation_end - vowel_plan$citation_start

vowel_plan$target_syllable_proportion <- vowel_plan$stressed_syllable_number / vowel_plan$syllable_count

vowel_plan$search_center <- vowel_plan$citation_start +
  vowel_plan$citation_duration * vowel_plan$target_syllable_proportion

vowel_plan$search_window_start <- vowel_plan$search_center - 0.15
vowel_plan$search_window_end <- vowel_plan$search_center + 0.15
vowel_plan$search_window_start <- pmax(
  vowel_plan$search_window_start,
  vowel_plan$citation_start
)

vowel_plan$search_window_end <- pmin(
  vowel_plan$search_window_end,
  vowel_plan$citation_end
)

vowel_search_windows <- vowel_plan[, c(
  "recording_file",
  "speaker_id",
  "source",
  "language_recording",
  "stimulus_id",
  "word",
  "syllable_count",
  "stress_pattern",
  "stressed_syllable_number",
  "vowel_pattern",
  "target_vowel_for_F1F2",
  "citation_start",
  "citation_end",
  "search_window_start",
  "search_window_end"
)]

write.csv(
  vowel_search_windows,
  file = "output/vowel_search_windows.csv",
  row.names = FALSE
)

message("Savlaq vowel search windows written to output/vowel_search_windows.csv")