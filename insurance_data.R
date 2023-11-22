
# getting the insurance info from individual ob-gyn web page

alaska_profile_tbl_201_3400 <- read_csv("data/profile_201_400.csv") 

test_tbl <- read_rds("data/profile_401_900.rds") |>
  bind_rows(read_rds("data/profile_901_1400.rds") )|> 
  bind_rows(read_rds("data/profile_1401_2400.rds")) |> 
  bind_rows(read_rds("data/profile_2401_3400.rds")) |> 
  mutate(postalcodes_search_url = as.character(postalcodes_search_url)) |> 
  mutate(PostalCode = as.numeric(PostalCode))




insurance_tbl_201_3400 <- test_tbl |> 
  mutate(
        individual_url = str_glue("https://www.acog.org{profile_url}")
    ) 

# PROCESSED IN PARALLEL with furrr (5 minutes)
plan("multicore")
obgyn_insurance_tbl_50 <- insurance_tbl_201_3400[1:20,] |>
  mutate(obgyn_insurance = future_map(individual_url, get_insurance_info)) |>
  unnest(obgyn_insurance) 

obgyn_insurance_tbl_50[1:20, c(1,2,3,4,9,10,11,12,16:18)] |> View()


obgyn_insurance_tbl_100 <- insurance_tbl[51:100,] |>
  mutate(obgyn_insurance = future_map(individual_url, get_insurance_info)) |>
  unnest(obgyn_insurance) 

obgyn_insurance_tbl_110 <- insurance_tbl[101:110,] |>
  mutate(obgyn_insurance = future_map(individual_url, get_insurance_info)) |>
  unnest(obgyn_insurance) 


