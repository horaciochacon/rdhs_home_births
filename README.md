# Prevalence of home birth among 880,345 women in 67 Low- and middle-income countries: a meta-analysis of Demographic and Health Surveys

This is the repository used for the analysis of DHS country level data to asses home delivery prevalence and determinants among 67 low and middle income countries. Data is accesed via the DHS program API in R. Then, weighted prevalences are obtained with the srvyr package.

## Packages Used

* RDHS
* srvyr
* Tidyverse

## Usage

1. Replace credentials in *get_countries_datasets.R* with your own (make sure you have requested acces to specific DHS country surveys)
2. Just *DHS_analysis.R* to obtain the prevalence estimates per country.


