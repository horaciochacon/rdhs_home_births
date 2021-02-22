library(srvyr)
library(sjlabelled)
library(tidyverse)

final <- read_rds("data/final.rds")

# Get survey desing object with srvyr
options(survey.lonely.psu="adjust")
design <- final %>% 
  as_survey_design(id = v001, strata = v022, weights = v005, nest = TRUE) 

# Calculate estimates of home delivery prevalence per country
estimates_countries <- design %>% 
  group_by(RegionWorldBank, SubregionName, CountryName, SurveyYear) %>% 
  summarise(prop_dom = survey_mean(parto_domiciliario,vartype = "ci"))

write_excel_csv(estimates_countries,"output/estimates_countries.csv")

# Calculate estimates for forest plot STATA input
estimates_forest_plot <- design %>% 
  group_by(RegionWorldBank, SubregionName, CountryName, SurveyYear) %>% 
  summarise(
    num_we = survey_total(parto_domiciliario),
    denom_we = survey_total(parto_institucional),
    num_unwe = unweighted(sum(parto_domiciliario, na.rm = TRUE)),
    denom_unwe = unweighted(sum(parto_institucional, na.rm = TRUE)),
    prop_dom = survey_mean(parto_domiciliario,vartype = c("ci","se"))
    ) %>% 
  mutate(
    denom_we = num_we + denom_we,
    denom_unwe = num_unwe + denom_unwe
    ) %>% 
  select(tgroup = RegionWorldBank, SubregionName, study = CountryName,
         author = CountryName, year = SurveyYear, num_we, denom_we, num_unwe,
         denom_unwe, prop_dom, prop_dom_se, prop_dom_low, prop_dom_upp)

write_excel_csv(est,"output/estimates_forest_plot.csv")

# Calculate estimates of home delivery prevalence per country per Wealth Quintile
estimates_wealth_quintile <- design %>% 
  group_by(RegionWorldBank, SubregionName, CountryName, SurveyYear, v190)%>% 
  summarise(prop_dom = survey_mean(parto_domiciliario,vartype = "ci")) %>% 
  mutate(v190 = as_character(v190)) %>% 
  rename(Wealth_Quintile = v190) 

write_excel_csv(
  estimates_wealth_quintile,"output/estimates_wealth_quintile.csv"
)

# Calculate estimates of home delivery prevalence per country per Urban/Rural
estimates_urban_rural <- design %>% 
  group_by(RegionWorldBank, SubregionName, CountryName, SurveyYear, v025)%>% 
  summarise(prop_dom = survey_mean(parto_domiciliario,vartype = "ci")) %>% 
  mutate(v025 = as_character(v025)) %>% 
  rename(Residence = v025) 

write_excel_csv(
  estimates_urban_rural,"output/estimates_urban_rural.csv"
)

# Calculate estimates of home delivery prevalence per country per Education Lvl
estimates_education_lvl <- design %>% 
  group_by(RegionWorldBank, SubregionName, CountryName, SurveyYear, v106)%>% 
  summarise(prop_dom = survey_mean(parto_domiciliario,vartype = "ci")) %>% 
  mutate(v106 = as_character(v106)) %>% 
  rename(Education = v106) 

write_excel_csv(
  estimates_education_lvl,"output/estimates_education_lvl.csv"
)

