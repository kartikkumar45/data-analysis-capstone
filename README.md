# End-to-End Data Analysis & Predictive Modeling in R

**Author:** Kartik Kumar  
**Project type:** Data analysis, statistical inference, visualization and predictive modeling  
**Primary language:** R

## Project overview

This repository presents an end-to-end analytical workflow covering three connected stages: data cleaning and exploratory analysis, visual storytelling, and statistical/predictive modeling. The emphasis is on making analytical decisions explicit, validating results, and separating descriptive findings from predictive claims.

## What this project demonstrates

- Data-quality inspection and missing-value treatment
- Outlier detection with domain-aware review
- Categorical encoding and feature normalization
- Exploratory data analysis and statistical summaries
- Clear, purposeful visualizations with `ggplot2`
- Hypothesis testing and effect-size analysis
- Logistic regression and random-forest classification
- Stratified train/test evaluation and 10-fold cross-validation
- ROC-AUC, confusion-matrix and precision-recall analysis
- Multicollinearity and model-diagnostic checks
- Variable-importance analysis
- Illustrative cost-sensitive threshold analysis

## Repository structure

```text
.
├── README.md
├── .gitignore
├── phase1_data_cleaning/
│   └── data_cleaning.R
├── phase2_data_visualization/
│   └── visualization.R
├── phase3_predictive_modeling/
│   ├── predictive_modeling.R
│   └── advanced_analysis.R
└── Comprehensive Data Analysis Report - Kartik Kumar_.docx
```

## Analytical phases

### Phase 1 — Data cleaning and preliminary analysis

The first workflow uses an `mtcars`-style dataset prepared with realistic missing values and data-entry anomalies. The script performs structural inspection, missingness assessment, IQR-based outlier screening, domain-aware correction, robust imputation, winsorization, categorical encoding and normalization. It also produces initial exploratory summaries and relationships between key variables.

**Main script:** `phase1_data_cleaning/data_cleaning.R`

### Phase 2 — Visualization and insight communication

The second workflow uses the Gapminder dataset to examine changes in life expectancy, GDP per capita, population and continental differences. It includes trend analysis, log-scaled relationships, distributions, rankings and group comparisons.

**Main script:** `phase2_data_visualization/visualization.R`

### Phase 3 — Statistical analysis and predictive modeling

The final workflow uses the Breast Cancer Wisconsin (Diagnostic) dataset for educational statistical and predictive analysis. It compares logistic regression with random forest using a stratified train/test split and 10-fold cross-validation. Evaluation includes confusion matrices, ROC-AUC, precision-recall analysis, model diagnostics and variable importance.

**Main scripts:**
- `phase3_predictive_modeling/predictive_modeling.R`
- `phase3_predictive_modeling/advanced_analysis.R`

> **Important:** The breast-cancer analysis is an educational modeling exercise, not a clinical diagnostic system. The cost-sensitive threshold analysis uses illustrative costs and must not be interpreted as clinical guidance.

## Reproducibility notes

The scripts expect their input data to be available locally. Dataset files are intentionally not treated as automatically generated results. Before running a workflow, review the file paths at the top of the relevant script and place the required input data in the expected location.

Recommended R environment:

- R 4.x
- tidyverse
- corrplot
- fastDummies
- gapminder
- scales
- caret
- car
- pROC
- randomForest
- broom
- PRROC

Install packages with:

```r
install.packages(c(
  "tidyverse", "corrplot", "fastDummies", "gapminder", "scales",
  "caret", "car", "pROC", "randomForest", "broom", "PRROC"
))
```

## Running the project

Run each phase independently from the repository root. The predictive-modeling extension must be run after `predictive_modeling.R` because it uses objects created by that script.

```text
Phase 1 → data_cleaning.R
Phase 2 → visualization.R
Phase 3 → predictive_modeling.R → advanced_analysis.R
```

## Analytical principles

The project follows several practical principles:

1. Inspect data before transforming it.
2. Treat outliers according to context rather than deleting observations automatically.
3. Keep exploratory analysis separate from predictive evaluation.
4. Use a held-out test set for final model assessment.
5. Compare models using more than a single accuracy figure.
6. State assumptions, limitations and intended use explicitly.

## Limitations

The datasets used here are primarily educational/public datasets rather than production business data. Results therefore demonstrate analytical technique and reasoning rather than a deployable production model. Thresholds, feature choices and cost assumptions should be re-evaluated for any real-world application.

## Supporting report

A detailed Word report is included in the repository for readers who want the full written documentation of the project.

## Contact

**Kartik Kumar** — GitHub: [kartikkumar45](https://github.com/kartikkumar45)
