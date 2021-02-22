library(tidyverse)
library(rnaturalearth)
library(scales)
library(sf)
library(rgeos)
theme_set(theme_bw())

# Read Data ---------------------------------------------------------------

country_estimates <- read_csv("output/estimates_countries.csv")
world <- ne_countries(scale = "large", returnclass = "sf") %>%
  mutate(
    name = case_when(
      name == "Kyrgyzstan" ~ "Kyrgyz Republic",
      name == "Dominican Rep." ~ "Dominican Republic",
      name == "Dem. Rep. Congo" ~ "Congo Democratic Republic",
      name == "São Tomé and Principe" ~ "Sao Tome and Principe",
      name == "Swaziland" ~ "Eswatini",
      name == "Côte d'Ivoire" ~ "Cote d'Ivoire",
      TRUE ~ name
    )
  ) %>%  
  filter(name != "Antarctica") %>% 
  select(name, name_long, geometry)


# Merge spatial data ------------------------------------------------------

dhs_spatial_all <- world %>% 
  merge(country_estimates, by.x = "name", by.y = "CountryName", all = TRUE )

dhs_spatial <- world %>% 
  merge(country_estimates, by.x = "name", by.y = "CountryName")



# Plot map ----------------------------------------------------------------

dhs_map <- ggplot(dhs_spatial_all) +
  geom_sf(fill = "#eae2b7", alpha = 0.4) +
  geom_sf(data = dhs_spatial, aes(fill = prop_dom)) +
  scale_fill_distiller(
    palette = "YlOrRd", 
    breaks = 0.25*0:4,
    labels = percent(0.25*0:4),
    direction = 1, 
    name = "Home delivery (%)") +
  coord_sf(xlim = c(-120, 170), ylim = c(-50,55)) +
  theme(
    panel.grid.major = element_line(colour = "transparent"), 
    panel.background = element_rect(fill = "aliceblue"),
    legend.position = c(.65,.25),
    legend.background = element_rect(
      colour = 'black', 
      fill = 'white', 
      linetype='solid')
    )


# Save map ----------------------------------------------------------------

ggsave("plots/map.png", dhs_map, scale = 2, dpi = 300)



