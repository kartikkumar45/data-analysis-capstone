## ===========================================================
## Phase 1: Data Cleaning & Preliminary Analysis in R
## Dataset: Motor Trend Car Road Tests (mtcars-style)
## ===========================================================

# ---- 0. Setup -------------------------------------------------------------
library(tidyverse)
library(corrplot)
library(fastDummies)

# Run from the repository root. Avoid machine-specific setwd() paths.
dir.create("output", showWarnings = FALSE, recursive = TRUE)

input_path <- file.path("data", "mtcars_raw.csv")
if (!file.exists(input_path)) {
  stop("Input file not found: ", input_path,
       "\nPlace the required dataset at data/mtcars_raw.csv before running the script.")
}

df <- read.csv(input_path, stringsAsFactors = FALSE)

# ---- 1. Initial inspection ------------------------------------------------
str(df)
summary(df)
dim(df)
head(df)

# ---- 2. Missing value diagnosis -------------------------------------------
colSums(is.na(df))
missing_pct <- round(colMeans(is.na(df)) * 100, 1)
missing_pct[missing_pct > 0]

missing_df <- data.frame(variable = names(missing_pct), pct = missing_pct)
ggplot(subset(missing_df, pct > 0), aes(x = variable, y = pct)) +
  geom_col() +
  labs(title = "Missing Values by Column (Raw Data)",
       y = "% missing", x = NULL) +
  theme_minimal()

# ---- 3. Outlier screening before cleaning ---------------------------------
boxplot(df$mpg, df$hp, df$wt,
        names = c("mpg", "hp", "wt"),
        main = "Boxplots (Raw Data) - Outlier Screening")

iqr_bounds <- function(x) {
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  c(lower = q1 - 1.5 * iqr, upper = q3 + 1.5 * iqr)
}

sapply(df[, c("mpg", "hp", "wt")], iqr_bounds)

df$model[df$mpg > iqr_bounds(df$mpg)["upper"] | df$mpg < iqr_bounds(df$mpg)["lower"]]
df$model[df$hp > iqr_bounds(df$hp)["upper"] | df$hp < iqr_bounds(df$hp)["lower"]]

# ---- 4. Data cleaning ------------------------------------------------------
# These thresholds are specific to the intentionally corrupted educational
# dataset. Review domain rules before applying similar logic elsewhere.
df$mpg[df$mpg > 60] <- NA
df$hp[df$hp > 500] <- NA

# Robust numeric imputation
for (col in c("mpg", "hp", "wt")) {
  df[[col]][is.na(df[[col]])] <- median(df[[col]], na.rm = TRUE)
}

# Mode imputation for cylinders
mode_val <- as.numeric(names(sort(table(df$cyl), decreasing = TRUE))[1])
df$cyl[is.na(df$cyl)] <- mode_val
df$cyl <- as.integer(df$cyl)

# Winsorize remaining mild outliers at IQR fences
for (col in c("mpg", "hp", "wt")) {
  b <- iqr_bounds(df[[col]])
  df[[col]] <- pmin(pmax(df[[col]], b["lower"]), b["upper"])
}

stopifnot(sum(is.na(df)) == 0)

boxplot(df$mpg, df$hp, df$wt,
        names = c("mpg", "hp", "wt"),
        main = "Boxplots (After Cleaning)")

# ---- 5. Encoding categorical variables ------------------------------------
df$cyl <- factor(df$cyl)
df$gear <- factor(df$gear)
df$vs <- factor(df$vs, labels = c("V-shaped", "Straight"))
df$am <- factor(df$am, labels = c("Automatic", "Manual"))

df_encoded <- fastDummies::dummy_cols(
  df,
  select_columns = c("cyl", "gear"),
  remove_selected_columns = FALSE
)

# ---- 6. Normalization ------------------------------------------------------
minmax <- function(x) (x - min(x)) / (max(x) - min(x))

df_norm <- df %>%
  mutate(across(c(mpg, disp, hp, wt, qsec, drat),
                minmax, .names = "{.col}_norm"))

write.csv(df_encoded, "output/mtcars_clean_encoded.csv", row.names = FALSE)
write.csv(df_norm, "output/mtcars_clean_normalized.csv", row.names = FALSE)

# ---- 7. Exploratory analysis -----------------------------------------------
summary(df[, c("mpg", "disp", "hp", "drat", "wt", "qsec")])

num_vars <- df[, c("mpg", "disp", "hp", "drat", "wt", "qsec")]
cor_matrix <- round(cor(num_vars), 2)
print(cor_matrix)

corrplot(cor_matrix, method = "color", addCoef.col = "black",
         type = "upper", title = "Correlation Matrix (Cleaned Data)")

ggplot(df, aes(x = mpg)) +
  geom_histogram(bins = 10) +
  labs(title = "Distribution of MPG (Cleaned Data)",
       x = "mpg", y = "Frequency") +
  theme_minimal()

ggplot(df, aes(x = wt, y = mpg, color = am)) +
  geom_point(size = 3, alpha = 0.85) +
  labs(title = "MPG vs Weight by Transmission Type",
       x = "wt (1000 lbs)", y = "mpg") +
  theme_minimal()

ggplot(df, aes(x = cyl, y = mpg)) +
  geom_boxplot() +
  labs(title = "MPG by Cylinder Count",
       x = "Cylinders", y = "mpg") +
  theme_minimal()

# ---- 8. Key numeric summaries ---------------------------------------------
aggregate(mpg ~ cyl, data = df, FUN = mean)
aggregate(mpg ~ am, data = df, FUN = mean)
cor(df$mpg, df$wt)
cor(df$mpg, df$hp)
