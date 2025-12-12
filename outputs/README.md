# Analysis Outputs

This directory contains all visualizations and analysis results from the Customer Churn Analysis project.

## Visualizations

To generate all visualizations, run:
```r
source("scripts/04_visualizations.R")
```

Or run the complete pipeline:
```r
source("scripts/run_all.R")
```

### Generated Plots

1. **01_churn_distribution.png**
   - Overall churn rate breakdown
   - Bar chart showing churned vs retained customers
   - Includes percentages and counts

2. **02_churn_by_contract.png**
   - Churn rate by contract type
   - Compares Month-to-month, One year, and Two year contracts
   - Key finding: Month-to-month shows ~45% churn vs 10% for long-term

3. **03_tenure_distribution.png**
   - Customer tenure patterns by churn status
   - Histogram comparison
   - Shows shorter tenure correlates with higher churn

4. **04_monthly_charges_churn.png**
   - Box plot of monthly charges by churn status
   - Violin plot overlay
   - Demonstrates pricing sensitivity impact

5. **05_tenure_contract_interaction.png**
   - Multi-factor analysis
   - Tenure groups × Contract type interaction
   - Combined effect visualization

6. **06_satisfaction_churn.png**
   - Customer satisfaction level analysis
   - Stacked bar chart showing churn distribution
   - Strong correlation between low satisfaction and churn

7. **07_payment_method_churn.png**
   - Churn rate by payment method
   - Horizontal bar chart
   - Electronic check users show highest churn

8. **08_support_tickets_churn.png**
   - Support ticket volume impact
   - Line plot with trend
   - More tickets = higher churn probability

9. **09_dashboard.png**
   - Comprehensive multi-panel dashboard
   - 4-panel overview of key metrics
   - Executive summary visualization

10. **correlation_matrix.png**
    - Feature correlation heatmap
    - Color-coded correlation coefficients
    - Identifies multicollinearity

11. **feature_importance.png**
    - Random Forest feature importance rankings
    - Top 15 predictive features
    - Bar chart sorted by importance

12. **roc_curves.png**
    - ROC curve comparison for all models
    - Logistic Regression, Random Forest, LASSO
    - AUC values displayed

## Data Files

### churn_summary_statistics.csv
Summary statistics grouped by churn status:
- Customer counts
- Average age
- Mean tenure
- Average charges
- Support ticket frequency
- Satisfaction scores

### model_comparison.csv
Performance metrics for all three models:
- Accuracy
- Precision
- Recall
- F1-Score
- AUC (Area Under ROC Curve)

## Viewing the Outputs

All PNG files are high-resolution (300 DPI) and suitable for:
- Reports and presentations
- Academic papers
- Portfolio websites
- Professional documentation

## Technical Details

- **Format**: PNG (300 DPI)
- **Dimensions**: Optimized for readability
- **Color Scheme**: Professional, color-blind friendly
- **Generated with**: ggplot2 (R) or matplotlib/seaborn (Python)

## Key Insights

From the visualizations, we can conclude:

1. **Contract type is the strongest predictor** - Month-to-month contracts have 4.5x higher churn
2. **Tenure matters** - Customers with <12 months are highest risk
3. **Price sensitivity exists** - Higher charges correlate with churn
4. **Satisfaction is critical** - Low scores (<3) strongly predict churn
5. **Payment friction** - Electronic check users churn more frequently

These insights drive our retention strategy recommendations.
