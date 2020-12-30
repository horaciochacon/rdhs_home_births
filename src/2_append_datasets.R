library(tidyverse)
library(srvyr)
library(sjlabelled)

# Obtain birth recode datasets from get_countries_datasets.R
source("src/get_countries_datasets.R")

# Specify variables to include in the analysis
vars <- c("v001", "v022", "v024", "v005", "v025", "v190", "m15" , "bidx",
          "v021","v106")

# Get variables from prior variable specification vector
variables <- search_variables(datasets$FileName, variables = vars)  %>% 
  bind_dhs_var(var = "v022", desc = "Sample strata for sampling errors",
               data = "ALBR71FL", id = "AL2017DHS") %>% 
  bind_dhs_var(var = "v106", desc = "Highest educational level",
               data = "YEBR61FL", id = "YE2013DHS") %>% 
  bind_dhs_var(var = "v022", desc = "Sample strata for sampling errors",
               data = "MBBR53FL", id = "MB2005DHS")

  
variables_spread <- variables %>% 
  select(dataset_filename,variable) %>% 
  spread(variable, variable)

# We generate the extract list with all datasets
extract <- extract_dhs(questions = variables, add_geo = FALSE)

# We append all procesed datasets
final <- rbind_labelled(extract)

# We mutate the outcome variable and filter the dataset
final <- final %>% 
  as_tibble() %>% 
  mutate(parto_institucional = case_when(str_sub(m15,1,1) == "1" ~ 0,
                                         str_sub(m15,1,1) == "2" ~ 1,
                                         str_sub(m15,1,1) == "3" ~ 1,
                                         str_sub(m15,1,1) == "4" ~ 1,
                                         str_sub(m15,1,1) == "9" ~ 0,
                                         is.na(m15) ~ NA_real_),
         parto_domiciliario = case_when(str_sub(m15,1,1) == "1" ~ 1,
                                         str_sub(m15,1,1) == "2" ~ 0,
                                         str_sub(m15,1,1) == "3" ~ 0,
                                         str_sub(m15,1,1) == "4" ~ 0,
                                         str_sub(m15,1,1) == "9" ~ 0,
                                         is.na(m15) ~ NA_real_),
         DHS_CountryCode = str_sub(SurveyId,1,2),
         v005 = v005/1000000) %>%
  filter(!is.na(parto_institucional)) %>% 
  left_join(surveys[,c(1:4)],
            by = "DHS_CountryCode") %>% 
  left_join(country_list[,c(2:3)], by = "CountryName")

write_rds(final,"data/final.rds")










