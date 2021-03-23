# Prevalence of home birth among 880,345 women in 67 Low- and middle-income countries: a meta-analysis of Demographic and Health Surveys

This is the repository used to analyze the DHS country-level data to assess the home delivery prevalence and determinants among 67 low and middle-income countries. Data is accessed via the DHS program API in R. Then, weighted prevalences are obtained with the srvyr package.

## Packages Used

-   RDHS
-   srvyr
-   Tidyverse

## Usage

**1_get_datasets.R:**  Run the RDHS package replacing your project and providing username and password with access to DHS surveys. This script will download and cache all surveys from the year 2000 and later.

**2_append_datasets.R:** This script merges all country surveys into a big one ready to analyze and export, saving it as a local file.

**3_get_estimates.R:** Using the *srvyr* package, using the complex design of the DHS surveys, we obtained country-specific estimates of home delivery prevalences as general estimates and stratified by wealth quintile, residence and education.

**4_get_plots.R:** Generates the three different strata and country-specific dumbbell plots. Uses a wrapper function from the 0_functions.R script.

**5_get_map.R:** Generates the world map with low and middle-income prevalences of home delivery.
