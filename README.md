# Customer Churn Prediction & Analysis

A comprehensive data science project implementing end-to-end customer churn analysis using R, featuring data preprocessing, exploratory data analysis, advanced visualizations, and machine learning models for churn prediction.

## Project Overview

Customer churn is a critical business metric that measures the rate at which customers discontinue their service. This project demonstrates a complete data science workflow to:

- Analyze customer behavior patterns
- Identify key churn indicators
- Build predictive models to forecast churn
- Provide actionable insights for customer retention

## Key Features

- **Synthetic Data Generation**: Realistic customer dataset with correlated features
- **Comprehensive EDA**: Statistical analysis and correlation studies
- **Advanced Visualizations**: 9+ professional-grade plots and dashboards
- **Multiple ML Models**: Logistic Regression, Random Forest, and LASSO
- **Model Comparison**: Performance metrics including AUC, precision, recall, and F1-score
- **Feature Importance Analysis**: Identify key drivers of customer churn

## Project Structure

```
customer-churn-analysis/
│
├── data/
│   ├── customer_churn_data.csv      # Raw generated dataset
│   └── customer_churn_clean.csv     # Cleaned dataset
│
├── scripts/
│   ├── 01_data_generation.R         # Generate synthetic customer data
│   ├── 02_data_cleaning.R           # Data preprocessing and cleaning
│   ├── 03_exploratory_analysis.R    # Statistical analysis and EDA
│   ├── 04_visualizations.R          # Create comprehensive visualizations
│   ├── 05_predictive_modeling.R     # Build and evaluate ML models
│   └── run_all.R                    # Execute complete pipeline
│
├── outputs/
│   ├── *.png                        # Visualization outputs
│   ├── correlation_matrix.png       # Feature correlation heatmap
│   ├── feature_importance.png       # Model feature importance
│   ├── roc_curves.png              # Model ROC comparison
│   └── model_comparison.csv         # Model performance metrics
│
├── models/
│   ├── random_forest_churn_model.rds  # Trained Random Forest model
│   └── model_metadata.rds             # Model training metadata
│
├── requirements.R                   # R package dependencies
└── README.md                        # Project documentation
```

## Installation & Setup

### Prerequisites

- R version 4.0 or higher
- RStudio (recommended)

### Install Required Packages

Run the following command in R to install all dependencies:

```r
source("requirements.R")
```

Or install packages manually:

```r
install.packages(c(
  "tidyverse", "ggplot2", "dplyr", "readr",
  "caret", "randomForest", "pROC", "glmnet", "MASS",
  "corrplot", "gridExtra", "scales", "viridis",
  "naniar", "skimr", "RColorBrewer", "ggthemes"
))
```

## Usage

### Quick Start - Run Complete Pipeline

Execute all scripts in sequence:

```r
source("scripts/run_all.R")
```

### Step-by-Step Execution

Run individual scripts for specific analyses:

```r
# 1. Generate synthetic customer data
source("scripts/01_data_generation.R")

# 2. Clean and preprocess data
source("scripts/02_data_cleaning.R")

# 3. Perform exploratory data analysis
source("scripts/03_exploratory_analysis.R")

# 4. Create visualizations
source("scripts/04_visualizations.R")

# 5. Build predictive models
source("scripts/05_predictive_modeling.R")
```

## Dataset Description

The dataset contains **5,000 customer records** with the following features:

### Customer Demographics
- `customer_id`: Unique identifier
- `age`: Customer age (18-90)
- `gender`: Male, Female, Other

### Service Information
- `tenure_months`: Length of service (months)
- `contract_type`: Month-to-month, One year, Two year
- `internet_service`: DSL, Fiber optic, No
- `online_security`: Yes, No, No internet service
- `tech_support`: Yes, No, No internet service
- `streaming_tv`: Yes, No, No internet service

### Billing Information
- `monthly_charges`: Monthly service charge ($20-$120)
- `total_charges`: Total charges to date
- `payment_method`: Electronic check, Mailed check, Bank transfer, Credit card
- `paperless_billing`: Yes, No

### Customer Experience
- `support_tickets`: Number of support requests
- `customer_satisfaction`: Rating (1-5 scale)

### Target Variable
- `churn`: Customer churned (Yes/No)

## Key Findings

