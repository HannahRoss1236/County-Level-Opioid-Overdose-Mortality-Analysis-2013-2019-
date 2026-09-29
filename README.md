# County-Level-Opioid-Overdose-Mortality-Analysis-2013-2019

#Overview 

#Data Source
- CDC WONDER: Underlying Cause of Death, county-level, 2013-2019(ICD-10: X40-X44, X60-X64, Y10-Y14)
- CDC Opioid Dispensing Rate Maps, county-level, 2013-2019
- U.S. Census ACS 5-Year Estimates: county poverty rate, 2019
- Overdose deaths defined using the standard CDC/NCHS drug poisoning mortality case definition: ICD-10 codes X40–X44 (unintentional), X60–X64 (suicide), and Y10–Y14 (undetermined intent).

#Methods 
- Model: Negative binomial regression with population offset to evaluate the count
- Handled the suppression of deaths (cells <10) by the CDC through aggregating the deaths through the entire timeframe of the study and any remaining suppressed cells were then filled in with the midpoint(5).
- Mortality and prescribing data were restricted to 2013-2019 to ensure that both the predictor and outcome overlap with the same period. 

Full methods and reasoning are in [`report.md`](report.md).

#Key Findings
| Predictor | Rate Ratio | 95% CI | p-value |
|---|---|---|---|
| Opioid prescribing rate | 0.999 | 0.999–1.000 | 0.001 |
| Poverty rate | 1.016 | 1.013–1.019 | <0.001 |
- Each 1-point increase in county poverty rate was associated with a ~1.6% higher overdose death rate, when prescribing rate was held constant
- Prescribign rate shows a small significant inverse association with mortality, which overlaps with the shift seen post-2013 shift towards illicit synthetic opioids.

- ![Rate ratios](output/figures/forest_plot.png)

# Limitations
- Supressed cells were imputed at the midpoint, analysis with a lower imputed number for supressed cells is important
- 2020 was excluded from both datasets due to lack of standardized county-level data availability
- Prescribing and poverty data reflect county-level averages, not individual-level exposure since the data is based on a ecological study design.

# Tools

R (tidyverse, MASS, broom, tidycensus, sf, ggplot2)
