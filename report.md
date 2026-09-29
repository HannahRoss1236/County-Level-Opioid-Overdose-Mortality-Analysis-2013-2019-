# Report: County-Level Opioid Overdose Mortality Analysis

##1.Research Question

Are county-level opioid prescribing rates and poverty rates associated with drug overdose mortality, after adjusting for population size?

##2. Data 
Overdose deaths were identified Using the CDC/NCHS standard drug poisoning mortality definition: ICD-10 underlying cause-of-death codes X40–X44 (unintentional), X60–X64 (suicide), 
and Y10–Y14 (undetermined intent). This allows for the results to be comparable to published national statistics since it uses the same definition of overdose 
data by the CDC. The Homicide-related poisoning (X85) was excluded since it was not directly reflecting substance use risk. 

Data was pulled from CDC WONDER in multiple smaller queries due to server timeouts on the large county-level. Multiple year requests were made,
made, and validated to make sure the dataset was properly combined. 

##3. Handling the Data Supression
CDC suppresses any county-year cell that has fewer than 10 deaths to protect patient confidentiality and statistical unreliability. 
This impacted over half of the rows, which meant they could not just be deleted without consideration. First for the years that were suppressed the deaths 
were summed across the full 2013-2019 dataset per county. This aggregation allows for multiple counties to raise above the necessarily threshold(10). Then 
those that were still suppressed were imputed at 5. These suppressed years were still tracked individually to further analysis the impact. 

##4.Aligning Predictor and Outcome Time Windows
Using the Medicare Part D Prescribing File for 2024 would not allow for the prescribing rate to be associated with the right time period. So the CDC's Opioid 
Dispensing Rate Maps (2013-2019) were combined and used instead, and then the mortality and prescribing data were then restricted from 1999-2020 to 2013
-2019. Then the prescribing rate was averaged across all of the years to mimic the same combination of multiple years of mortality outcome. The counties with
counties were excluded from the prescribing average to help improve the reliability and only excluded 124 of the 3,100 counties. 

##5. Model 
Given that the overdose counts are relatively rare events a negative binomial regression was used to anaylze the number of deaths while accounting for 
differences in population size across the counties. 
The model included 'log(populations)' as an offset, which adjusts for how the counties with larger population with have more deaths. This changes the model
to estimate the overdose death rates rather than just the raw death counts to produce more meaningful results. 
A negative binomial model was chosen instead of a Poisson model because the death counts showed overdispersion, the variation in the number of deaths was 
greater than a Poisson model would accurately include. 

**Model 1** (prescribing rate only) showed no significant association
(p = 0.454).

**Model 2** (prescribing rate + poverty rate) showed both predictors
significantly associated with mortality, and a lower AIC than Model 1
(34,216 vs. 34,313), indicating improved fit:

| Predictor | Rate Ratio | 95% CI | p-value |
|---|---|---|---|
| Prescribing rate | 0.999 | 0.999–1.000 | 0.001 |
| Poverty rate | 1.016 | 1.013–1.019 | <0.001 |

#6. Interpretation

The prescribing rate was not significantly associated with overdose mortality in Model 1, but it became significant after poverty was added in Model 2.
This suggests that poverty may have been a confounding factor, meaning that it affected the relationship between prescribing rates and overdose deaths.
This is an important finding because it shows how including socioeconomic factors can change the results and interpretation of a statistical model.

The small negative relationship between prescribing rates and overdose mortality is consistent with research on the opioid crisis after 2013, 
when illicit fentanyl and heroin became major drivers of overdose deaths. Some studies suggest that, in certain areas, reduced access to prescription 
opioids may have coincided with greater use of more dangerous illicit drugs. However, this relationship does not necessarily mean that lower prescribing 
rates caused higher overdose mortality.

## 7. Limitations

- Since this was based off of a Ecological study design, the resulting association describes counties not the individuals. This means the association cannot
be used to interpret risk for an individual.
- The addition of 5 for the supressed cells can introduce some additional uncertainty and error into the resulting rate
- 2020 was excluded from the mortality and prescribing datasets because neither was available in a downloadable county-level format

##8. Tools 
R: `tidyverse`, `MASS` (negative binomial regression), `broom` (model
tidying), `tidycensus` (Census ACS data), `sf` (spatial mapping),
`ggplot2` (visualization).


