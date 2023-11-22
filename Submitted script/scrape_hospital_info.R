
# STEP 1 -----------------------
# Source all global information and functions

source("working.R")

# STEP 2 -------------------------
states_search_urls <- collect_state_search_urls()

# STEP 3 ------------------------------
# Looking at just one state, for example - Alabama
hospital_urls <- collect_hospital_urls(states_search_urls[[1]])
# Initialize an empty data frame to store final hospital results

# STEP 4 -------------------------
hospital_info <- data.frame()

# STEP 5 ------------------------------
# This where we collect the details for each hospital
for (hospital_url in hospital_urls) {
  # scrape all information for each hospital in the state
  hospital_info <- collect_hospital_info(hospital_url)
  # create a folder for the state
  ifelse(!dir.exists(hospital_info$State), dir.create(hospital_info$State), "Folder exists already")
  write.csv(hospital_info, file = paste(hospital_info$State, "/", hospital_info$State, "-" ,hospital_info$`AHA ID`, ".csv", sep = ""))
  remDr$goBack()
  Sys.sleep(2)
}
