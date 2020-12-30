library(rdhs)
library(tidyverse)

# Setup
email <- "horacio.chacon.t@upch.pe"
project <- "Global trends, prevalence and determinants of non-institutional deliveries:Evidence from DHS surveys"
source("src/functions.R")
country_list <- read_csv("data/country_list.csv")

## Set up your credentials
set_rdhs_config(
  email = email,
  project = project,
  cache_path = "data/",
  verbose_download = TRUE
)

# Get countries last survey + SurveyId
surveys <- get_last_survey()

# Get datasets
datasets <- dhs_datasets(
  surveyIds = surveys$SurveyId,
  fileFormat = "Flat",
  fileType = "BR",
  surveyYearStart = 2000
) %>% 
  filter(!(CountryName %in% c("Ukraine","Nicaragua","Vietnam")))

# Download queried datasets
dhs_birth_datasets <- get_datasets(datasets$FileName)

# Process dataset path + Country names
birth_datasets <- tibble(SurveyId = names(unlist(dhs_birth_datasets)),
                         path = unlist(dhs_birth_datasets)) %>%
  mutate(DHS_CountryCode = str_sub(SurveyId,1,2)) %>% 
  left_join(surveys[,c(1,3,4)], by = "DHS_CountryCode")

rm(email, project, birth_datasets)















