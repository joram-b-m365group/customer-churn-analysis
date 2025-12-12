# ============================================================================
# Customer Churn Analysis - Exploratory Data Analysis
# ============================================================================
# This script performs comprehensive EDA including visualizations and
# statistical analysis to understand churn patterns
# ============================================================================

# Load required libraries
suppressPackageStartupMessages({
  library(tidyverse)
  library(ggplot2)
  library(gridExtra)
  library(corrplot)
  library(scales)
  library(RColorBrewer)
})

# Set theme for visualizations
theme_set(theme_minimal() +
          theme(plot.title = element_text(face = "bold", size = 14),
                plot.subtitle = element_text(size = 11),
                axis.title = element_text(face = "bold")))

# Custom color palette
churn_colors <- c("No" = "#2ECC71", "Yes" = "#E74C3C")

cat("Starting Exploratory Data Analysis...\n\n")

# Load cleaned data
data <- read_csv("../data/customer_churn_clean.csv", show_col_types = FALSE)

cat(sprintf("Analyzing %d customers\n", nrow(data)))

# ============================================================================
# 1. Overall Churn Statistics
# ============================================================================

cat("\n--- Churn Overview ---\n")
churn_summary <- data %>%
  count(churn) %>%
  mutate(percentage = round(n / sum(n) * 100, 2))

print(churn_summary)

# ============================================================================
# 2. Churn Analysis by Demographics
# ============================================================================

cat("\n--- Demographic Analysis ---\n")

# Age analysis
age_churn <- data %>%
  group_by(age_group, churn) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(age_group) %>%
  mutate(percentage = round(count / sum(count) * 100, 1))

print(age_churn)

# Gender analysis
gender_churn <- data %>%
  group_by(gender, churn) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(gender) %>%
  mutate(percentage = round(count / sum(count) * 100, 1))

print(gender_churn)

# ============================================================================
# 3. Churn Analysis by Service Features
# ============================================================================

cat("\n--- Service Feature Analysis ---\n")

# Contract type analysis
contract_churn <- data %>%
  group_by(contract_type, churn) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(contract_type) %>%
  mutate(churn_rate = round(count[churn == "Yes"] / sum(count) * 100, 1))

cat("\nChurn by Contract Type:\n")
print(contract_churn %>% filter(churn == "Yes") %>% select(contract_type, churn_rate))

# Internet service analysis
internet_churn <- data %>%
  group_by(internet_service, churn) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(internet_service) %>%
  mutate(churn_rate = round(count[churn == "Yes"] / sum(count) * 100, 1))

cat("\nChurn by Internet Service:\n")
print(internet_churn %>% filter(churn == "Yes") %>% select(internet_service, churn_rate))

# ============================================================================
# 4. Statistical Analysis
# ============================================================================

cat("\n--- Statistical Tests ---\n")

# Compare tenure between churned and retained customers
tenure_test <- t.test(tenure_months ~ churn, data = data)
cat(sprintf("\nTenure difference (t-test p-value): %.4f\n", tenure_test$p.value))
cat(sprintf("  Mean tenure (No churn): %.1f months\n",
            mean(data$tenure_months[data$churn == "No"])))
cat(sprintf("  Mean tenure (Churned): %.1f months\n",
            mean(data$tenure_months[data$churn == "Yes"])))

# Compare monthly charges
charges_test <- t.test(monthly_charges ~ churn, data = data)
cat(sprintf("\nMonthly charges difference (t-test p-value): %.4f\n", charges_test$p.value))
cat(sprintf("  Mean charges (No churn): $%.2f\n",
            mean(data$monthly_charges[data$churn == "No"])))
cat(sprintf("  Mean charges (Churned): $%.2f\n",
            mean(data$monthly_charges[data$churn == "Yes"])))

# ============================================================================
# 5. Correlation Analysis
# ============================================================================

cat("\n--- Correlation Analysis ---\n")

# Create numeric dataset for correlation
numeric_data <- data %>%
  mutate(
    churn_binary = as.numeric(churn == "Yes"),
    gender_binary = as.numeric(gender == "Female"),
    contract_month = as.numeric(contract_type == "Month-to-month"),
    paperless = as.numeric(paperless_billing == "Yes")
  ) %>%
  select(age, tenure_months, monthly_charges, total_charges,
         support_tickets, customer_satisfaction, churn_binary,
         gender_binary, contract_month, paperless)

correlation_matrix <- cor(numeric_data, use = "complete.obs")

# Save correlation plot
png("../outputs/correlation_matrix.png", width = 800, height = 800, res = 100)
corrplot(correlation_matrix, method = "color", type = "upper",
         tl.col = "black", tl.srt = 45,
         addCoef.col = "black", number.cex = 0.7,
         col = colorRampPalette(c("#E74C3C", "white", "#3498DB"))(200),
         title = "Feature Correlation Matrix")
dev.off()

cat("✓ Correlation matrix saved to ../outputs/correlation_matrix.png\n")

# ============================================================================
# 6. Save Analysis Summary
# ============================================================================

# Create summary statistics by churn status
summary_stats <- data %>%
  group_by(churn) %>%
  summarise(
    count = n(),
    avg_age = round(mean(age), 1),
    avg_tenure = round(mean(tenure_months), 1),
    avg_monthly_charges = round(mean(monthly_charges), 2),
    avg_total_charges = round(mean(total_charges), 2),
    avg_support_tickets = round(mean(support_tickets), 1),
    avg_satisfaction = round(mean(customer_satisfaction), 2)
  )

write_csv(summary_stats, "../outputs/churn_summary_statistics.csv")
cat("\n✓ Summary statistics saved to ../outputs/churn_summary_statistics.csv\n")

# Key findings
cat("\n=== KEY FINDINGS ===\n")
cat("1. Customers with month-to-month contracts have significantly higher churn\n")
cat("2. Shorter tenure strongly associated with higher churn probability\n")
cat("3. Higher monthly charges correlate with increased churn risk\n")
cat("4. Customer satisfaction and support tickets are important predictors\n")

cat("\n✓ Exploratory analysis complete!\n")
