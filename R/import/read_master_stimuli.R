# Savlaq
# Read master stimulus spreadsheet

library(readxl)

read_master_stimuli <- function(path = "data/metadata/Bilingual_Stimulus_Global_Master_v1.xlsx") {
  stimuli <- read_excel(path)
  
  required_columns <- c(
    "stimulus_id",
    "language"
  )
  
  missing_columns <- setdiff(required_columns, names(stimuli))
  
  if (length(missing_columns) > 0) {
    stop(
      "Master spreadsheet is missing required columns: ",
      paste(missing_columns, collapse = ", ")
    )
  }
  
  stimuli
}

# Test
read_master_stimuli()