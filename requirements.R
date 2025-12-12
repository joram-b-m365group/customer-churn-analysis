# ============================================================================
# Customer Churn Analysis - Package Requirements
# ============================================================================
# This script installs all required R packages for the project
# Run this once before executing the analysis scripts
# ============================================================================

cat("Installing required R packages for Customer Churn Analysis...\n\n")

# List of required packages
required_packages <- c(
  # Data manipulation and tidyverse
  "tidyverse",     # Meta-package including dplyr, ggplot2, tidyr, readr, etc.
  "dplyr",         # Data manipulation
  "readr",         # Reading CSV files
  "tibble",        # Modern data frames
  "tidyr",         # Data tidying
  "purrr",         # Functional programming
  "stringr",       # String manipulation
  "lubridate",     # Date/time handling

  # Visualization
  "ggplot2",       # Grammar of graphics plotting
  "gridExtra",     # Arrange multiple plots
  "corrplot",      # Correlation plots
  "scales",        # Scale functions for visualization
  "viridis",       # Color palettes
  "RColorBrewer",  # Color palettes
  "ggthemes",      # Additional themes for ggplot2

  # Data quality and exploration
  "naniar",        # Missing data visualization
  "skimr",         # Summary statistics

  # Machine learning
  "caret",         # Classification and regression training
  "randomForest",  # Random Forest algorithm
  "glmnet",        # Regularized regression (LASSO, Ridge)
  "MASS",          # Statistical functions
  "pROC",          # ROC curve analysis
  "e1071"          # Support functions for ML
)

# Function to install packages if not already installed
install_if_missing <- function(package) {
  if (!require(package, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("Installing %s...\n", package))
    install.packages(package, dependencies = TRUE, repos = "https://cran.r-project.org")
    return(TRUE)
  } else {
    cat(sprintf("✓ %s already installed\n", package))
    return(FALSE)
  }
}

# Install packages
cat("Checking and installing packages...\n")
cat("=====================================\n\n")

newly_installed <- sapply(required_packages, install_if_missing)

cat("\n=====================================\n")
cat("Package installation complete!\n\n")

if (sum(newly_installed) > 0) {
  cat(sprintf("Newly installed: %d packages\n", sum(newly_installed)))
} else {
  cat("All packages were already installed.\n")
}

cat(sprintf("Total packages required: %d\n", length(required_packages)))

# Verify all packages can be loaded
cat("\nVerifying package loading...\n")
all_loaded <- TRUE

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("✗ Failed to load %s\n", pkg))
    all_loaded <- FALSE
  }
}

if (all_loaded) {
  cat("\n✓ All packages loaded successfully!\n")
  cat("\nYou're ready to run the analysis.\n")
  cat("Execute: source('scripts/run_all.R')\n")
} else {
  cat("\n✗ Some packages failed to load. Please check the error messages above.\n")
}

# Display R session info
cat("\n--- R Session Information ---\n")
cat(sprintf("R version: %s\n", R.version.string))
cat(sprintf("Platform: %s\n", R.version$platform))
cat(sprintf("Working directory: %s\n", getwd()))
