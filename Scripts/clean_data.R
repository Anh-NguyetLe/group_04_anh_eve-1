# March 2020
# Eve Wicksteed and Anh Le

# script to clean data

"
This scripts replaces missing values (-200) with NA, creates a date/time column and saves the data to
a modified .csv file.

Usage: Scripts/clean_data.R --data_dir=<data_dir> --infilename=<infilename> --outfilename=<outfilename>
" -> doc

# load libraries
library(here)
library(tidyverse)
library(glue)
library(tidyr)
library(docopt)
library(lubridate) 
library(testthat)


opt <- docopt(doc)



main <- function(data_dir, infilename, outfilename){
  # read in data
  data <- readr::read_csv(here::here(data_dir, infilename))
  
  #convert Missing Values (tagged with -200 value) to NA ----
  data[data == -200] = NA 
  
  # Convert numeric columns to 'double' type ----
  data[3:15] <- sapply(data[3:15], as.double)
  data = data %>% 
    mutate(Date_Time = ymd_hms(paste(data$Date, data$Time)))
  
  
  # change col names: ----
  newnames <- c("Date", "Time", "CO", "Tin_oxide", "Hydro_carbons", "Benzene", 
                "Titania", "NOx", "Tungsten_oxide_NOx", "NO2", "Tungsten_oxide_NO2", 
                "Indium_oxide", "Temp", "RH", "AH", "Date_time")
  
  for (i in 1:ncol(data)){
    names(data)[i]=newnames[i]
  }
  
  #save as csv ----
  readr::write_csv(data, here::here(data_dir, outfilename))
  
  print(glue::glue("Reading data from ", data_dir, "/", infilename, 
                   " cleaning, and saving to ", outfilename))
  print("pass all tests")
}


main(opt$data_dir, opt$infilename, opt$outfilename)



