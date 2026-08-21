## ===========================================================
## Week 1 Task: Data Cleaning & Preliminary Analysis in R
## Dataset: Motor Trend Car Road Tests ("mtcars-style"), with
##          realistic missing values and data-entry outliers
##          injected to simulate a messy public download.
## ===========================================================
## ---- 0. Setup ----
library(tidyverse)   # dplyr, ggplot2, tidyr
library(corrplot)    # correlation heatmap
library(fastDummies) # one-hot encoding
setwd("~/mtcars_project")
df <- read.csv("data/mtcars_raw.csv", stringsAsFactors = FALSE)
## ---- 1. Initial inspection ----
str(df)
summary(df)
dim(df)
head(df)
## ---- 2. Missing value diagnosis ----
colSums(is.na(df))
missing_pct <- round(colMeans(is.na(df)) * 100, 1)
missing_pct[missing_pct > 0]
# Visualize missingness
missing_df <- data.frame(variable = names(missing_pct), pct = missing_pct)
ggplot(subset(missing_df, pct > 0), aes(x = variable, y = pct)) +
  geom_col(fill = "firebrick") +
  labs(title = "Missing values by column (raw data)",
       y = "% missing", x = NULL) +
  theme_minimal()
## ---- 3. Outlier screening (before cleaning) ----
boxplot(df$mpg, df$hp, df$wt,
        names = c("mpg", "hp", "wt"),
        main = "Boxplots (raw data) - outlier screening")
iqr_bounds <- function(x) {
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  c(lower = q1 - 1.5 * iqr, upper = q3 + 1.5 * iqr)
}
sapply(df[, c("mpg", "hp", "wt")], iqr_bounds)
# Flag records outside IQR fences
df$model[df$mpg > iqr_bounds(df$mpg)["upper"] | df$mpg < iqr_bounds(df$mpg)["lower"]]
df$model[df$hp  > iqr_bounds(df$hp)["upper"]  | df$hp  < iqr_bounds(df$hp)["lower"]]
## ---- 4. Data cleaning ----
# 4a. Correct implausible data-entry errors (domain knowledge:
#     no 1974-era road-test car exceeds ~40 mpg or ~430 hp)
df$mpg[df$mpg > 60] <- NA
df$hp[df$hp > 500]  <- NA
# 4b. Impute missing numeric values with the median (robust to skew/outliers)
for (col in c("mpg", "hp", "wt")) {
  df[[col]][is.na(df[[col]])] <- median(df[[col]], na.rm = TRUE)
}
# 4c. Impute missing categorical value (cyl) with the mode
mode_val <- as.numeric(names(sort(table(df$cyl), decreasing = TRUE))[1])
df$cyl[is.na(df$cyl)] <- mode_val
df$cyl <- as.integer(df$cyl)
# 4d. Winsorize (cap) remaining mild outliers at the 1.5*IQR fences
for (col in c("mpg", "hp", "wt")) {
  b <- iqr_bounds(df[[col]])
  df[[col]] <- pmin(pmax(df[[col]], b["lower"]), b["upper"])
}
sum(is.na(df))   # confirm 0 missing values remain
boxplot(df$mpg, df$hp, df$wt,
        names = c("mpg", "hp", "wt"),
        main = "Boxplots (after cleaning)")
## ---- 5. Encoding categorical variables ----
df$cyl  <- factor(df$cyl)
df$gear <- factor(df$gear)
df$vs   <- factor(df$vs, labels = c("V-shaped", "Straight"))
df$am   <- factor(df$am, labels = c("Automatic", "Manual"))
# One-hot encode cyl and gear for modeling-ready output
df_encoded <- fastDummies::dummy_cols(df, select_columns = c("cyl", "gear"),
                                       remove_selected_columns = FALSE)
head(df_encoded)
## ---- 6. Normalization ----
minmax <- function(x) (x - min(x)) / (max(x) - min(x))
df_norm <- df %>%
  mutate(across(c(mpg, disp, hp, wt, qsec, drat), minmax, .names = "{.col}_norm"))
head(df_norm[, c("model", "mpg", "mpg_norm", "hp", "hp_norm", "wt", "wt_norm")])
write.csv(df_encoded, "output/mtcars_clean_encoded.csv", row.names = FALSE)
write.csv(df_norm,    "output/mtcars_clean_normalized.csv", row.names = FALSE)
## ---- 7. Exploratory Data Analysis ----
summary(df[, c("mpg", "disp", "hp", "drat", "wt", "qsec")])
num_vars <- df[, c("mpg", "disp", "hp", "drat", "wt", "qsec")]
cor_matrix <- round(cor(num_vars), 2)
cor_matrix
corrplot(cor_matrix, method = "color", addCoef.col = "black",
         type = "upper", tl.col = "black", title = "Correlation matrix (cleaned data)")
ggplot(df, aes(x = mpg)) +
  geom_histogram(bins = 10, fill = "#2980b9", color = "white") +
  labs(title = "Distribution of mpg (cleaned data)", x = "mpg", y = "Frequency") +
  theme_minimal()
ggplot(df, aes(x = wt, y = mpg, color = am)) +
  geom_point(size = 3, alpha = 0.85) +
  labs(title = "mpg vs weight, by transmission type",
       x = "wt (1000 lbs)", y = "mpg") +
  theme_minimal()
ggplot(df, aes(x = cyl, y = mpg)) +
  geom_boxplot(fill = "#95a5a6") +
  labs(title = "mpg by cylinder count", x = "Cylinders", y = "mpg") +
  theme_minimal()
## ---- 8. Key numeric insights ----
aggregate(mpg ~ cyl, data = df, FUN = mean)
aggregate(mpg ~ am,  data = df, FUN = mean)
cor(df$mpg, df$wt)
cor(df$mpg, df$hp)
