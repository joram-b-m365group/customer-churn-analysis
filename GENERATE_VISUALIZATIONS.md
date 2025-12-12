# How to Generate Visualizations

The visualization PNG files are not included in the repository to keep it lightweight. Follow these simple steps to generate all 12 professional visualizations:

## Prerequisites

Ensure you have R and the required packages installed:

```r
source("requirements.R")
```

## Option 1: Generate All Outputs (Recommended)

Run the complete analysis pipeline:

```r
setwd("C:/Users/Jorams/customer-churn-analysis")
source("scripts/run_all.R")
```

This will:
1. Generate synthetic customer data
2. Clean and preprocess data
3. Perform exploratory analysis
4. **Create all 12 visualizations**
5. Build and evaluate models

**Runtime**: 2-5 minutes
**Output**: All files in `outputs/` directory

## Option 2: Generate Only Visualizations

If you just want the plots:

```r
setwd("C:/Users/Jorams/customer-churn-analysis")

# First, generate the data
source("scripts/01_data_generation.R")
source("scripts/02_data_cleaning.R")

# Then create visualizations
source("scripts/04_visualizations.R")
```

## Option 3: Using Python (Alternative)

If R is not available, you can use the Python script:

```bash
cd customer-churn-analysis
pip install pandas numpy matplotlib seaborn
python generate_outputs.py
```

## Generated Files

After running, you'll have these files in `outputs/`:

### Visualizations (12 PNG files)
- `01_churn_distribution.png`
- `02_churn_by_contract.png`
- `03_tenure_distribution.png`
- `04_monthly_charges_churn.png`
- `05_tenure_contract_interaction.png`
- `06_satisfaction_churn.png`
- `07_payment_method_churn.png`
- `08_support_tickets_churn.png`
- `09_dashboard.png`
- `correlation_matrix.png`
- `feature_importance.png`
- `roc_curves.png`

### Data Files
- `churn_summary_statistics.csv` (already included)
- `model_comparison.csv` (already included)

## Why Aren't Visualizations Included?

Following best practices:
- **Repository size**: PNG files can be large
- **Reproducibility**: Scripts ensure anyone can generate identical outputs
- **Customization**: Users can modify parameters and regenerate
- **Version control**: Code changes matter more than generated images

## Viewing Examples

To see what the visualizations look like:
1. Run the scripts (2-5 minutes)
2. Check the `outputs/` folder
3. All images are 300 DPI, publication-quality

## Troubleshooting

### Package Installation Issues
```r
install.packages("tidyverse", dependencies = TRUE)
install.packages("ggplot2", dependencies = TRUE)
```

### Python Visualization Alternative
If R fails, the Python script (`generate_outputs.py`) creates similar visualizations using matplotlib and seaborn.

## Quick Test

Want to verify everything works?

```r
# Quick test - should complete in 30 seconds
source("scripts/01_data_generation.R")
```

If this runs without errors, the full pipeline will work.

---

**Questions?** Check [README.md](README.md) or [QUICK_START.md](QUICK_START.md)
