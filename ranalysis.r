
#Import the necessary libraries 
library(tidyverse)
library(MASS)
library(broom)
library(ggplot2)
#upload the files 
file1 <- read_tsv("/Users/hannah/Downloads/Underlying Cause of Death, 1999-2020 (3).tsv", show_col_types = FALSE)
file2 <- read_tsv("/Users/hannah/Downloads/Underlying Cause of Death, 1999-2020 (2).tsv", show_col_types = FALSE)
file3 <- read_tsv("/Users/hannah/Downloads/Underlying Cause of Death, 1999-2020 (1).tsv", show_col_types = FALSE)
file4 <- read_tsv("/Users/hannah/Downloads/Underlying Cause of Death, 1999-2020.tsv", show_col_types = FALSE)

#make each file lower case with _ instead of spaces and filters with NA in year column 
names(file1) <- tolower(names(file1))
names(file1) <- gsub(" ", "_", names(file1))
#Drops any rows that have NA in the year column 
file1 <- file1 %>%
  filter(!is.na(year))

names(file2) <- tolower(names(file2))
names(file2) <- gsub(" ", "_", names(file2))
file2 <- file2 %>%
  filter(!is.na(year))

names(file3) <- tolower(names(file3))
names(file3) <- gsub(" ", "_", names(file3))
file3 <- file3 %>%
  filter(!is.na(year))

names(file4) <- tolower(names(file4))
names(file4) <- gsub(" ", "_", names(file4))
file4 <- file4 %>%
  filter(!is.na(year))
#identifies any problems
problems(file1)
problems(file2)
problems(file3)
problems(file4)
# how many rows are in each of the files 
nrow(file1)
nrow(file2)
nrow(file3)
nrow(file4)
# Merges the four files 
od_data <- bind_rows(file1, file2, file3, file4)
#how many rows are in per year count
count(od_data, year)

#replaces suppressed data with NA 
od_data$deaths[od_data$deaths == "Suppressed"] <- NA

# Convert deaths to numeric values
od_data$deaths <- as.numeric(od_data$deaths)
#Counts how many values are NA in the death columns and then counts total number of rows 
sum(is.na(od_data$deaths))
nrow(od_data)

#Makes sure to convert the data into numeric values for the death and population columns 
od_data$deaths <- as.numeric(od_data$deaths)
od_data$population <- as.numeric(od_data$population)

# Create a column to identify rows with missing death counts
od_data$was_suppressed <- is.na(od_data$deaths)
#Makes a new collumn that fills in the missing value with 
od_data$deaths_filled <- od_data$deaths
od_data$deaths_filled[is.na(od_data$deaths_filled)] <- 5

#Total dealth in a new dataset  
county_totals <- od_data %>%
  group_by(county_code, county) %>%
  summarise(total_deaths = sum(deaths_filled), total_population = sum(population, na.rm = TRUE), years_suppressed = sum(was_suppressed),.groups= "drop")
#create new dataset that has the total deaths and population for the entire time period for each country and the number years that had been supressed 
head(county_totals)
nrow(county_totals)
table(county_totals$years_suppressed)
county_totals <- county_totals %>%
  filter(!is.na(total_population), total_population > 0)

# Add in self made CSV of the data opiod rate in years of 2013 to 2019
rate_2019 <- read_csv("/Users/hannah/Downloads/Book 1(year2019).csv", show_col_types = FALSE)
rate_2019$year <- 2019

rate_2018 <- read_csv("/Users/hannah/Downloads/Book 1(year2018).csv", show_col_types = FALSE)
rate_2018$year <- 2018

rate_2017 <- read_csv("/Users/hannah/Downloads/Book 1(year2017).csv", show_col_types = FALSE)
rate_2017$year <- 2017

rate_2016 <- read_csv("/Users/hannah/Downloads/Book 1(year2016).csv", show_col_types = FALSE)
rate_2016$year <- 2016

rate_2015 <- read_csv("/Users/hannah/Downloads/Book 1(Year2016).csv", show_col_types = FALSE)
rate_2015$year <- 2015

rate_2014 <- read_csv("/Users/hannah/Downloads/Book 1(year2014).csv", show_col_types = FALSE)
rate_2014$year <- 2014

rate_2013 <- read_csv("/Users/hannah/Downloads/Book 1(year2013).csv", show_col_types = FALSE)
rate_2013$year <- 2013

#Clean the column names and make them lowercases with no space

names(rate_2019) <- tolower(names(rate_2019))
names(rate_2019) <- gsub(" ", "_", names(rate_2019))

names(rate_2018) <- tolower(names(rate_2018))
names(rate_2018) <- gsub(" ", "_", names(rate_2018))

names(rate_2017) <- tolower(names(rate_2017))
names(rate_2017) <- gsub(" ", "_", names(rate_2017))

names(rate_2016) <- tolower(names(rate_2016))
names(rate_2016) <- gsub(" ", "_", names(rate_2016))

names(rate_2015) <- tolower(names(rate_2015))
names(rate_2015) <- gsub(" ", "_", names(rate_2015))

names(rate_2014) <- tolower(names(rate_2014))
names(rate_2014) <- gsub(" ", "_", names(rate_2014))

names(rate_2013) <- tolower(names(rate_2013))
names(rate_2013) <- gsub(" ", "_", names(rate_2013))

#merge together all of these files into one dataset

opioid_rates_all <- bind_rows(rate_2013, rate_2014, rate_2015, rate_2016, rate_2017, rate_2018, rate_2019, rate_2020)

