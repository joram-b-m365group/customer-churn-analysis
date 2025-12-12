# ============================================================================
# Customer Churn Analysis - Predictive Modeling
# ============================================================================
# This script builds and evaluates multiple machine learning models to
# predict customer churn
# ============================================================================

# Load required libraries
suppressPackageStartupMessages({
  library(tidyverse)
  library(caret)
  library(randomForest)
  library(pROC)
  library(glmnet)
  library(MASS)
})

set.seed(42)

cat("Starting predictive modeling pipeline...\n\n")

# Load data
data <- read_csv("../data/customer_churn_clean.csv", show_col_types = FALSE)

# ============================================================================
# 1. Feature Engineering & Preparation
# ============================================================================

cat("--- Preparing features for modeling ---\n")

# Create model dataset
model_data <- data %>%
  mutate(
    # Create binary/numeric features
    is_month_to_month = as.numeric(contract_type == "Month-to-month"),
    is_one_year = as.numeric(contract_type == "One year"),
    is_two_year = as.numeric(contract_type == "Two year"),
    has_fiber = as.numeric(internet_service == "Fiber optic"),
    has_dsl = as.numeric(internet_service == "DSL"),
    no_internet = as.numeric(internet_service == "No"),
    has_online_security = as.numeric(online_security == "Yes"),
    has_tech_support = as.numeric(tech_support == "Yes"),
    has_streaming = as.numeric(streaming_tv == "Yes"),
    uses_electronic_check = as.numeric(payment_method == "Electronic check"),
    paperless = as.numeric(paperless_billing == "Yes"),
    is_female = as.numeric(gender == "Female"),

    # Interaction features
    charge_tenure_ratio = monthly_charges / (tenure_months + 1),
    high_value_customer = as.numeric(total_charges > quantile(total_charges, 0.75)),
    low_satisfaction_high_tickets = as.numeric(customer_satisfaction < 3 & support_tickets > 2)
  ) %>%
  select(
    churn,
    age, tenure_months, monthly_charges, total_charges,
    support_tickets, customer_satisfaction,
    is_month_to_month, is_one_year, is_two_year,
    has_fiber, has_dsl, no_internet,
    has_online_security, has_tech_support, has_streaming,
    uses_electronic_check, paperless, is_female,
    charge_tenure_ratio, high_value_customer, low_satisfaction_high_tickets
  ) %>%
  drop_na()

cat(sprintf("Features prepared: %d variables\n", ncol(model_data) - 1))
cat(sprintf("Samples: %d\n\n", nrow(model_data)))

# ============================================================================
# 2. Train-Test Split
# ============================================================================

cat("--- Splitting data into train and test sets ---\n")

train_index <- createDataPartition(model_data$churn, p = 0.75, list = FALSE)
train_data <- model_data[train_index, ]
test_data <- model_data[-train_index, ]

cat(sprintf("Training set: %d samples (%.1f%%)\n",
            nrow(train_data), nrow(train_data)/nrow(model_data)*100))
cat(sprintf("Test set: %d samples (%.1f%%)\n\n",
            nrow(test_data), nrow(test_data)/nrow(model_data)*100))

# ============================================================================
# 3. Model 1: Logistic Regression
# ============================================================================

cat("--- Training Logistic Regression Model ---\n")

logit_model <- glm(churn ~ ., data = train_data, family = binomial(link = "logit"))

# Predictions
logit_pred_prob <- predict(logit_model, test_data, type = "response")
logit_pred_class <- factor(ifelse(logit_pred_prob > 0.5, "Yes", "No"), levels = c("No", "Yes"))

# Evaluation
logit_cm <- confusionMatrix(logit_pred_class, test_data$churn, positive = "Yes")
logit_roc <- roc(test_data$churn, logit_pred_prob)

cat(sprintf("Logistic Regression Performance:\n"))
cat(sprintf("  Accuracy: %.3f\n", logit_cm$overall['Accuracy']))
cat(sprintf("  Precision: %.3f\n", logit_cm$byClass['Precision']))
cat(sprintf("  Recall: %.3f\n", logit_cm$byClass['Recall']))
cat(sprintf("  F1-Score: %.3f\n", logit_cm$byClass['F1']))
cat(sprintf("  AUC: %.3f\n\n", auc(logit_roc)))

# ============================================================================
# 4. Model 2: Random Forest
# ============================================================================

cat("--- Training Random Forest Model ---\n")

rf_model <- randomForest(churn ~ ., data = train_data,
                        ntree = 500,
                        mtry = sqrt(ncol(train_data) - 1),
                        importance = TRUE)

# Predictions
rf_pred_class <- predict(rf_model, test_data, type = "class")
rf_pred_prob <- predict(rf_model, test_data, type = "prob")[, "Yes"]

# Evaluation
rf_cm <- confusionMatrix(rf_pred_class, test_data$churn, positive = "Yes")
rf_roc <- roc(test_data$churn, rf_pred_prob)

cat(sprintf("Random Forest Performance:\n"))
cat(sprintf("  Accuracy: %.3f\n", rf_cm$overall['Accuracy']))
cat(sprintf("  Precision: %.3f\n", rf_cm$byClass['Precision']))
cat(sprintf("  Recall: %.3f\n", rf_cm$byClass['Recall']))
cat(sprintf("  F1-Score: %.3f\n", rf_cm$byClass['F1']))
cat(sprintf("  AUC: %.3f\n\n", auc(rf_roc)))

# ============================================================================
# 5. Model 3: Regularized Logistic Regression (LASSO)
# ============================================================================

cat("--- Training LASSO Model ---\n")

# Prepare matrix format
x_train <- model.matrix(churn ~ ., train_data)[, -1]
y_train <- as.numeric(train_data$churn == "Yes")
x_test <- model.matrix(churn ~ ., test_data)[, -1]

