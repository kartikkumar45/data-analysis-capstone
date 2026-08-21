##############################################################################
# Phase II: Data Visualization and Insight Communication
# Dataset : Gapminder (Free, Bryan et al.), 1952-2007
# Author  : Kartik Kumar
##############################################################################
# ---- 0. Setup ----
library(tidyverse) # dplyr, ggplot2, tidyr
library(gapminder) # bundled Gapminder dataset (142 countries, 1952-2007)
library(scales) # log-scale axis labels
gap <- gapminder
str(gap)
dim(gap) # 1704 obs. of 6 variables
n_distinct(gap$country) # 142 countries
sort(unique(gap$year)) # 1952 ... 2007, every 5 years
# ---- 1. Data quality checks ----
sum(is.na(gap)) # 0 missing values
gap %>% count(country, year) %>% filter(n > 1) # duplicate check (none)
summary(gap[, c("lifeExp", "pop", "gdpPercap")])
# ---- 2. Figure 1: Life expectancy trend by continent ----
cont_year <- gap %>%
  group_by(continent, year) %>%
  summarise(lifeExp = mean(lifeExp), .groups = "drop")
ggplot(cont_year, aes(x = year, y = lifeExp, color = continent)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 1.6) +
  labs(title = "Average Life Expectancy by Continent, 1952-2007",
       x = "Year", y = "Life expectancy (years)", color = "Continent") +
  theme_minimal()
# ---- 3. Figure 2: GDP per capita vs life expectancy ----
ggplot(gap, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point(alpha = 0.55) +
  scale_x_log10(labels = comma) +
  labs(title = "GDP per Capita and Life Expectancy",
       x = "GDP per capita (log scale)", y = "Life expectancy (years)") +
  theme_minimal()
# ---- 4. Figure 3: 2007 life expectancy by continent ----
d2007 <- gap %>% filter(year == 2007)
continent_2007 <- d2007 %>%
  group_by(continent) %>%
  summarise(lifeExp = mean(lifeExp), .groups = "drop")
ggplot(continent_2007, aes(x = reorder(continent, lifeExp), y = lifeExp)) +
  geom_col() +
  coord_flip() +
  labs(title = "Average Life Expectancy by Continent, 2007",
       x = NULL, y = "Life expectancy (years)") +
  theme_minimal()
# ---- 5. Figure 4: Distribution of life expectancy in 2007 ----
ggplot(d2007, aes(x = lifeExp)) +
  geom_histogram(bins = 14) +
  geom_vline(aes(xintercept = mean(lifeExp)), linetype = "dashed") +
  geom_vline(aes(xintercept = median(lifeExp)), linetype = "dotted") +
  labs(title = "Distribution of Life Expectancy Across Countries (2007)",
       x = "Life expectancy (years)", y = "Number of countries") +
  theme_minimal()
# ---- 6. Figure 5: Population growth of five most populous countries ----
top5 <- d2007 %>% slice_max(pop, n = 5) %>% pull(country)
top5_data <- gap %>% filter(country %in% top5)
ggplot(top5_data, aes(x = year, y = pop / 1e6, color = country)) +
  geom_line(linewidth = 1) +
  geom_point(size = 1.5) +
  labs(title = "Population Growth: Five Most Populous Countries (1952-2007)",
       x = "Year", y = "Population (millions)", color = "Country") +
  theme_minimal()
# ---- 7. Figure 6: Life expectancy by continent ----
ggplot(d2007, aes(x = continent, y = lifeExp)) +
  geom_boxplot() +
  labs(title = "Life Expectancy Distribution by Continent, 2007",
       x = "Continent", y = "Life expectancy (years)") +
  theme_minimal()
# ---- 8. Key descriptive summaries ----
gap %>% group_by(year) %>% summarise(global_lifeExp = mean(lifeExp), .groups = "drop")
d2007 %>% group_by(continent) %>% summarise(mean_lifeExp = mean(lifeExp), .groups = "drop")
cor(gap$gdpPercap, gap$lifeExp)
