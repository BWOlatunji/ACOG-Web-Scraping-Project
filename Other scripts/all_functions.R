
# search urls

acog_search_url_10 <- "https://www.acog.org/womens-health/find-an-ob-gyn/results?firstname=&lastname=&address=77469&searchradius=10"
acog_search_url_100 <- "https://www.acog.org/womens-health/find-an-ob-gyn/results?firstname=&lastname=&address=77469&searchradius=100"

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

# PROCESSED IN PARALLEL with furrr (5 minutes)
plan("multicore")
address_tbl_1 <- states_postalcodes_tbl[1:100,] |>
  mutate(full_address = future_map(postalcodes_search_url, get_addresses)) |>
  unnest(full_address)