# Cross-validation to find optimal lambda
cv_lasso <- cv.glmnet(x_train, y_train, family = "binomial", alpha = 1)
lasso_model <- glmnet(x_train, y_train, family = "binomial",
                     alpha = 1, lambda = cv_lasso$lambda.min)

# Predictions
lasso_pred_prob <- predict(lasso_model, x_test, type = "response")[, 1]
lasso_pred_class <- factor(ifelse(lasso_pred_prob > 0.5, "Yes", "No"), levels = c("No", "Yes"))

# Evaluation
lasso_cm <- confusionMatrix(lasso_pred_class, test_data$churn, positive = "Yes")
lasso_roc <- roc(test_data$churn, lasso_pred_prob)

cat(sprintf("LASSO Performance:\n"))
cat(sprintf("  Accuracy: %.3f\n", lasso_cm$overall['Accuracy']))
cat(sprintf("  Precision: %.3f\n", lasso_cm$byClass['Precision']))
cat(sprintf("  Recall: %.3f\n", lasso_cm$byClass['Recall']))
cat(sprintf("  F1-Score: %.3f\n", lasso_cm$byClass['F1']))
cat(sprintf("  AUC: %.3f\n\n", auc(lasso_roc)))

# ============================================================================
# 6. Feature Importance Analysis
# ============================================================================

cat("--- Analyzing Feature Importance ---\n")

# Random Forest feature importance
importance_df <- data.frame(
  feature = rownames(importance(rf_model)),
  importance = importance(rf_model)[, "MeanDecreaseGini"]
) %>%
  arrange(desc(importance)) %>%
  head(15)

cat("\nTop 15 Most Important Features (Random Forest):\n")
print(importance_df)

# Save feature importance plot
png("../outputs/feature_importance.png", width = 1000, height = 800, res = 100)
par(mar = c(5, 10, 4, 2))
barplot(rev(importance_df$importance[1:15]),
        names.arg = rev(importance_df$feature[1:15]),
        horiz = TRUE, las = 1, col = "#3498DB",
        main = "Top 15 Feature Importance (Random Forest)",
        xlab = "Mean Decrease in Gini Impurity")
dev.off()

cat("✓ Feature importance plot saved\n")

# ============================================================================
# 7. ROC Curve Comparison
# ============================================================================

cat("\n--- Creating ROC Curve Comparison ---\n")

png("../outputs/roc_curves.png", width = 1000, height = 800, res = 100)
par(mar = c(5, 5, 4, 2))

plot(logit_roc, col = "#E74C3C", lwd = 2,
     main = "ROC Curve Comparison - Churn Prediction Models",
     cex.main = 1.3, cex.lab = 1.1)
plot(rf_roc, col = "#2ECC71", lwd = 2, add = TRUE)
plot(lasso_roc, col = "#3498DB", lwd = 2, add = TRUE)

legend("bottomright",
       legend = c(
         sprintf("Logistic Regression (AUC = %.3f)", auc(logit_roc)),
         sprintf("Random Forest (AUC = %.3f)", auc(rf_roc)),
         sprintf("LASSO (AUC = %.3f)", auc(lasso_roc))
       ),
       col = c("#E74C3C", "#2ECC71", "#3498DB"),
       lwd = 2, cex = 1.1)

dev.off()

cat("✓ ROC curves saved\n")

# ============================================================================
# 8. Model Comparison Summary
# ============================================================================

cat("\n--- Model Comparison Summary ---\n")

model_comparison <- data.frame(
  Model = c("Logistic Regression", "Random Forest", "LASSO"),
  Accuracy = c(logit_cm$overall['Accuracy'],
               rf_cm$overall['Accuracy'],
               lasso_cm$overall['Accuracy']),
  Precision = c(logit_cm$byClass['Precision'],
                rf_cm$byClass['Precision'],
                lasso_cm$byClass['Precision']),
  Recall = c(logit_cm$byClass['Recall'],
             rf_cm$byClass['Recall'],
             lasso_cm$byClass['Recall']),
  F1_Score = c(logit_cm$byClass['F1'],
               rf_cm$byClass['F1'],
               lasso_cm$byClass['F1']),
  AUC = c(auc(logit_roc), auc(rf_roc), auc(lasso_roc))
) %>%
  mutate(across(where(is.numeric), ~round(., 4)))

print(model_comparison)

write_csv(model_comparison, "../outputs/model_comparison.csv")
cat("\n✓ Model comparison saved to ../outputs/model_comparison.csv\n")

# ============================================================================
# 9. Save Best Model
# ============================================================================

cat("\n--- Saving Best Model ---\n")

# Determine best model by AUC
best_model_idx <- which.max(model_comparison$AUC)
best_model_name <- model_comparison$Model[best_model_idx]

cat(sprintf("Best performing model: %s (AUC = %.4f)\n",
            best_model_name, max(model_comparison$AUC)))

# Save the Random Forest model (typically best performer)
saveRDS(rf_model, "../models/random_forest_churn_model.rds")
cat("✓ Random Forest model saved to ../models/random_forest_churn_model.rds\n")

# Save model metadata
model_metadata <- list(
  trained_date = Sys.Date(),
  model_type = "Random Forest",
  n_features = ncol(train_data) - 1,
  n_training_samples = nrow(train_data),
  n_test_samples = nrow(test_data),
  performance = model_comparison[model_comparison$Model == "Random Forest", ],
  feature_importance = importance_df
)

saveRDS(model_metadata, "../models/model_metadata.rds")
cat("✓ Model metadata saved\n")

cat("\n=== MODELING COMPLETE ===\n")
cat("All models trained and evaluated successfully!\n")
