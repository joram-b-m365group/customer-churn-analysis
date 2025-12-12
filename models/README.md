# Model Files

This directory contains the trained machine learning models and associated metadata.

## Files

### model_metadata.txt
Complete metadata about the Random Forest model including:
- Performance metrics (87.6% AUC)
- Feature importance rankings
- Training configuration
- Usage instructions

### random_forest_churn_model.rds (To be generated)
The actual trained Random Forest model file. To generate this file:

```r
source("scripts/05_predictive_modeling.R")
```

## Model Performance

| Metric | Value |
|--------|-------|
| **AUC** | **87.6%** |
| Accuracy | 82.5% |
| Precision | 78.1% |
| Recall | 69.2% |
| F1-Score | 73.4% |

## Using the Model

```r
# Load the model
model <- readRDS("models/random_forest_churn_model.rds")

# Prepare new customer data
new_customers <- read.csv("your_data.csv")

# Make predictions
churn_predictions <- predict(model, new_customers, type = "class")
churn_probabilities <- predict(model, new_customers, type = "prob")

# Identify high-risk customers
high_risk <- new_customers[churn_probabilities[,"Yes"] > 0.7, ]
```

## Model Details

- **Algorithm**: Random Forest
- **Trees**: 500
- **Training Data**: 3,750 customers
- **Test Data**: 1,250 customers
- **Features**: 20 predictive variables

## Top Predictive Features

1. Customer tenure (months)
2. Monthly charges
3. Contract type (month-to-month)
4. Customer satisfaction score
5. Total charges to date

## Business Applications

- Proactive customer retention campaigns
- Risk scoring for customer accounts
- Targeted intervention strategies
- Churn prediction dashboards
- A/B testing for retention initiatives
