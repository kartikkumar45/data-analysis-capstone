# Data Analysis Capstone — R

**Author:** Kartik Kumar  
**Focus:** Data cleaning, exploratory visualization, statistical analysis, predictive modeling, and model evaluation in R

## Project overview

This repository brings together the three analytical phases developed across Weeks 1–4: cleaning and preparing a deliberately messy `mtcars`-style dataset, communicating patterns in the Gapminder dataset through purposeful visualizations, and applying statistical inference and predictive classification to the Breast Cancer Wisconsin (Diagnostic) dataset.

The emphasis is not simply on producing charts or model scores. Each phase documents the reasoning behind the cleaning rules, visual choices, statistical tests, validation methods, and model evaluation, while keeping descriptive association separate from causal claims.

The consolidated Week 4 report is included in the repository as **`Comprehensive Data Analysis Report - Kartik Kumar_.docx`** and provides the full narrative, results, limitations, future directions, and R appendices.

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
├── Comprehensive Data Analysis Report - Kartik Kumar_.docx
├── phase1_data_cleaning/
│   └── data_cleaning.R
├── phase2_data_visualization/
│   └── visualization.R
└── phase3_predictive_modeling/
    ├── predictive_modeling.R
    └── advanced_analysis.R
```

## What the analysis demonstrates

### Phase I — Data cleaning

The working `mtcars`-style dataset contains intentionally introduced missing values and implausible entries so that the cleaning workflow reflects a realistic data-quality exercise. The script diagnoses missingness and outliers, corrects clearly implausible entries, uses median/mode imputation where justified, applies IQR-based winsorization, encodes categorical variables, and creates normalized variables.

The analysis then examines relationships among fuel efficiency, weight, horsepower, cylinders, and transmission. The report uses these exploratory relationships to motivate further interpretation without treating correlation as causation.

### Phase II — Visualization

The Gapminder dataset contains 1,704 country-year observations across 142 countries from 1952 to 2007. The analysis deliberately uses different chart types for different questions. It examines life-expectancy trends, the relationship between GDP per capita and life expectancy, continent-level comparisons, distributions, and population growth.

The analysis is descriptive: visual association and correlation are not treated as evidence of causation.

### Phase III — Statistical analysis & predictive modeling

The Breast Cancer Wisconsin (Diagnostic) dataset contains 569 observations and 30 numeric predictors plus the diagnosis outcome. The workflow examines class balance, distributional assumptions, group differences, multicollinearity, explanatory logistic regression, and predictive random forest performance.

The evaluation uses a stratified 70/30 train-test split together with 10-fold cross-validation, confusion matrices, ROC/AUC analysis, residual and influence diagnostics, and variable-importance analysis. The advanced script extends the evaluation with standardized effect sizes, precision-recall analysis, and an explicitly illustrative cost-sensitive threshold analysis.

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

The Gapminder dataset is supplied by the `gapminder` R package. The Phase I and Phase III scripts expect the corresponding working datasets used for the submitted analysis (`data/mtcars_raw.csv` and `breast_cancer_data.csv`). Those source data files are not included in this repository package, so the scripts should be read together with the consolidated report and its documented data-source information rather than assuming a fresh clone is completely self-contained.

## Running the scripts

From the repository root in RStudio:

```r
source("phase1_data_cleaning/data_cleaning.R")
source("phase2_data_visualization/visualization.R")
source("phase3_predictive_modeling/predictive_modeling.R")
source("phase3_predictive_modeling/advanced_analysis.R")
```

Phase I also writes cleaned/encoded outputs to an `output/` directory when the required working dataset is available. The scripts are intentionally kept close to the workflow documented in the final report so that the public repository remains an accurate record of the submitted project.

## Interpretation and reproducibility

The consolidated report provides the detailed methodology, results, limitations, and future directions. All reported associations are interpreted conservatively, and the distinction between explanatory analysis and predictive performance is maintained throughout.

The repository is intentionally concise. It contains the analysis code and final report rather than fabricated screenshots, synthetic result files, or unrelated material added only to make the project appear larger.

## Report

The complete Week 4 report is available at the repository root:

**[Comprehensive Data Analysis Report - Kartik Kumar_.docx](./Comprehensive%20Data%20Analysis%20Report%20-%20Kartik%20Kumar_.docx)**

It consolidates the Week 1–3 work into a single documented capstone and contains the detailed narrative, methodology, results, limitations, future directions, and R appendices.

---

**Kartik Kumar**  
Data Analysis Capstone | R | August 2026
