# Dataset setup

The repository keeps external/raw datasets out of version control. This keeps the repository lightweight and avoids distributing datasets whose licensing or redistribution terms may vary.

## Phase 1

Place the required `mtcars`-style input file here:

```text
data/mtcars_raw.csv
```

The file should contain the variables expected by `phase1_data_cleaning/data_cleaning.R`, including `model`, `mpg`, `disp`, `hp`, `drat`, `wt`, `qsec`, `cyl`, `vs`, `am` and `gear`.

## Phase 3

Place the Breast Cancer Wisconsin (Diagnostic) input file here or update the path in the modeling script:

```text
data/breast_cancer_data.csv
```

The file should contain a binary `diagnosis` field (`B` = benign, `M` = malignant) and the predictor columns used by `phase3_predictive_modeling/predictive_modeling.R`.

## Reproducibility

Before running a phase, confirm that its input dataset exists and that the column names match the script. Do not commit private, restricted or licensed data merely to make the example run; provide a lawful source or acquisition instruction instead.
