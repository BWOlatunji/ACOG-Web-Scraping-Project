
library(RSelenium)
library(wdman)
library(netstat)

selenium()

selenium_object <- selenium(retcommand = T, check = F)

binman::list_versions("chromedriver")

remote_driver <- rsDriver(browser = "chrome",
                          chromever = "114.0.5735.90",
                          verbose = F,
                          port = free_port())

# close
remote_driver$server$stop()

remote_driver <- rsDriver(browser = "firefox",
                          chromever = NULL,
                          verbose = F,
                          port = free_port())

remDr <- remote_driver$client
remDr$open()
remDr$navigate("https://www.geonames.org/postal-codes/US/AK/alaska.html")

# close
remote_driver$server$stop()