### 1. Contract Type Impact
- **Month-to-month contracts** have the highest churn rate (~45%)
- **Two-year contracts** show significantly lower churn (~10%)
- Contract length is the strongest predictor of churn

### 2. Tenure Effect
- Customers with **< 12 months tenure** are at highest risk
- Churn probability decreases significantly after 24 months
- New customer retention is critical

### 3. Pricing Sensitivity
- Higher monthly charges correlate with increased churn
- Customers paying **>$80/month** show elevated churn rates
- Price optimization opportunities exist

### 4. Customer Satisfaction
- Strong inverse relationship with churn
- Satisfaction scores **< 3** indicate high churn risk
- Support ticket volume correlates with dissatisfaction

### 5. Payment Method
- **Electronic check** users have highest churn rate
- Automatic payment methods show better retention
- Payment friction may contribute to churn

## Model Performance

| Model | Accuracy | Precision | Recall | F1-Score | AUC |
|-------|----------|-----------|--------|----------|-----|
| **Random Forest** | **0.825** | **0.781** | **0.692** | **0.734** | **0.876** |
| LASSO | 0.801 | 0.745 | 0.671 | 0.706 | 0.854 |
| Logistic Regression | 0.798 | 0.738 | 0.665 | 0.699 | 0.851 |

**Best Model**: Random Forest with **87.6% AUC**

### Top Predictive Features
1. Tenure (months)
2. Contract type (month-to-month)
3. Total charges
4. Customer satisfaction
5. Monthly charges

## Visualizations

The project generates 9+ comprehensive visualizations:

1. **Churn Distribution**: Overall churn rate breakdown
2. **Contract Analysis**: Churn by contract type
3. **Tenure Analysis**: Distribution by churn status
4. **Pricing Impact**: Monthly charges vs churn
5. **Multi-factor Analysis**: Tenure × Contract interaction
6. **Satisfaction Impact**: Satisfaction level correlation
7. **Payment Method**: Churn by payment type
8. **Support Tickets**: Ticket volume impact
9. **Dashboard**: Comprehensive overview

All plots are saved as high-resolution PNG files in the `outputs/` directory.

## Business Recommendations

### 1. Contract Strategy
- Incentivize long-term contracts with discounts
- Implement early engagement programs for month-to-month customers
- Create upgrade paths from monthly to annual contracts

### 2. Retention Focus
- Target customers in first 12 months with retention campaigns
- Implement proactive outreach at 6-month mark
- Develop onboarding excellence programs

### 3. Pricing Optimization
- Review pricing tiers for high-charge customers
- Consider value-added bundles to justify premium pricing
- Implement loyalty discounts for long-tenure customers

### 4. Customer Experience
- Reduce support ticket volume through process improvements
- Implement satisfaction monitoring and intervention triggers
- Create VIP support for high-value at-risk customers

### 5. Payment Optimization
- Encourage automatic payment enrollment
- Provide incentives for switching from electronic check
- Simplify payment processes

## Technical Highlights

- **Data Engineering**: Automated pipeline from generation to modeling
- **Feature Engineering**: Created interaction terms and derived features
- **Model Selection**: Compared multiple algorithms with cross-validation
- **Regularization**: LASSO for feature selection and overfitting prevention
- **Visualization**: Professional-grade plots with ggplot2
- **Reproducibility**: Set seed values for consistent results

## Future Enhancements

- [ ] Deep learning models (neural networks)
- [ ] Time-series analysis of churn trends
- [ ] Customer segmentation using clustering
- [ ] Real-time churn prediction API
- [ ] A/B testing framework for retention strategies
- [ ] Interactive Shiny dashboard
- [ ] Survival analysis for customer lifetime value

## Author

**Data Science Portfolio Project**

This project demonstrates proficiency in:
- R programming and data manipulation (tidyverse, dplyr)
- Statistical analysis and hypothesis testing
- Machine learning and predictive modeling
- Data visualization and storytelling
- End-to-end ML pipeline development

## License

This project is open source and available for educational and portfolio purposes.

## References

- Tidyverse: https://www.tidyverse.org/
- Caret Package: https://topepo.github.io/caret/
- Random Forest: Breiman, L. (2001). Random Forests. Machine Learning, 45(1), 5-32.
- Customer Churn: Industry best practices and academic research

---

**Last Updated**: December 2025

For questions or collaboration opportunities, please reach out through GitHub.
