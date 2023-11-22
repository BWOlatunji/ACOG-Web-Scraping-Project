
individual_url <- "https://www.acog.org/womens-health/find-an-ob-gyn/physician?id=73cd3ca2-70cf-49c8-8dc0-43456c1ef562"


# GET THE INDIVIDUAL PROFILES OF EACH OB-GYN
# getting the profile url
html |> 
  html_element("#listingTable") |> 
  html_elements("li") |>
  html_element("a") |> 
  html_attr("href") |> enframe(name = "position", value = "profile_url")








