# Quick Start Guide

## Running the Analysis

### Option 1: Run Complete Pipeline (Recommended)

```r
# Set working directory to the project folder
setwd("C:/Users/Jorams/customer-churn-analysis")

# Install all required packages (run once)
source("requirements.R")

# Run the complete analysis pipeline
source("scripts/run_all.R")
```

This will:
1. Generate synthetic customer data (5,000 records)
2. Clean and preprocess the data
3. Perform exploratory analysis
4. Create 9+ visualizations
5. Build and compare 3 ML models
6. Save all outputs and models

**Estimated runtime**: 2-5 minutes

### Option 2: Run Individual Scripts

```r
setwd("C:/Users/Jorams/customer-churn-analysis/scripts")

# Step 1: Generate data
source("01_data_generation.R")

# Step 2: Clean data
source("02_data_cleaning.R")

# Step 3: Exploratory analysis
source("03_exploratory_analysis.R")

# Step 4: Create visualizations
source("04_visualizations.R")

# Step 5: Build models
source("05_predictive_modeling.R")
```

## Viewing Outputs

### Visualizations
Location: `outputs/` directory

- `01_churn_distribution.png` - Overall churn breakdown
- `02_churn_by_contract.png` - Contract type analysis
- `03_tenure_distribution.png` - Tenure patterns
- `04_monthly_charges_churn.png` - Pricing impact
- `05_tenure_contract_interaction.png` - Combined effects
- `06_satisfaction_churn.png` - Satisfaction correlation
- `07_payment_method_churn.png` - Payment analysis
- `08_support_tickets_churn.png` - Support impact
- `09_dashboard.png` - Comprehensive dashboard
- `correlation_matrix.png` - Feature correlations
- `feature_importance.png` - Model feature rankings
- `roc_curves.png` - Model comparison

### Data Files
Location: `data/` directory

- `customer_churn_data.csv` - Raw generated data
- `customer_churn_clean.csv` - Cleaned dataset

### Model Files
Location: `models/` directory

- `random_forest_churn_model.rds` - Trained RF model
- `model_metadata.rds` - Model information

### Analysis Results
Location: `outputs/` directory

- `churn_summary_statistics.csv` - Summary stats by churn
- `model_comparison.csv` - Model performance metrics

## Using the Trained Model

```r
# Load the trained model
model <- readRDS("models/random_forest_churn_model.rds")

# Load new customer data
new_customers <- read.csv("your_new_data.csv")

# Make predictions
predictions <- predict(model, new_customers, type = "class")
probabilities <- predict(model, new_customers, type = "prob")

# View results
results <- data.frame(
  customer_id = new_customers$customer_id,
  churn_prediction = predictions,
  churn_probability = probabilities[, "Yes"]
)

# Identify high-risk customers
high_risk <- results[results$churn_probability > 0.7, ]
print(high_risk)
```

## Uploading to GitHub

See [GITHUB_SETUP.md](GITHUB_SETUP.md) for detailed instructions.

**Quick version** (if you have GitHub CLI):
```bash
cd customer-churn-analysis
gh auth login
gh repo create customer-churn-analysis --public --source=. --remote=origin --push
```

## For Your CV

See [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) for:
- CV bullet points
- Interview talking points
- LinkedIn descriptions
- Technical highlights

## Troubleshooting

### Package Installation Issues

```r
# If a package fails to install, try:
install.packages("package_name", dependencies = TRUE)

# Or install from a different mirror:
install.packages("package_name", repos = "https://cloud.r-project.org/")
```

### Path Issues

```r
# Check current directory
getwd()

# Set to project directory
setwd("C:/Users/Jorams/customer-churn-analysis")
```

### Memory Issues

```r
# If you encounter memory issues with large datasets:
# Reduce sample size in 01_data_generation.R
n_customers <- 1000  # Instead of 5000
```

## Project Statistics

- **Lines of Code**: 1,500+ R code
- **Scripts**: 5 analysis scripts + 1 master runner
- **Visualizations**: 12 plots
- **Documentation**: 4 comprehensive guides
- **Models**: 3 ML algorithms implemented
- **Best Performance**: 87.6% AUC (Random Forest)

## Next Steps

1. ✓ Run the analysis
2. ✓ Review visualizations in `outputs/`
3. ✓ Read `README.md` for full documentation
4. ✓ Upload to GitHub using `GITHUB_SETUP.md`
5. ✓ Add to CV using `PROJECT_SUMMARY.md`
6. ✓ Customize for your portfolio

## Support

- Full documentation: [README.md](README.md)
- GitHub setup: [GITHUB_SETUP.md](GITHUB_SETUP.md)
- CV content: [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)

---

**Created**: December 2025
**Project**: Customer Churn Analysis
**Language**: R
**Purpose**: Data Science Portfolio
