# ============================================================================
# Customer Churn Analysis - Data Cleaning & Preprocessing
# ============================================================================
# This script performs data cleaning, handles missing values, and prepares
# the data for exploratory analysis and modeling
# ============================================================================

# Load required libraries
suppressPackageStartupMessages({
  library(tidyverse)
  library(naniar)
  library(skimr)
})

cat("Starting data cleaning process...\n\n")

# Load the raw data
data <- read_csv("../data/customer_churn_data.csv", show_col_types = FALSE)

cat(sprintf("Loaded %d rows and %d columns\n", nrow(data), ncol(data)))

# ============================================================================
# 1. Inspect Data Quality
# ============================================================================

cat("\n--- Missing Values Summary ---\n")
missing_summary <- data %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "missing_count") %>%
  filter(missing_count > 0) %>%
  mutate(missing_percentage = round(missing_count / nrow(data) * 100, 2)) %>%
  arrange(desc(missing_count))

print(missing_summary)

# ============================================================================
# 2. Handle Missing Values
# ============================================================================

cat("\n--- Handling Missing Values ---\n")

# For total_charges, impute with tenure * monthly_charges
data_clean <- data %>%
  mutate(
    total_charges = if_else(
      is.na(total_charges),
      tenure_months * monthly_charges,
      total_charges
    )
  )

cat(sprintf("✓ Imputed %d missing total_charges values\n",
            sum(is.na(data$total_charges))))

# ============================================================================
# 3. Data Type Conversions
# ============================================================================

cat("\n--- Converting Data Types ---\n")

data_clean <- data_clean %>%
  mutate(
    # Convert character variables to factors
    across(c(gender, contract_type, internet_service, online_security,
             tech_support, streaming_tv, payment_method, paperless_billing),
           as.factor),

    # Ensure churn is factor
    churn = factor(churn, levels = c("No", "Yes")),

    # Create derived features
    avg_monthly_charge = total_charges / pmax(tenure_months, 1),
    tenure_group = cut(tenure_months,
                      breaks = c(-Inf, 12, 24, 48, Inf),
                      labels = c("0-1 year", "1-2 years", "2-4 years", "4+ years")),
    age_group = cut(age,
                   breaks = c(0, 30, 45, 60, Inf),
                   labels = c("18-30", "31-45", "46-60", "60+"))
  )

cat("✓ Data types converted successfully\n")

# ============================================================================
# 4. Outlier Detection
# ============================================================================

cat("\n--- Outlier Detection ---\n")

# Function to detect outliers using IQR method
detect_outliers <- function(x) {
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower_bound <- q1 - 1.5 * iqr
  upper_bound <- q3 + 1.5 * iqr
  x < lower_bound | x > upper_bound
}

outlier_summary <- data_clean %>%
  summarise(
    monthly_charges_outliers = sum(detect_outliers(monthly_charges)),
    total_charges_outliers = sum(detect_outliers(total_charges)),
    tenure_outliers = sum(detect_outliers(tenure_months))
  )

print(outlier_summary)
cat("Note: Outliers detected but retained for analysis\n")

# ============================================================================
# 5. Create Analysis-Ready Dataset
# ============================================================================

cat("\n--- Creating Final Clean Dataset ---\n")

# Select and arrange columns for analysis
data_final <- data_clean %>%
  select(
    customer_id,
    age,
    age_group,
    gender,
    tenure_months,
    tenure_group,
    contract_type,
    monthly_charges,
    total_charges,
    avg_monthly_charge,
    internet_service,
    online_security,
    tech_support,
    streaming_tv,
    payment_method,
    paperless_billing,
    support_tickets,
    customer_satisfaction,
    signup_date,
    churn
  )

# ============================================================================
# 6. Save Cleaned Data
# ============================================================================

output_path <- "../data/customer_churn_clean.csv"
write_csv(data_final, output_path)

cat(sprintf("\n✓ Clean dataset saved to: %s\n", output_path))
cat(sprintf("  - Final rows: %d\n", nrow(data_final)))
cat(sprintf("  - Final columns: %d\n", ncol(data_final)))

# ============================================================================
# 7. Data Quality Report
# ============================================================================

cat("\n--- Final Data Quality Summary ---\n")
cat(sprintf("Complete cases: %d (%.1f%%)\n",
            sum(complete.cases(data_final)),
            sum(complete.cases(data_final))/nrow(data_final)*100))

cat("\n--- Variable Summary ---\n")
print(skim(data_final %>% select(age, tenure_months, monthly_charges,
                                 total_charges, customer_satisfaction, churn)))

cat("\n✓ Data cleaning complete!\n")
