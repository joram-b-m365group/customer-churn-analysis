# ============================================================================
# Customer Churn Analysis - Advanced Visualizations
# ============================================================================
# This script creates comprehensive visualizations for the churn analysis
# ============================================================================

# Load required libraries
suppressPackageStartupMessages({
  library(tidyverse)
  library(ggplot2)
  library(gridExtra)
  library(scales)
  library(viridis)
  library(ggthemes)
})

# Set theme
theme_set(theme_minimal(base_size = 12))

# Color palettes
churn_colors <- c("No" = "#2ECC71", "Yes" = "#E74C3C")

cat("Creating visualizations...\n\n")

# Load data
data <- read_csv("../data/customer_churn_clean.csv", show_col_types = FALSE)

# ============================================================================
# 1. Churn Distribution
# ============================================================================

cat("Creating churn distribution plot...\n")

p1 <- ggplot(data, aes(x = churn, fill = churn)) +
  geom_bar(alpha = 0.8) +
  geom_text(stat = "count", aes(label = paste0(after_stat(count), "\n",
                                                round(after_stat(count)/nrow(data)*100, 1), "%")),
            vjust = -0.5, size = 4, fontface = "bold") +
  scale_fill_manual(values = churn_colors) +
  labs(title = "Customer Churn Distribution",
       subtitle = sprintf("Total Customers: %d", nrow(data)),
       x = "Churn Status", y = "Number of Customers") +
  theme(legend.position = "none") +
  ylim(0, max(table(data$churn)) * 1.15)

ggsave("../outputs/01_churn_distribution.png", p1, width = 8, height = 6, dpi = 300)

# ============================================================================
# 2. Churn by Contract Type
# ============================================================================

cat("Creating contract type analysis plot...\n")

p2 <- data %>%
  count(contract_type, churn) %>%
  group_by(contract_type) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  ggplot(aes(x = contract_type, y = percentage, fill = churn)) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  geom_text(aes(label = sprintf("%.1f%%", percentage)),
            position = position_dodge(width = 0.9), vjust = -0.5, size = 3.5) +
  scale_fill_manual(values = churn_colors, name = "Churn") +
  labs(title = "Churn Rate by Contract Type",
       subtitle = "Month-to-month contracts show highest churn",
       x = "Contract Type", y = "Percentage (%)") +
  theme(legend.position = "top")

ggsave("../outputs/02_churn_by_contract.png", p2, width = 10, height = 6, dpi = 300)

# ============================================================================
# 3. Tenure Distribution by Churn
# ============================================================================

cat("Creating tenure analysis plot...\n")

p3 <- ggplot(data, aes(x = tenure_months, fill = churn)) +
  geom_histogram(bins = 30, alpha = 0.7, position = "identity") +
  scale_fill_manual(values = churn_colors, name = "Churn") +
  labs(title = "Customer Tenure Distribution by Churn Status",
       subtitle = "Churned customers tend to have shorter tenure",
       x = "Tenure (months)", y = "Number of Customers") +
  theme(legend.position = "top") +
  facet_wrap(~churn, ncol = 1, scales = "free_y")

ggsave("../outputs/03_tenure_distribution.png", p3, width = 10, height = 8, dpi = 300)

# ============================================================================
# 4. Monthly Charges vs Churn
# ============================================================================

cat("Creating monthly charges analysis plot...\n")

p4 <- ggplot(data, aes(x = churn, y = monthly_charges, fill = churn)) +
  geom_boxplot(alpha = 0.7, outlier.alpha = 0.3) +
  geom_violin(alpha = 0.3) +
  scale_fill_manual(values = churn_colors) +
  labs(title = "Monthly Charges Distribution by Churn Status",
       subtitle = "Higher charges associated with increased churn",
       x = "Churn Status", y = "Monthly Charges ($)") +
  theme(legend.position = "none") +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3,
               fill = "white", color = "black")

ggsave("../outputs/04_monthly_charges_churn.png", p4, width = 8, height = 6, dpi = 300)

# ============================================================================
# 5. Multi-factor Analysis
# ============================================================================

cat("Creating multi-factor analysis plot...\n")

p5 <- data %>%
  count(tenure_group, contract_type, churn) %>%
  group_by(tenure_group, contract_type) %>%
  mutate(churn_rate = n[churn == "Yes"] / sum(n) * 100) %>%
  filter(churn == "Yes") %>%
  ggplot(aes(x = tenure_group, y = churn_rate, fill = contract_type)) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  geom_text(aes(label = sprintf("%.1f%%", churn_rate)),
            position = position_dodge(width = 0.9), vjust = -0.5, size = 3) +
  scale_fill_brewer(palette = "Set2", name = "Contract Type") +
  labs(title = "Churn Rate by Tenure and Contract Type",
       subtitle = "Combined effect of tenure and contract on churn",
       x = "Tenure Group", y = "Churn Rate (%)") +
  theme(legend.position = "top", axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("../outputs/05_tenure_contract_interaction.png", p5, width = 10, height = 6, dpi = 300)

# ============================================================================
# 6. Customer Satisfaction Impact
# ============================================================================

cat("Creating satisfaction analysis plot...\n")

p6 <- data %>%
  mutate(satisfaction_group = cut(customer_satisfaction,
                                 breaks = c(0, 2, 3, 4, 5),
                                 labels = c("Poor (1-2)", "Fair (2-3)",
                                          "Good (3-4)", "Excellent (4-5)"))) %>%
  count(satisfaction_group, churn) %>%
  group_by(satisfaction_group) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  ggplot(aes(x = satisfaction_group, y = percentage, fill = churn)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = sprintf("%.1f%%", percentage)),
            position = position_stack(vjust = 0.5), size = 3.5, color = "white",
            fontface = "bold") +
  scale_fill_manual(values = churn_colors, name = "Churn") +
  labs(title = "Churn Rate by Customer Satisfaction Level",
       subtitle = "Lower satisfaction strongly correlates with churn",
       x = "Satisfaction Level", y = "Percentage (%)") +
  theme(legend.position = "top", axis.text.x = element_text(angle = 15, hjust = 1))

