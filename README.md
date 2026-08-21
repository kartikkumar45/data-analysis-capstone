# Data Analysis Capstone — R

**Author:** Kartik Kumar  
**Focus:** Data cleaning, exploratory visualization, statistical analysis, predictive modeling, and model evaluation in R

## Project overview

This repository brings together a three-phase data-analysis workflow developed across the project: cleaning and preparing a deliberately messy `mtcars`-style dataset, using the Gapminder dataset to communicate patterns through purposeful visualizations, and applying statistical inference and predictive classification to the Breast Cancer Wisconsin (Diagnostic) dataset.

The emphasis is not simply on producing charts or model scores. Each phase documents why a particular cleaning rule, visualization, statistical test, or validation method was chosen, and separates descriptive association from causal claims.

The accompanying report provides the full narrative, tables, figures, interpretations, limitations, and appendices containing the phase-specific R code.

## Project at a glance

| Phase | Focus | Dataset | Main techniques |
|---|---|---|---|
| I | Data cleaning & preliminary analysis | Motor Trend Car Road Tests (`mtcars`-style) | Missing-value treatment, outlier handling, encoding, normalization, correlation analysis |
| II | Data visualization & insight communication | Gapminder, 1952–2007 | Trend analysis, distribution analysis, group comparison, relationship visualization |
| III | Statistical analysis & predictive modeling | Breast Cancer Wisconsin (Diagnostic) | Hypothesis testing, logistic regression, multicollinearity diagnostics, random forest, cross-validation, ROC/AUC |

## Repository structure

```text
├── README.md
├── .gitignore
├── phase1_data_cleaning/
│   └── data_cleaning.R
├── phase2_data_visualization/
│   └── visualization.R
├── phase3_predictive_modeling/
│   ├── predictive_modeling.R
│   └── advanced_analysis.R
└── report/
    └── Comprehensive_Data_Analysis_Report.docx
```

## What the analysis demonstrates

### Phase I — Data cleaning

The working `mtcars`-style dataset contains intentionally introduced missing values and implausible entries so that the cleaning workflow reflects a realistic data-quality exercise. The script diagnoses missingness and outliers, corrects clearly implausible entries, uses median/mode imputation where justified, applies IQR-based winsorization, encodes categorical variables, and creates normalized variables.

A key finding is the strong negative association between vehicle weight and fuel efficiency (`r ≈ -0.81`). The report also uses a simple regression of `mpg` on `wt` to connect exploratory analysis with predictive reasoning.

### Phase II — Visualization

The Gapminder dataset contains 1,704 country-year observations across 142 countries from 1952 to 2007. The analysis deliberately uses different chart types for different questions rather than repeating the same visualization pattern. It examines life-expectancy trends, the relationship between GDP per capita and life expectancy, continent-level comparisons, distributions, and population growth.

The analysis is descriptive: visual association and correlation are not treated as evidence of causation.

### Phase III — Predictive modeling

The Breast Cancer Wisconsin (Diagnostic) dataset contains 569 observations and 30 numeric predictors plus the diagnosis outcome. The workflow examines class balance, distributional assumptions, group differences, multicollinearity, explanatory logistic regression, and predictive random forest performance.

The final evaluation reports both cross-validation and held-out test performance rather than relying on a single accuracy figure. The accompanying advanced analysis also examines effect sizes, precision-recall behaviour, confidence intervals, and decision-threshold implications.

> **Responsible-use note:** The breast-cancer analysis is an educational statistical exercise, not a clinical diagnostic system. The reported performance should not be interpreted as evidence of readiness for medical deployment. Independent external validation, calibration, clinical review, and prospective evaluation would be required before any real-world use.

## R environment

The project was written for R/RStudio using packages including:

```r
install.packages(c(
  "tidyverse", "corrplot", "fastDummies",
  "gapminder", "scales",
  "caret", "car", "pROC", "randomForest", "broom", "PRROC"
))
```

The Gapminder dataset is supplied by the `gapminder` R package. The Phase I and Phase III scripts expect the corresponding working datasets used for the submitted analysis (`data/mtcars_raw.csv` and `breast_cancer_data.csv`). Those source data files are not included in this repository package, so the scripts should be read together with the report and its documented data-source information rather than assuming a fresh clone is completely self-contained.

## Running the scripts

From the repository root in RStudio:

```r
source("phase1_data_cleaning/data_cleaning.R")
source("phase2_data_visualization/visualization.R")
source("phase3_predictive_modeling/predictive_modeling.R")
source("phase3_predictive_modeling/advanced_analysis.R")
```

Phase I also writes cleaned/encoded outputs to an `output/` directory when the required working dataset is available. The scripts are intentionally kept close to the versions documented in the final report so that the public repository remains an accurate record of the submitted work.

## Selected findings

- Weight shows a strong negative relationship with `mpg` in the cleaned `mtcars`-style analysis.
- Life expectancy rises across every continent over the Gapminder study period, while the pace and starting levels differ substantially.
- In the breast-cancer analysis, logistic regression and random forest both perform strongly on the held-out test set, while their cross-validation and error profiles illustrate why model assessment should go beyond one headline accuracy number.
- The advanced analysis highlights the practical importance of effect sizes, precision-recall behaviour, and threshold selection in addition to conventional ROC/AUC reporting.

## Reproducibility and interpretation

The consolidated report explains the verification approach used during project preparation and provides the detailed outputs and reasoning behind the results. All reported associations are interpreted conservatively, and the distinction between explanatory analysis and predictive performance is maintained throughout.

The repository is intentionally concise: it contains the analysis code and final report rather than fabricated screenshots, synthetic result files, or unrelated material added solely to make the project appear larger.

## Report

The full report is available under [`report/`](./report) and contains the complete narrative, methodology, results, limitations, future directions, and R appendices for all three phases.

---

**Kartik Kumar**  
Data Analysis Capstone | R | August 2026
