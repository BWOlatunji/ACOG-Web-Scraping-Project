# libraries
library(tidyverse)
library(rvest)
library(RSelenium)
library(wdman)
library(netstat)

## START THE WEB SCRAPE PROCESS -----------------------------------
selenium_object <- selenium(retcommand = T,check = F)

# remote_driver <- rsDriver(browser = 'chrome',
#                           chromever = "116.0.5845.98",
#                           verbose = F,
#                           port = free_port())

remote_driver <- rsDriver(browser = 'firefox')

remDr <- remote_driver$client

## Source the 50 US State names to generate their search url -----------------

collect_state_search_urls <- function(){
  
  url <- "https://www.nationsonline.org/oneworld/US-states-by-area.htm"
  remDr$navigate(url)
  
  # get states table html element
  states_data_table <- remDr$findElement(using = 'id', 'statelist')
  
  # get the table url
  data_table_html <- states_data_table$getPageSource()
  
  # read the tables from the url
  page_tables <- read_html(data_table_html %>% unlist()) # returns list of 2 tables
  
  # extract data from the first table
  states_df <- html_table(page_tables) %>% .[[1]]
  
  ## Generate state links --------------------
  ### Combine the state names with the default aha website to get all states url 
  sapply(states_df$State, function(x) {
    url <- "https://guide.prod.iam.aha.org/guide/searchResults?query="
    paste0(url, x) }) -> state_urls
  
  return(state_urls)
}


## Scrape each state's hospitals urls  --------------------------
# Use state url to scrape links for each of the hospitals in the state


collect_hospital_urls <- function(state_url){
  
  remDr$navigate(state_url)
  
  preferred_class <- "disabled"
  all_profile_urls <- list()
  
  pagination_next <- tryCatch(
    remDr$findElement(using = "class name", "pagination-next"),
    error = function(e) NULL
  )
  
  if (is.null(pagination_next)) {
    # If either of the elements doesn't exist, scrape and return the table
    profile_tags <- remDr$findElements(using = "css", value = "a[_ngcontent-c10]")
    
    # Extract href attributes
    profile_href_attributes <- sapply(profile_tags, function(tag) {
      tag$getElementAttribute("href")[[1]]
    })
    
    # combine to all page profiles
    all_profile_urls <- append(all_profile_urls, profile_href_attributes)
    
    print("One-paged result job completed!")
  } else {
    while (TRUE) {
      # start to collect all hospital profile links on each page
      profile_tags <- remDr$findElements(using = "css", value = "a[_ngcontent-c10]")
      
      # Extract href attributes
      profile_href_attributes <- sapply(profile_tags, function(tag) {
        tag$getElementAttribute("href")[[1]]
      })
      
      # combine to all page profiles
      all_profile_urls <- append(all_profile_urls, profile_href_attributes)
      
      # Find the li HTML element by its CSS selector
      li_pagination_next <- remDr$findElement(using = "class name", "pagination-next")  # Replace with your CSS selector
      
      # Check if the preferred class name is present
      if (preferred_class %in% as.character(str_split(unlist(li_pagination_next$getElementAttribute("class")),"\\s+",simplify = T))) {
        # Do something when the class is found
        print("Preferred class found! Multi-paged result completed!")
        break
      } else {
        # Click on the link to potentially load new content
        next_button <- remDr$findElement(using = 'link text', 'Next')
        next_button$clickElement()
        print("Next Button clicked")
        # Wait for some time to allow the new content to load
        Sys.sleep(5)  # You can adjust the sleep time as needed
      }
    }
  }
  
  # Use the unlist() to convert the result to vector
  all_profile_urls <- all_profile_urls |> unlist()
  
  return(all_profile_urls)
}

# collect details about each hospital

collect_hospital_info <- function(hospital_url){
  
  # All information about each state's hospital
  remDr$navigate(hospital_url)
  
  # get values for the general info panel
  gi_panel_element <- remDr$findElement(using = 'css selector', value = 'general-info-panel[_ngcontent-c4]')
  
  # Extract the text content from the <span> element
  gi_panel_element_text <- gi_panel_element$getElementText() |> unlist()
  
  gi_panel_vec <- gi_panel_element_text |> str_split(pattern = "\\n",simplify = TRUE)
  
  # Get column indices that are even
  
  # Select columns with even indices
  gi_column_names <- gi_panel_vec[, seq(2, ncol(gi_panel_vec), by = 2)]
  # Select columns with odd indices
  gi_values_text <- gi_panel_vec[, seq(1, ncol(gi_panel_vec), by = 2)]
  
  
  # Create a data frame
  #data_frame <- data.frame(matrix(odd_columns, nrow = 1))
  gi_panel_df <- data.frame(matrix(gi_values_text[-1], nrow = 1))
  colnames(gi_panel_df) <-gi_column_names
  
  
  # get values for the address panel
  address_panel_element <- remDr$findElement(using = 'css selector', value = 'address-panel[_ngcontent-c4]')
  
  # Extract the text content from the <span> element
  address_panel_element_text <- address_panel_element$getElementText() |> unlist()
  
  address_panel_vec <- address_panel_element_text |> str_split(pattern = "\\n",simplify = TRUE)
  
  # Get column indices that are even
  
  # Select columns with even indices
  add_column_names <- address_panel_vec[, seq(2, ncol(address_panel_vec), by = 2)]
  
  add_values_text <- address_panel_vec[, seq(1, ncol(address_panel_vec), by = 2)]
  
  
  # Create a data frame
  #data_frame <- data.frame(matrix(odd_columns, nrow = 1))
  address_panel_df <- data.frame(matrix(add_values_text[-1], nrow = 1))
  colnames(address_panel_df) <-add_column_names
  
  # get values for the utilization panel
  util_panel_element <- remDr$findElement(using = 'css selector', value = 'utilization-panel[_ngcontent-c4]')
  
  # Extract the text content from the <span> element
  util_panel_element_text <- util_panel_element$getElementText() |> unlist()
  
  util_panel_vec <- util_panel_element_text |> str_split(pattern = "\\n",simplify = TRUE)
  
  
  # New Util
  # Get column indices that are even
  
  # Select columns with even indices
  util_column_names <- util_panel_vec[, seq(1, ncol(util_panel_vec), by = 2)]
  
  util_values_text <- util_panel_vec[, seq(2, ncol(util_panel_vec), by = 2)]
  
  
  
  # Create a data frame
  #data_frame <- data.frame(matrix(odd_columns, nrow = 1))
  util_panel_df <- data.frame(matrix(util_values_text, nrow = 1))
  colnames(util_panel_df) <-util_column_names
  util_panel_df <- util_panel_df[,-1]
  
  
  final_df <- bind_cols(gi_panel_df, address_panel_df, util_panel_df)
  
  return(final_df)
}




