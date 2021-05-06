#' All you need to do to run the app is to open this script in RStudio,
#' select/highlight everything, and press on the run button. This will then
#' open a new tab in your standard browser. 
#' 
#' Please be aware that the start-up can take a bit, especially when it is the
#' first time. 
#' 
#' To completely stop the app, just close the tab in your browser, go to your
#' Console window, and press on the stop button. 
#' 
#' If something does not work, please inform us. We would also appreciate if you
#' could send us the log.txt file. This will allow us to better understand what
#' caused the problem.
#' 
################################################################################
#---- Setting up ----

# The line below is commented out. Your instructor might ask you
# to run this if something goes wrong during the start-up
# .rs.restartR() # Restarts r when in RStudio.
rm(list = ls()) # Deletes the current environment (nothing should be there)
cat("\014")  # Clears console
# Loading/Installing all required packages
if(!require(vars)) install.packages("vars"); require(vars);
if(!require(shiny)) install.packages("shiny"); require(shiny);
if(!require(sortable)) install.packages("sortable"); require(sortable);
if(!require(tidyverse)) install.packages("tidyverse"); require(tidyverse);
if(!require(igraph)) install.packages("igraph"); require(igraph);
if(!require(bootUR)) install.packages("bootUR"); require(bootUR);
# This is the function that starts the app
start_document <- function(path, app_name, ...) {
  rmarkdown::run(path, 
                 shiny_args = list(launch.browser = function(x) browseURL(paste0(x, "/", app_name))))
}
# Setting some options
shiny::shinyOptions(shiny.observer.error = function(x) cat("Caught a warning. Can be ignored!"),
                    shiny.error = function(x) cat("Caught an Error: See log file."))

################################################################################
#---- Starting the App ----

log_file <- file("./log.txt", open = "wt")
sink(log_file, type = "message")
start_document("./App/SnT_VARs.Rmd", "SnT_VARs.Rmd")
sink()
