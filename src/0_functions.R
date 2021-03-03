# Get last Survey ---------------------------------------------------------

get_last_survey <- function() {
  dhs_surveys() %>%
    filter(SurveyType == "DHS") %>%
    group_by(SubregionName, CountryName, DHS_CountryCode) %>%
    summarise(SurveyYear = max(SurveyYear)) %>%
    arrange(desc(SurveyYear)) %>%
    merge(
      dhs_surveys() %>%
        select(CountryName, SurveyYear, SurveyId),
      by = c("CountryName", "SurveyYear")
    )
}


# bind_dhs_var -----------------------------------------------------------

bind_dhs_var <- function(var_data,var, desc, data, id) {
  bind_rows(var_data,
    tibble(
      variable = var,
      description = desc,
      dataset_filename = data,
      dataset_path = paste0(
        "C:/Users/horac/Documents/R/RDHS",
        "/data/datasets/",
        data,
        ".rds"
      ),
      survey_id = id
    )
  )
}


# Dumbbell Plots ------------------------------------------------------
library(scales)

plot_dumbbell <- function(data, var, var_label, legend_label){
  ggplot(data) +
    geom_line(
      aes(x = CountryName, y = prop_dom, group = CountryName),
      color = "gray20",
      size = .25
    ) +
    geom_point(
      aes(
        x = CountryName,
        y = prop_dom,
        color = .data[[var]],
        group = .data[[var]],
        shape = var_label
      )
    ) +
    geom_point(
      aes(x = CountryName,
          y = prop_avg,
          shape = "National Average"),
      color = "black",
      size = 2
    ) +
    scale_color_brewer(palette = "Set1", direction = -1) +
    scale_y_continuous(labels = percent) +
    scale_shape_manual(values = c(19,18)) +
    theme_bw() +
    theme(legend.justification = c(1,0), 
          legend.position = c(0.985, 0.03),
          legend.box.background = element_rect(color="black", size=0.5),
          legend.box.margin = margin(1, 1, 1, 1)) +
    coord_flip() +
    labs(
      x = "Country",
      y = "Home Delivery Prevalence",
      color = legend_label,
      shape = "Aggregation Level"
    ) +
    guides(shape = guide_legend(order = 1),col = guide_legend(order = 2))
}


