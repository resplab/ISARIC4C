
<!-- README.md is generated from README.Rmd. Please edit that file -->

# isaric4c

<!-- badges: start -->
<!-- badges: end -->

The goal of isaric4c is a risk stratification tools that predict in-hospital mortality or in-hospital clinical deterioration probability (defined as any requirement of ventilatory support or critical care, or death) for hospitalised COVID-19 patients.

## Installation

You can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("resplab/isaric4c")
```

## Example

This is a basic example for calculting in-hospital mortality probability. `func=0` stands for in-hospital mortality probability calculation. The individiaul is 69 years old male, has 1 comorbility, respiratory rate at 25 breaths per minute, admission oxygen saturation at 90%, Glasgow coma score at 10, urea 10 mmol/L, and CRP 10 mg/L. He would have 40.1% chance of in-hospital mortality
``` r
library(isaric4c)
isaric4c(age=69, sex=1, num_comorbidities=1, respiratory_rate=25, admission_oxygen_saturation=90, glasgow_coma_scale=10, urea=10, crp=70, func=0)
$morttality_probability
[1] 40.1
```

This is a basic example for calculting in-hospital clinical deterioration probability. `func=1` stands for in-hospital clinical deterioration probability calculation.The individiaul has symptom onset or first positive SARS-CoV-2 PCR more than 7 days after admission, is male, has radiographic chest infiltrates, is receiving oxygen when oxygen saturation measured, Glasgow coma score at 15, age at 23 years old, respiratory rate at 50 breaths per minute, admission oxygen saturation at 51%, urera 21 mmol/L, CRP 32 mg/L, and lymphocyte count 32 * 10^9. He would have 97.9% chance of in-hospital clinical deterioration.
``` r
isaric4c(nosocomial=1, sex=1, radiographic_chest_infiltrates=1, receiving_oxygen=1, glasgow_coma_scale=15, age=23, respiratory_rate=50, admission_oxygen_saturation=51, urea=21, crp=32, lymphocytes=32, func = 1)
$deterioration_probability
[1] 97.9
```

