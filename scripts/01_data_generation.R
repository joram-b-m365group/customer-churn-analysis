# ============================================================================
# Customer Churn Analysis - Data Generation Script
# ============================================================================
# This script generates a synthetic customer dataset for churn analysis
# Author: Data Science Portfolio Project
# Date: 2025-12-12
# ============================================================================

# Load required libraries
suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
})

# Set seed for reproducibility
set.seed(42)

# Generate synthetic customer data
n_customers <- 5000

# Helper function to generate correlated binary outcome
generate_churn <- function(tenure, monthly_charges, contract, support_tickets, satisfaction) {
  # Churn probability based on multiple factors
  logit <- -2 +
    (-0.05 * tenure) +
    (0.02 * monthly_charges) +
    (contract == "Month-to-month") * 1.5 +
    (contract == "One year") * 0.5 +
    (0.3 * support_tickets) +
    (-0.8 * satisfaction)

  prob <- 1 / (1 + exp(-logit))
  rbinom(length(tenure), 1, prob)
}

cat("Generating customer data...\n")

customer_data <- tibble(
  customer_id = paste0("CUST", str_pad(1:n_customers, 5, pad = "0")),
  age = round(rnorm(n_customers, mean = 45, sd = 15)),
  gender = sample(c("Male", "Female", "Other"), n_customers, replace = TRUE, prob = c(0.48, 0.48, 0.04)),
  tenure_months = round(rexp(n_customers, rate = 1/24)),
  contract_type = sample(c("Month-to-month", "One year", "Two year"), n_customers,
                         replace = TRUE, prob = c(0.5, 0.3, 0.2)),
  monthly_charges = round(runif(n_customers, min = 20, max = 120), 2),
  total_charges = NA,  # Will calculate based on tenure and monthly
  internet_service = sample(c("DSL", "Fiber optic", "No"), n_customers,
                           replace = TRUE, prob = c(0.3, 0.5, 0.2)),
  online_security = sample(c("Yes", "No", "No internet service"), n_customers, replace = TRUE),
  tech_support = sample(c("Yes", "No", "No internet service"), n_customers, replace = TRUE),
  streaming_tv = sample(c("Yes", "No", "No internet service"), n_customers, replace = TRUE),
  payment_method = sample(c("Electronic check", "Mailed check", "Bank transfer", "Credit card"),
                         n_customers, replace = TRUE, prob = c(0.35, 0.2, 0.25, 0.2)),
  paperless_billing = sample(c("Yes", "No"), n_customers, replace = TRUE, prob = c(0.6, 0.4)),
  support_tickets = rpois(n_customers, lambda = 2),
  customer_satisfaction = round(runif(n_customers, min = 1, max = 5), 1),
  signup_date = as.Date("2020-01-01") + days(sample(0:1460, n_customers, replace = TRUE))
) %>%
  mutate(
    # Calculate total charges
    total_charges = round(tenure_months * monthly_charges + rnorm(n_customers, 0, 50), 2),
    total_charges = ifelse(total_charges < 0, monthly_charges, total_charges),

    # Ensure age is reasonable
    age = pmin(pmax(age, 18), 90),

    # Ensure tenure is non-negative
    tenure_months = pmax(tenure_months, 0),

    # Generate churn based on multiple factors
    churn = generate_churn(tenure_months, monthly_charges, contract_type,
                          support_tickets, customer_satisfaction),
    churn = factor(ifelse(churn == 1, "Yes", "No"), levels = c("No", "Yes"))
  )

# Add some missing values to make it realistic
missing_indices <- sample(1:n_customers, size = n_customers * 0.02)
customer_data$total_charges[missing_indices] <- NA

# Save the dataset
output_path <- "../data/customer_churn_data.csv"
write_csv(customer_data, output_path)

cat(sprintf("\n✓ Dataset generated successfully!\n"))
cat(sprintf("  - Total customers: %d\n", n_customers))
cat(sprintf("  - Churn rate: %.2f%%\n", mean(customer_data$churn == "Yes") * 100))
cat(sprintf("  - Data saved to: %s\n", output_path))

# Display summary statistics
cat("\n--- Data Summary ---\n")
print(summary(customer_data %>% select(age, tenure_months, monthly_charges, churn)))

cat("\n--- Churn by Contract Type ---\n")
print(table(customer_data$contract_type, customer_data$churn))
