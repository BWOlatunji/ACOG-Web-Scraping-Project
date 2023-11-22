

# ACOG Data
# search urls

acog_search_url_10 <- "https://www.acog.org/womens-health/find-an-ob-gyn/results?firstname=&lastname=&address=77469&searchradius=10"
acog_search_url_100 <- "https://www.acog.org/womens-health/find-an-ob-gyn/results?firstname=&lastname=&address=77469&searchradius=100"

# Add new column containing the complete url with each postal code
states_postalcodes_tbl <- states_postalcodes_tbl |> 
  select(-Admin3) |> 
    mutate(
        st_postalcode_url = str_glue("https://www.acog.org/womens-health/find-an-ob-gyn/results?firstname=&lastname=&address={Code}&searchradius=10")
    )



# https://www.acog.org/womens-health/find-an-ob-gyn/results?firstname=Moona&lastname=&address=&searchradius=10
# https://www.acog.org/womens-health/find-an-ob-gyn/physician?id=73cd3ca2-70cf-49c8-8dc0-43456c1ef562

acog_html_10 <- read_html(acog_url_10)
acog_html_100 <- read_html(acog_url_100)



# GET THE FIRSTNAMES, LASTNAMES AND TITLE OF EACH OB-GYN 
# firstname, lastname
acog_names <- acog_html_10 |> 
  html_element("#listingTable") |> 
  html_elements("li") |>
  html_element("a") |>
  html_text2() |> enframe(name = "position", value = "profile_name")


# CREATE FUCNTION TO GET ALL THE FIRSTNAMES, LASTNAMES AND TITLE OF EACH OB-GYN




# all addresses
acog_addresses <- acog_html_10 |> 
  html_element("#listingTable") |> 
  html_elements("li") |> 
  html_element("address") |> 
  html_text2() |> enframe(name = "position", value = "address") |> 
  mutate(address = address |> 
           str_replace_all(pattern = "Get Directions",replacement = "")) |> 
    mutate(address = address |> str_remove_all(pattern = "[\\r\\n+]"))

# CREATE FUCNTION TO GET ALL THE ADDRESSES
get_addresses <- function(st_pc_url) {
  # all addresses
  acog_addresses <- st_pc_url |>
    read_html() |>
    html_element("#listingTable") |>
    html_elements("li") |>
    html_element("address") |>
    html_text2() |> enframe(name = "id", value = "address") |>
    select(-id) |> 
    mutate(address = address |>
             str_replace_all(pattern = "Get Directions", replacement = "")) |> 
    mutate(address = address |> str_remove_all(pattern = "[\\r\\n+]")) |> 
    separate(address, c("address", "Phone Number"),sep = "Phone: ")
  
  return(acog_addresses)
}

 # |> enframe(name = "position", value = "address") |>
 #    mutate(address = address |>
 #             str_replace_all(pattern = "Get Directions", replacement = "")) |> 
 #    mutate(address = address |> str_remove_all(pattern = "[\\r\\n+]"))
get_addresses(acog_search_url_10) |> view()

# PROCESSED IN PARALLEL with furrr (5 minutes)
plan("multicore")
test_tbl_1 <- states_postalcodes_tbl[1:100,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_2 <- states_postalcodes_tbl[101:200,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_3 <- states_postalcodes_tbl[201:300,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_4 <- states_postalcodes_tbl[301:400,] |> #View()
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_5 <- states_postalcodes_tbl[401:500,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_6 <- states_postalcodes_tbl[501:600,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_7 <- states_postalcodes_tbl[601:700,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_8 <- states_postalcodes_tbl[701:800,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_9 <- states_postalcodes_tbl[801:900,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_10 <- states_postalcodes_tbl[901:1000,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_11 <- states_postalcodes_tbl[1001:1100,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_12 <- states_postalcodes_tbl[1101:1200,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_13 <- states_postalcodes_tbl[1201:1300,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_14 <- states_postalcodes_tbl[1301:1400,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_15 <- states_postalcodes_tbl[1401:1500,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_16 <- states_postalcodes_tbl[1501:1600,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_17 <- states_postalcodes_tbl[1601:1700,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_18 <- states_postalcodes_tbl[1701:1800,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_19 <- states_postalcodes_tbl[1801:1900,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_4 <- states_postalcodes_tbl[301:400,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_5 <- states_postalcodes_tbl[401:500,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_6 <- states_postalcodes_tbl[501:600,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_7 <- states_postalcodes_tbl[601:700,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)

test_tbl_8 <- states_postalcodes_tbl[701:800,] |>
  mutate(full_address = future_map(st_postalcode_url, get_addresses)) |>
  unnest(full_address)



# GET THE INDIVIDUAL PROFILES OF EACH OB-GYN
# getting the profile url
html |> 
  html_element("#listingTable") |> 
  html_elements("li") |>
  html_element("a") |> 
  html_attr("href") |> enframe(name = "position", value = "profile_url")



