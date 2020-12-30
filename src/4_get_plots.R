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
  mutate(CountryName = paste0(CountryName," (", SurveyYear,")")) %>% 
  select(CountryName, prop_avg = prop_dom)


area <- area %>%
  left_join(country_estimates) %>%
  mutate(
    CountryName = factor(
      paste0(CountryName," (", SurveyYear,")"),
      levels = country_estimates$CountryName
      )
    )

education <- education %>%
  left_join(country_estimates) %>%
  mutate(
    CountryName = factor(
      paste0(CountryName," (", SurveyYear,")"),
      levels = country_estimates$CountryName),
    Education = factor(
      Education,
      levels = c("no education", "primary", "secondary", "higher")
    )
  ) %>%
  filter(Education != "missing", !is.na(Education))

wealth <- wealth %>%
  left_join(country_estimates) %>%
  mutate(
    CountryName = factor(
      paste0(CountryName," (", SurveyYear,")"),
      levels = country_estimates$CountryName),
    Wealth_Quintile = factor(
      Wealth_Quintile,
      levels = c("poorest", "poorer", "middle", "richer", "richest")
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
  graph_wealth,
  graph_education,
  graph_residence,
  layout_matrix = cbind(rep(1, 5), rep(1, 5),
                        rep(2, 5), rep(2, 5),
                        rep(3, 5), rep(3, 5))
)

ggsave("plots/panel_plot.png",panel_plot,scale = 2.75,dpi = 500)
