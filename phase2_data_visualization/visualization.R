##############################################################################
# Phase 2: Data Visualization and Insight Communication
# Dataset: Gapminder (Bryan et al.)
# Author: Kartik Kumar
##############################################################################

library(tidyverse)
library(gapminder)
library(scales)

dir.create("output", showWarnings = FALSE, recursive = TRUE)
dir.create(file.path("output", "figures"), showWarnings = FALSE, recursive = TRUE)

gap <- gapminder

# ---- 1. Data quality checks ------------------------------------------------
str(gap)
dim(gap)
n_distinct(gap$country)
sort(unique(gap$year))

stopifnot(sum(is.na(gap)) == 0)
stopifnot(nrow(gap %>% count(country, year) %>% filter(n > 1)) == 0)

# ---- 2. Life expectancy trend by continent -------------------------------
cont_year <- gap %>%
  group_by(continent, year) %>%
  summarise(lifeExp = mean(lifeExp), .groups = "drop")

p1 <- ggplot(cont_year, aes(x = year, y = lifeExp, color = continent)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 1.6) +
  labs(title = "Average Life Expectancy by Continent, 1952-2007",
       x = "Year", y = "Life expectancy (years)", color = "Continent") +
  theme_minimal()
print(p1)
ggsave("output/figures/life_expectancy_trend.png", p1,
       width = 9, height = 6, dpi = 160)

# ---- 3. GDP per capita vs life expectancy -------------------------------
p2 <- ggplot(gap, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point(alpha = 0.55) +
  scale_x_log10(labels = comma) +
  labs(title = "GDP per Capita and Life Expectancy",
       x = "GDP per capita (log scale)",
       y = "Life expectancy (years)") +
  theme_minimal()
print(p2)
ggsave("output/figures/gdp_vs_life_expectancy.png", p2,
       width = 9, height = 6, dpi = 160)

# ---- 4. 2007 life expectancy by continent -------------------------------
d2007 <- gap %>% filter(year == 2007)
continent_2007 <- d2007 %>%
  group_by(continent) %>%
  summarise(lifeExp = mean(lifeExp), .groups = "drop")

p3 <- ggplot(continent_2007,
             aes(x = reorder(continent, lifeExp), y = lifeExp)) +
  geom_col() +
  coord_flip() +
  labs(title = "Average Life Expectancy by Continent, 2007",
       x = NULL, y = "Life expectancy (years)") +
  theme_minimal()
print(p3)
ggsave("output/figures/life_expectancy_2007.png", p3,
       width = 8, height = 5, dpi = 160)

# ---- 5. Distribution of life expectancy in 2007 --------------------------
p4 <- ggplot(d2007, aes(x = lifeExp)) +
  geom_histogram(bins = 14) +
  geom_vline(aes(xintercept = mean(lifeExp)), linetype = "dashed") +
  geom_vline(aes(xintercept = median(lifeExp)), linetype = "dotted") +
  labs(title = "Distribution of Life Expectancy Across Countries (2007)",
       x = "Life expectancy (years)", y = "Number of countries") +
  theme_minimal()
print(p4)
ggsave("output/figures/life_expectancy_distribution.png", p4,
       width = 8, height = 5, dpi = 160)

# ---- 6. Population growth of five most populous countries ----------------
top5 <- d2007 %>% slice_max(pop, n = 5) %>% pull(country)
top5_data <- gap %>% filter(country %in% top5)

p5 <- ggplot(top5_data, aes(x = year, y = pop / 1e6, color = country)) +
  geom_line(linewidth = 1) +
  geom_point(size = 1.5) +
  labs(title = "Population Growth: Five Most Populous Countries",
       x = "Year", y = "Population (millions)", color = "Country") +
  theme_minimal()
print(p5)
ggsave("output/figures/top5_population_growth.png", p5,
       width = 9, height = 6, dpi = 160)

# ---- 7. Life expectancy distribution by continent -----------------------
p6 <- ggplot(d2007, aes(x = continent, y = lifeExp)) +
  geom_boxplot() +
  labs(title = "Life Expectancy Distribution by Continent, 2007",
       x = "Continent", y = "Life expectancy (years)") +
  theme_minimal()
print(p6)
ggsave("output/figures/life_expectancy_by_continent.png", p6,
       width = 8, height = 5, dpi = 160)

# ---- 8. Reproducible summaries -------------------------------------------
global_trend <- gap %>%
  group_by(year) %>%
  summarise(global_lifeExp = mean(lifeExp), .groups = "drop")

continent_summary <- d2007 %>%
  group_by(continent) %>%
  summarise(mean_lifeExp = mean(lifeExp), .groups = "drop")

write.csv(global_trend, "output/global_life_expectancy_by_year.csv", row.names = FALSE)
write.csv(continent_summary, "output/life_expectancy_by_continent_2007.csv", row.names = FALSE)

print(global_trend)
print(continent_summary)
print(cor(gap$gdpPercap, gap$lifeExp))
