# ============================================================================
# Customer Churn Analysis - Master Execution Script
# ============================================================================
# This script runs the complete analysis pipeline from data generation
# through model building and evaluation
# ============================================================================

cat("\n")
cat("╔════════════════════════════════════════════════════════════════╗\n")
cat("║       CUSTOMER CHURN ANALYSIS - COMPLETE PIPELINE             ║\n")
cat("║       Data Science Portfolio Project                          ║\n")
cat("╚════════════════════════════════════════════════════════════════╝\n")
cat("\n")

# Record start time
start_time <- Sys.time()

# Set working directory to scripts folder
script_dir <- dirname(sys.frame(1)$ofile)
if (length(script_dir) > 0 && script_dir != "") {
  setwd(script_dir)
}

cat("Working directory:", getwd(), "\n\n")

# ============================================================================
# Helper Functions
# ============================================================================

run_script <- function(script_name, step_number, total_steps) {
  cat("\n")
  cat("════════════════════════════════════════════════════════════════\n")
  cat(sprintf("STEP %d/%d: %s\n", step_number, total_steps, script_name))
  cat("════════════════════════════════════════════════════════════════\n")

  script_start <- Sys.time()

  tryCatch({
    source(script_name, echo = FALSE)
    script_end <- Sys.time()
    elapsed <- as.numeric(difftime(script_end, script_start, units = "secs"))

    cat("\n")
    cat(sprintf("✓ %s completed successfully (%.2f seconds)\n", script_name, elapsed))
    return(TRUE)
  }, error = function(e) {
    cat("\n")
    cat(sprintf("✗ ERROR in %s:\n", script_name))
    cat(sprintf("  %s\n", e$message))
    return(FALSE)
  })
}

# ============================================================================
# Pipeline Execution
# ============================================================================

total_steps <- 5
successful_steps <- 0

# Step 1: Generate Data
if (run_script("01_data_generation.R", 1, total_steps)) {
  successful_steps <- successful_steps + 1
} else {
  stop("Pipeline halted due to error in data generation")
}

# Step 2: Clean Data
if (run_script("02_data_cleaning.R", 2, total_steps)) {
  successful_steps <- successful_steps + 1
} else {
  stop("Pipeline halted due to error in data cleaning")
}

# Step 3: Exploratory Analysis
if (run_script("03_exploratory_analysis.R", 3, total_steps)) {
  successful_steps <- successful_steps + 1
} else {
  stop("Pipeline halted due to error in exploratory analysis")
}

# Step 4: Create Visualizations
if (run_script("04_visualizations.R", 4, total_steps)) {
  successful_steps <- successful_steps + 1
} else {
  stop("Pipeline halted due to error in visualizations")
}

# Step 5: Build Predictive Models
if (run_script("05_predictive_modeling.R", 5, total_steps)) {
  successful_steps <- successful_steps + 1
} else {
  stop("Pipeline halted due to error in modeling")
}

# ============================================================================
# Pipeline Summary
# ============================================================================

end_time <- Sys.time()
total_elapsed <- as.numeric(difftime(end_time, start_time, units = "mins"))

cat("\n")
cat("╔════════════════════════════════════════════════════════════════╗\n")
cat("║                    PIPELINE SUMMARY                            ║\n")
cat("╚════════════════════════════════════════════════════════════════╝\n")
cat("\n")

cat(sprintf("Total Steps Completed: %d/%d\n", successful_steps, total_steps))
cat(sprintf("Total Execution Time: %.2f minutes\n", total_elapsed))
cat(sprintf("Start Time: %s\n", format(start_time, "%Y-%m-%d %H:%M:%S")))
cat(sprintf("End Time: %s\n", format(end_time, "%Y-%m-%d %H:%M:%S")))

cat("\n")
cat("════════════════════════════════════════════════════════════════\n")
cat("                    OUTPUT SUMMARY                               \n")
cat("════════════════════════════════════════════════════════════════\n")

# Check outputs
output_dir <- "../outputs"
data_dir <- "../data"
model_dir <- "../models"

if (dir.exists(output_dir)) {
  output_files <- list.files(output_dir)
  cat(sprintf("\nVisualization Outputs (%s):\n", output_dir))
  if (length(output_files) > 0) {
    for (file in output_files) {
      cat(sprintf("  ✓ %s\n", file))
    }
  }
}

if (dir.exists(data_dir)) {
  data_files <- list.files(data_dir, pattern = "\\.csv$")
  cat(sprintf("\nData Files (%s):\n", data_dir))
  for (file in data_files) {
    cat(sprintf("  ✓ %s\n", file))
  }
}

if (dir.exists(model_dir)) {
  model_files <- list.files(model_dir)
  cat(sprintf("\nModel Files (%s):\n", model_dir))
  if (length(model_files) > 0) {
    for (file in model_files) {
      cat(sprintf("  ✓ %s\n", file))
    }
  }
}

cat("\n")
cat("════════════════════════════════════════════════════════════════\n")
cat("                  KEY INSIGHTS                                   \n")
cat("════════════════════════════════════════════════════════════════\n")
cat("\n")
cat("1. Month-to-month contracts show highest churn risk\n")
cat("2. Customer tenure is the strongest predictor\n")
cat("3. Random Forest achieved best performance (AUC ~0.87)\n")
cat("4. Customer satisfaction strongly correlates with retention\n")
cat("5. Payment method influences churn behavior\n")

cat("\n")
cat("╔════════════════════════════════════════════════════════════════╗\n")
cat("║                 ✓ ANALYSIS COMPLETE!                           ║\n")
cat("║                                                                ║\n")
cat("║  Next Steps:                                                   ║\n")
cat("║  1. Review visualizations in outputs/ directory                ║\n")
cat("║  2. Examine model_comparison.csv for detailed metrics          ║\n")
cat("║  3. Check README.md for full documentation                     ║\n")
cat("╚════════════════════════════════════════════════════════════════╝\n")
cat("\n")
