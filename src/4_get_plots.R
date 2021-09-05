library(tidyverse)
library(gridExtra)
source("src/0_functions.R")


# Read Data ---------------------------------------------------------------

area <- read_csv("output/estimates_urban_rural.csv")
education <- read_csv("output/estimates_education_lvl.csv")
wealth <- read_csv("output/estimates_wealth_quintile.csv")
country_estimates <- read_csv("output/estimates_countries.csv")

# Data Cleaning -----------------------------------------------------------

country_estimates <- country_estimates %>%
  arrange(prop_dom) %>%
  mutate(CountryName = paste0(CountryName, " (", SurveyYear, ")")) %>%
  select(CountryName, prop_avg = prop_dom)


area <- area %>%
  mutate(CountryName = paste0(CountryName, " (", SurveyYear, ")")) %>%
  left_join(country_estimates) %>%
  mutate(CountryName = factor(CountryName,
                              levels = country_estimates$CountryName)) %>% 
  mutate(Residence = str_to_sentence(Residence))

education <- education %>%
  mutate(CountryName = paste0(CountryName, " (", SurveyYear, ")")) %>%
  left_join(country_estimates) %>%
  mutate(Education = str_to_sentence(Education)) %>% 
  mutate(
    CountryName = factor(CountryName,
                         levels = country_estimates$CountryName),
    Education = factor(
      Education,
      levels = c("No education", "Primary", "Secondary", "Higher")
    )
  ) %>%
  filter(Education != "missing", !is.na(Education)) 

wealth <- wealth %>%
  mutate(CountryName = paste0(CountryName, " (", SurveyYear, ")")) %>%
  left_join(country_estimates) %>% 
  mutate(Wealth_Quintile = str_to_sentence(Wealth_Quintile)) %>%
  mutate(
    CountryName = factor(CountryName,
                         levels = country_estimates$CountryName),
    Wealth_Quintile = factor(
      Wealth_Quintile,
      levels = c("Poorest", "Poorer", "Middle", "Richer", "Richest")
    )
  ) 

# Residence Graph ------------------------------------------------------------

graph_residence <- plot_dumbbell(
  data = area,
  var = "Residence",
  var_label = "By Residence Area",
  legend_label = "Residence Area"
)

# Education Graph ------------------------------------------------------------

graph_education <- plot_dumbbell(
  data = education,
  var = "Education",
  var_label = "By Education Level",
  legend_label = "Education Level"
)

# Wealth Quintile Graph -------------------------------------------------------

graph_wealth <- plot_dumbbell(
  data = wealth,
  var = "Wealth_Quintile",
  var_label = "By Wealth Quintile",
  legend_label = "Wealth Quintile"
) 

# Make composite final Graph -------------------------------------------------

panel_plot <- grid.arrange(
  graph_education,
  graph_wealth,
  graph_residence,
  layout_matrix = cbind(rep(1, 5), rep(1, 5),
                        rep(2, 5), rep(2, 5),
                        rep(3, 5), rep(3, 5))
)

ggsave("plots/panel_plot.png", panel_plot, scale = 2.8, dpi = 1000)
