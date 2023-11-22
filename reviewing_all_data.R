
library(tidyverse) # Main Package - Loads dplyr, purrr
library(rvest)     # HTML Web Scraping
library(furrr)     # Parallel Processing using purrr (iteration)
library(fs)        # Working with File System
library(xopen)     # Quickly opening URLs


states_postalcodes_tbl <- read_rds("data/states_postalcodes_tbl.rds")

# complete
profile_201_400_completed <- read_csv("data/profile_201_400_completed.csv")

# not comleted
profile_401_900 <- read_rds("data/profile_401_900.rds")
profile_901_1400 <- read_rds("data/profile_901_1400.rds")
profile_1401_2400 <- read_rds("data/profile_1401_2400.rds")

profile_2401_3400 <- read_rds("data/profile_2401_3400.rds")

profile_3401_4000 <- read_rds("data/profile_3401_4000.rds")
profile_4001_5000 <- read_rds("data/profile_4001_5000.rds")

profile_401_5000 <- profile_401_900 |> 
  bind_rows(profile_901_1400) |> 
  bind_rows(profile_1401_2400) |> 
  bind_rows(profile_2401_3400) |> 
  bind_rows(profile_3401_4000) |> 
  bind_rows(profile_4001_5000)

profile_401_5000_insurance_url <- profile_401_5000 |> 
  mutate(
        individual_url = str_glue("https://www.acog.org{profile_url}")
    ) 

write_rds(profile_401_5000, "data/profile_401_5000.rds")
write_rds(profile_401_5000_insurance_url, "data/profile_401_5000_insurance_url.rds")

# insurance info
profile_401_5000_insurance_details_300 <- profile_401_5000_insurance_url[201:300,] |>
  mutate(obgyn_insurance = future_map(individual_url, get_insurance_info)) |>
  unnest(obgyn_insurance) 

profile_401_5000_insurance_details_1_300 <- profile_401_5000_insurance_details_100 |> 
  bind_rows(profile_401_5000_insurance_details_200) |> 
  bind_rows(profile_401_5000_insurance_details_300)

write_rds(profile_401_5000_insurance_details_1_300, "data/complete_with_NAs/profile_401_5000_insurance_details_1_300.rds")


# next batch

profile_401_5000_insurance_details_400 <- profile_401_5000_insurance_url[301:400,] |>
  mutate(obgyn_insurance = future_map(individual_url, get_insurance_info)) |>
  unnest(obgyn_insurance) 


profile_401_5000_insurance_details_500 <- profile_401_5000_insurance_url[401:500,] |>
  mutate(obgyn_insurance = future_map(individual_url, get_insurance_info)) |>
  unnest(obgyn_insurance) 


profile_401_5000_insurance_details_600 <- profile_401_5000_insurance_url[501:600,] |>
  mutate(obgyn_insurance = future_map(individual_url, get_insurance_info)) |>
  unnest(obgyn_insurance) 