ggsave("../outputs/06_satisfaction_churn.png", p6, width = 10, height = 6, dpi = 300)

# ============================================================================
# 7. Payment Method Analysis
# ============================================================================

cat("Creating payment method analysis plot...\n")

p7 <- data %>%
  count(payment_method, churn) %>%
  group_by(payment_method) %>%
  mutate(churn_rate = n[churn == "Yes"] / sum(n) * 100) %>%
  filter(churn == "Yes") %>%
  ggplot(aes(x = reorder(payment_method, churn_rate), y = churn_rate, fill = churn_rate)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = sprintf("%.1f%%", churn_rate)), hjust = -0.2, size = 4) +
  scale_fill_gradient(low = "#3498DB", high = "#E74C3C", name = "Churn Rate (%)") +
  coord_flip() +
  labs(title = "Churn Rate by Payment Method",
       subtitle = "Electronic check users show highest churn tendency",
       x = "Payment Method", y = "Churn Rate (%)") +
  theme(legend.position = "right") +
  ylim(0, max(data %>% count(payment_method, churn) %>%
              group_by(payment_method) %>%
              mutate(churn_rate = n[churn == "Yes"] / sum(n) * 100) %>%
              filter(churn == "Yes") %>% pull(churn_rate)) * 1.15)

ggsave("../outputs/07_payment_method_churn.png", p7, width = 10, height = 6, dpi = 300)

# ============================================================================
# 8. Support Tickets Impact
# ============================================================================

cat("Creating support tickets analysis plot...\n")

p8 <- data %>%
  group_by(support_tickets, churn) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(support_tickets) %>%
  mutate(churn_rate = count[churn == "Yes"] / sum(count) * 100) %>%
  filter(churn == "Yes", support_tickets <= 10) %>%
  ggplot(aes(x = support_tickets, y = churn_rate)) +
  geom_line(color = "#E74C3C", size = 1.2) +
  geom_point(color = "#E74C3C", size = 3) +
  geom_smooth(method = "loess", se = TRUE, alpha = 0.2, color = "#3498DB") +
  labs(title = "Churn Rate by Number of Support Tickets",
       subtitle = "More support tickets indicate higher churn risk",
       x = "Number of Support Tickets", y = "Churn Rate (%)") +
  scale_x_continuous(breaks = 0:10)

ggsave("../outputs/08_support_tickets_churn.png", p8, width = 10, height = 6, dpi = 300)

# ============================================================================
# 9. Comprehensive Dashboard
# ============================================================================

cat("Creating comprehensive dashboard...\n")

# Create mini plots for dashboard
d1 <- ggplot(data, aes(x = churn, fill = churn)) +
  geom_bar(alpha = 0.8) +
  scale_fill_manual(values = churn_colors) +
  labs(title = "Overall Churn", x = NULL, y = "Count") +
  theme_minimal(base_size = 10) +
  theme(legend.position = "none")

d2 <- data %>%
  count(contract_type, churn) %>%
  group_by(contract_type) %>%
  mutate(pct = n/sum(n)) %>%
  filter(churn == "Yes") %>%
  ggplot(aes(x = contract_type, y = pct, fill = contract_type)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  scale_y_continuous(labels = percent) +
  labs(title = "Churn by Contract", x = NULL, y = "Churn Rate") +
  theme_minimal(base_size = 10) +
  theme(legend.position = "none", axis.text.x = element_text(angle = 45, hjust = 1))

d3 <- ggplot(data, aes(x = tenure_months, fill = churn)) +
  geom_density(alpha = 0.6) +
  scale_fill_manual(values = churn_colors) +
  labs(title = "Tenure Distribution", x = "Months", y = "Density") +
  theme_minimal(base_size = 10) +
  theme(legend.position = "bottom")

d4 <- ggplot(data, aes(x = churn, y = monthly_charges, fill = churn)) +
  geom_boxplot(alpha = 0.8) +
  scale_fill_manual(values = churn_colors) +
  labs(title = "Charges by Churn", x = NULL, y = "Monthly ($)") +
  theme_minimal(base_size = 10) +
  theme(legend.position = "none")

dashboard <- grid.arrange(d1, d2, d3, d4, ncol = 2,
                         top = "Customer Churn Analysis Dashboard")

ggsave("../outputs/09_dashboard.png", dashboard, width = 12, height = 10, dpi = 300)

cat("\n✓ All visualizations created successfully!\n")
cat(sprintf("  Total plots saved: 9\n"))
cat(sprintf("  Output directory: ../outputs/\n"))
