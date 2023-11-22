# ACOG Data

# Test search urls

acog_search_url_10 <- "https://www.acog.org/womens-health/find-an-ob-gyn/results?firstname=&lastname=&address=77469&searchradius=10"
acog_search_url_100 <- "https://www.acog.org/womens-health/find-an-ob-gyn/results?firstname=&lastname=&address=77469&searchradius=100"

acog_html_10 <- read_html(acog_search_url_10)
acog_html_100 <- read_html(acog_search_url_100)


# GET THE EXTENDED URL FOR EACH OB-GYN LISTED BASED ON THE SEARCH USING THE POSTAL CODES
# THE EXTENDED URL CONTAINS THEIR ID
ob_gyn_individual_url <- acog_html_10 |> 
  html_element("#listingTable") |> 
  html_elements("li") |>
  html_element("a") |>
  html_attr("href") |> enframe(name = "position", value = "individual_ext_url")


# Create Function to get list of individual ob-gyn url for each postal code

get_individual_url <- function(search_url){
  ob_gyn_individual_urls <- search_url |>
    read_html() |>
    html_element("#listingTable") |>
    html_elements("li") |>
    html_element("a") |>
    html_attr("href") |> enframe(name = "obgyn_id", value = "individual_ext_url")
  return(ob_gyn_individual_urls)
}


# test on a single postal code
get_individual_url(acog_search_url_10)

# Result for all postal codes

# PROCESSED IN PARALLEL with furrr (5 minutes)
plan("multicore")
obgyn_tbl_5 <- obgyn_tbl[201:300,] |>
  mutate(obgyn_list = future_map(postalcodes_search_url, get_individual_url)) |>
  unnest(obgyn_list)

obgyn_tbl_4 <- obgyn_tbl[301:400,] |>
  mutate(obgyn_list = future_map(postalcodes_search_url, get_individual_url)) |>
  unnest(obgyn_list)


obgyn_all <- obgyn_tbl_1 |> bind_rows(obgyn_tbl_2, obgyn_tbl_3)
  
  
write_rds(obgyn_all, "data/obgyn_all.rds")
# Next, add the main url to the extended individual url to get a complete
# web address containing the information about each OB-GYN

obgyn_all_individual_tbl <- obgyn_all |> 
  mutate(
        individual_url = str_glue("https://www.acog.org{individual_ext_url}")
    ) |> 
  mutate(obgyn_web_id = individual_ext_url |> str_remove_all(pattern = "\\/womens-health\\/find-an-ob-gyn\\/physician\\?id\\="))

# GET THE ADDRESS, PHONE NUMBER, AND INSURANCE INFO OF EACH THE OB-GYN 
# FROM THEIR INDIVIDUAL WEB PAGE

# test
test_obgyn_ind <- "https://www.acog.org/womens-health/find-an-ob-gyn/physician?id=460e6cac-cc4e-4637-8301-09a22ef261bf"


test_obgyn_ind |> 
  read_html() |> 
  html_element("address") |>
  html_text2()

# CREATE FUCNTION TO GET ALL THE ADDRESS, PHONE NUMBER, AND INSURANCE INFO OF EACH THE OB-GYN

get_individual_url <- function(search_url){
  obgyn_address <- search_url |> 
  read_html() |> 
  html_element("address") |>
  html_text2() |> enframe(name = "add_id", value = "obgyn_address")
  return(obgyn_address)
}


# PROCESSED IN PARALLEL with furrr (5 minutes)
plan("multicore")
obgyn_address_all <- obgyn_all_individual_tbl |>
  mutate(add_list = future_map(individual_url, get_individual_url)) |>
  unnest(add_list)





# GET THE FIRSTNAMES, LASTNAMES, TITLE, ADDRESS, PHONE NUMBER OF EACH THE OB-GYN 
# FROM THEIR INDIVIDUAL WEB PAGE

# CREATE FUCNTION TO GET ALL THE FIRSTNAMES, LASTNAMES AND TITLE OF EACH OB-GYN







   
