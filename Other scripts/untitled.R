
df <- tibble(
  character = c("Toothless", "Dory"),
  metadata = list(
    list(
      species = "dragon",
      color = "black",
      films = c(
        "How to Train Your Dragon",
        "How to Train Your Dragon 2",
        "How to Train Your Dragon: The Hidden World"
      )
    ),
    list(
      species = "blue tang",
      color = "blue",
      films = c("Finding Nemo", "Finding Dory")
    )
  )
)
df

# Extract only specified components
df %>% hoist(metadata,
  "species",
  first_film = list("films", 1L),
  third_film = list("films", 3L)
) |> view()



# unnest() is designed to work with lists of data frames
df <- tibble(
  x = 1:3,
  y = list(
    NULL,
    tibble(a = 1, b = 2),
    tibble(a = 1:3, b = 3:1, c = 4)
  )
)
# unnest() recycles input rows for each row of the list-column
# and adds a column for each column
df %>% unnest(y)

# input rows with 0 rows in the list-column will usually disappear,
# but you can keep them (generating NAs) with keep_empty = TRUE:
df %>% unnest(y, keep_empty = TRUE)

# Multiple columns ----------------------------------------------------------
# You can unnest multiple columns simultaneously
df <- tibble(
  x = 1:2,
  y = list(
    tibble(a = 1, b = 2),
    tibble(a = 3:4, b = 5:6)
  ),
  z = list(
    tibble(c = 1, d = 2),
    tibble(c = 3:4, d = 5:6)
  )
)
df %>% unnest(c(y, z))

# Compare with unnesting one column at a time, which generates
# the Cartesian product
df %>%
  unnest(y) %>%
  unnest(z)
