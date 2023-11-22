
# search urls
library(tidyverse) # Main Package - Loads dplyr, purrr
library(rvest)     # HTML Web Scraping
library(furrr)     # Parallel Processing using purrr (iteration)
library(fs)        # Working with File System
library(xopen)     # Quickly opening URLs

#ISSUES
# Deal with data from 2401 - 2500 in previous downloads in 2401 - 3400

# PROCESSED IN PARALLEL with furrr (5 minutes)
plan("multicore")


states_postalcodes_tbl <- readRDS("C:/R Projects/ACOG Web Scraping Project/data/states_postalcodes_tbl.rds")


profile_tbl_5001_5100 <- states_postalcodes_tbl[5001:5100,] |>
  mutate(obgyn_profile = future_map(postalcodes_search_url, get_all_profile_info)) |>
  unnest(obgyn_profile)

profile_tbl_5101_5200 <- states_postalcodes_tbl[5101:5200,] |>
  mutate(obgyn_profile = future_map(postalcodes_search_url, get_all_profile_info)) |>
  unnest(obgyn_profile)

profile_tbl_5201_5300 <- states_postalcodes_tbl[5201:5300,] |>
  mutate(obgyn_profile = future_map(postalcodes_search_url, get_all_profile_info)) |>
  unnest(obgyn_profile)

profile_tbl_5301_5400 <- states_postalcodes_tbl[5301:5400,] |>
  mutate(obgyn_profile = future_map(postalcodes_search_url, get_all_profile_info)) |>
  unnest(obgyn_profile)

profile_tbl_5401_5500 <- states_postalcodes_tbl[5401:5500,] |>
  mutate(obgyn_profile = future_map(postalcodes_search_url, get_all_profile_info)) |>
  unnest(obgyn_profile)

profile_tbl_5501_5600 <- states_postalcodes_tbl[5501:5600,] |>
  mutate(obgyn_profile = future_map(postalcodes_search_url, get_all_profile_info)) |>
  unnest(obgyn_profile)

profile_tbl_5601_5700 <- states_postalcodes_tbl[5601:5700,] |>
  mutate(obgyn_profile = future_map(postalcodes_search_url, get_all_profile_info)) |>
  unnest(obgyn_profile)

profile_tbl_5701_5800 <- states_postalcodes_tbl[5701:5800,] |>
  mutate(obgyn_profile = future_map(postalcodes_search_url, get_all_profile_info)) |>
  unnest(obgyn_profile)

profile_tbl_5801_5900 <- states_postalcodes_tbl[5801:5900,] |>
  mutate(obgyn_profile = future_map(postalcodes_search_url, get_all_profile_info)) |>
  unnest(obgyn_profile)

profile_tbl_5901_6000 <- states_postalcodes_tbl[5901:6000,] |>
  mutate(obgyn_profile = future_map(postalcodes_search_url, get_all_profile_info)) |>
  unnest(obgyn_profile)

profile_4001_5000 <- profile_tbl_4001_4100 |>
  bind_rows(profile_tbl_4101_4200) |>
  bind_rows(profile_tbl_4201_4300) |>
  bind_rows(profile_tbl_4301_4400) |>
  bind_rows(profile_tbl_4401_4500) |> 
  bind_rows(profile_tbl_4501_4600) |> 
  bind_rows(profile_tbl_4601_4700) |> 
  bind_rows(profile_tbl_4701_4800) |> 
  bind_rows(profile_tbl_4801_4900) |> 
  bind_rows(profile_tbl_4901_5000)

write_rds(profile_4001_5000, "data/profile_4001_5000.rds")