#Some value is not allowing for the columns to be renamed properly and made into a numeric value so turn any character into NA and then convert into numeric 
rate_2016$opioid_dispensing_rate_per_100 <- iconv(
  rate_2016$opioid_dispensing_rate_per_100, 
  from = "UTF-8", 
  to = "ASCII//TRANSLIT", 
  sub = ""
)
rate_2016$opioid_dispensing_rate_per_100 <- as.numeric(rate_2016$opioid_dispensing_rate_per_100)

rate_2015$opioid_dispensing_rate_per_100 <- iconv(
  rate_2015$opioid_dispensing_rate_per_100, 
  from = "UTF-8", 
  to = "ASCII//TRANSLIT", 
  sub = ""
)
rate_2015$opioid_dispensing_rate_per_100 <- as.numeric(rate_2015$opioid_dispensing_rate_per_100)

rate_2014$opioid_dispensing_rate_per_100 <- iconv(
  rate_2014$opioid_dispensing_rate_per_100, 
  from = "UTF-8", 
  to = "ASCII//TRANSLIT", 
  sub = ""
)
rate_2014$opioid_dispensing_rate_per_100 <- as.numeric(rate_2014$opioid_dispensing_rate_per_100)

rate_2013$opioid_dispensing_rate_per_100 <- iconv(
  rate_2013$opioid_dispensing_rate_per_100, 
  from = "UTF-8", 
  to = "ASCII//TRANSLIT", 
  sub = ""
)
rate_2013$opioid_dispensing_rate_per_100 <- as.numeric(rate_2013$opioid_dispensing_rate_per_100)

#Retry binding the rows successfully 
opioid_rates_all <- bind_rows(rate_2013, rate_2014, rate_2015, rate_2016, rate_2017, rate_2018, rate_2019)

#Average the prescribing rate per the county across the years 2013-2019 and make a new dataset
predictors_avg <- opioid_rates_all %>%
    group_by(county_fips_code) %>%
    summarise(avg_prescribing_rate = mean(opioid_dispensing_rate_per_100, na.rm = TRUE))

#Years with data for each country by summarizing creating a new dataset that counts number of rows in each county group per year to find how many missing years there are 
year_counts <- opioid_rates_all %>%
  filter(!is.na(opioid_dispensing_rate_per_100)) %>%
  group_by(county_fips_code) %>%
  summarise(years_with_data = n())

table(year_counts$years_with_data)
#Clean the Fips code so that they are also all 5 digits and not 4 digits for some of them 
predictors_avg$county_fips_code <- as.numeric(predictors_avg$county_fips_code)
predictors_avg$county_fips_code <- as.character(predictors_avg$county_fips_code)
predictors_avg$county_fips_code <- sprintf("%05d", as.numeric(predictors_avg$county_fips_code))
county_totals$county_code <- as.numeric(county_totals$county_code)
county_totals$county_code <- as.character(county_totals$county_code)
county_totals$county_code <- sprintf("%05d", as.numeric(county_totals$county_code))

#Merge with the mortality data
analysis_data <- left_join(county_totals, predictors_avg, by = c("county_code" = "county_fips_code"))
#filter out any of the perscribing rate that had no missing data in the anaylsis dataset 
analysis_data <- analysis_data %>%
  filter(!is.na(avg_prescribing_rate))

#Add in an additional poverty data into the analysis 
library(tidycensus)
poverty_data <- get_acs( geography = "county", variables = c(poverty_rate = "S1701_C03_001"), year = 2019, survey = "acs5" ) names(poverty_data) head(poverty_data)

names(poverty_data)[names(poverty_data) == "GEOID"] <- "county_fips_code"
names(poverty_data)[names(poverty_data) == "estimate"] <- "poverty_rate"
poverty_data <- poverty_data[, c("county_fips_code", "poverty_rate")]
head(poverty_data)
# FIX the FIPS formatting  
poverty_data$county_fips_code <- sprintf("%05d", as.numeric(poverty_data$county_fips_code))
head(poverty_data$county_fips_code)

# MErge into the existing anaylsis dataset 
analysis_data <- left_join(analysis_data, poverty_data,
                            by = c("county_code" = "county_fips_code"))

#Run the negative binomial regression model with the offset for the population size 

model2 <- glm.nb(
  total_deaths ~ avg_prescribing_rate + poverty_rate + offset(log(total_population)),
  data = analysis_data
)

summary(model2)
# make a summary of the results and exponentiate the coefficients to get the incidence rate ratios 
library(broom)
model_results <- tidy(model2)
model_results$estimate <- exp(model_results$estimate)
model_results <- tidy(model2, exponentiate = TRUE, conf.int = TRUE)
model_results

#Model comparision(lower value means improved model fit)
AIC(model1, model2)

#Makes a forest plot of the results of the model 
model_results <- model_results %>%
  filter(term != "(Intercept)")
plot <- ggplot(model_results, aes(x = term, y = estimate)) +
  geom_point() +
  geom_errorbar(
    aes(ymin = conf.low, ymax = conf.high),
    width = 0.2
  ) +
geom_hline(
    yintercept = 1,
    linetype = "dashed",
    color = "red"
  ) +
coord_flip() +
labs(
    title = "Rate Ratios: Overdose Mortality Predictors",
    x = NULL,
    y = "Rate Ratio (95% CI)"
  )
plot
ggsave("output/figures/forest_plot.png", width = 8, height = 5, dpi = 300)

