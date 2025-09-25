# Code Examples and Practical Applications

## R Code Examples

### Mixed Models vs GEE Implementation

#### Sample Data Generation
```r
# Create sample longitudinal data
library(dplyr)
set.seed(123)

n_subjects <- 100
n_timepoints <- 4

# Generate data
data <- expand.grid(
  subject = 1:n_subjects,
  time = 1:n_timepoints
) %>%
  mutate(
    treatment = rep(rbinom(n_subjects, 1, 0.5), each = n_timepoints),
    # Random intercept for each subject
    random_int = rep(rnorm(n_subjects, 0, 2), each = n_timepoints),
    # Generate outcome with treatment effect and random intercept
    outcome = 10 + 2*treatment + 0.5*time + random_int + rnorm(n(), 0, 1)
  )

head(data)
```

#### Mixed Model Analysis
```r
library(lme4)
library(broom.mixed)

# Fit mixed model with random intercept
mixed_model <- lmer(outcome ~ treatment + time + (1|subject), data = data)

# Summary
summary(mixed_model)

# Extract coefficients with confidence intervals
tidy(mixed_model, conf.int = TRUE)

# Model diagnostics
plot(mixed_model)
qqnorm(residuals(mixed_model))
```

#### GEE Analysis  
```r
library(geepack)

# Fit GEE with exchangeable correlation
gee_model <- geeglm(outcome ~ treatment + time, 
                    id = subject,
                    corstr = "exchangeable", 
                    data = data)

# Summary
summary(gee_model)

# Extract coefficients
coef(summary(gee_model))

# Try different correlation structures
gee_ar1 <- geeglm(outcome ~ treatment + time, 
                  id = subject,
                  corstr = "ar1", 
                  data = data)

gee_unstructured <- geeglm(outcome ~ treatment + time, 
                          id = subject,
                          corstr = "unstructured", 
                          data = data)

# Compare working correlations
summary(gee_model)$corr
summary(gee_ar1)$corr
```

#### Comparing Results
```r
# Extract coefficients from both models
mixed_coefs <- tidy(mixed_model, conf.int = TRUE) %>%
  filter(effect == "fixed") %>%
  mutate(model = "Mixed Model")

gee_coefs <- tidy(gee_model, conf.int = TRUE) %>%
  mutate(model = "GEE")

# Combine and compare
comparison <- bind_rows(mixed_coefs, gee_coefs) %>%
  select(model, term, estimate, conf.low, conf.high)

print(comparison)

# Plot comparison
library(ggplot2)
ggplot(comparison, aes(x = term, y = estimate, color = model)) +
  geom_point(position = position_dodge(0.3)) +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), 
                position = position_dodge(0.3), width = 0.2) +
  theme_minimal() +
  labs(title = "Mixed Model vs GEE Coefficient Comparison")
```

### Reader Agreement Statistics

#### Cohen's Kappa Example
```r
library(irr)

# Example data: Two raters classifying 50 cases as Normal/Abnormal
set.seed(456)
n <- 50

# Create some realistic agreement pattern
true_status <- rbinom(n, 1, 0.3)  # 30% abnormal
rater1 <- ifelse(true_status == 1, 
                rbinom(sum(true_status == 1), 1, 0.9),  # 90% sensitivity
                rbinom(sum(true_status == 0), 1, 0.1))  # 90% specificity

rater2 <- ifelse(true_status == 1, 
                rbinom(sum(true_status == 1), 1, 0.85), # 85% sensitivity
                rbinom(sum(true_status == 0), 1, 0.15)) # 85% specificity

# Create labels
rater1_labels <- factor(rater1, labels = c("Normal", "Abnormal"))
rater2_labels <- factor(rater2, labels = c("Normal", "Abnormal"))

# Calculate Cohen's kappa
kappa_result <- kappa2(cbind(rater1_labels, rater2_labels))
print(kappa_result)

# Cross-tabulation
table(rater1_labels, rater2_labels)

# Observed agreement
observed_agreement <- sum(rater1 == rater2) / length(rater1)
cat("Observed Agreement:", round(observed_agreement, 3), "\n")
```

#### Weighted Kappa for Ordered Categories
```r
# Example: Two raters rating severity on 1-5 scale
set.seed(789)
n <- 100

# Generate ratings with some agreement
true_severity <- sample(1:5, n, replace = TRUE, prob = c(0.2, 0.3, 0.3, 0.15, 0.05))

# Add rater-specific noise
rater1 <- pmax(1, pmin(5, true_severity + sample(c(-1, 0, 1), n, replace = TRUE, prob = c(0.2, 0.6, 0.2))))
rater2 <- pmax(1, pmin(5, true_severity + sample(c(-1, 0, 1), n, replace = TRUE, prob = c(0.15, 0.7, 0.15))))

# Unweighted kappa
unweighted <- kappa2(cbind(rater1, rater2))
cat("Unweighted Kappa:", round(unweighted$value, 3), "\n")

# Linear weighted kappa  
linear_weighted <- kappa2(cbind(rater1, rater2), weight = "linear")
cat("Linear Weighted Kappa:", round(linear_weighted$value, 3), "\n")

# Quadratic weighted kappa
quad_weighted <- kappa2(cbind(rater1, rater2), weight = "squared")
cat("Quadratic Weighted Kappa:", round(quad_weighted$value, 3), "\n")
```

#### ICC Analysis
```r
library(psych)

# Example: 3 raters scoring 40 subjects on continuous scale
set.seed(101112)
n_subjects <- 40
n_raters <- 3

# Generate data with ICC around 0.75
true_scores <- rnorm(n_subjects, 50, 10)
rater_data <- matrix(nrow = n_subjects, ncol = n_raters)

for(i in 1:n_raters) {
  # Add rater-specific bias and random error
  rater_bias <- rnorm(1, 0, 2)
  rater_data[, i] <- true_scores + rater_bias + rnorm(n_subjects, 0, 4)
}

colnames(rater_data) <- paste0("Rater_", 1:n_raters)

# Calculate different ICC types
icc_results <- ICC(rater_data)
print(icc_results)

# Plot ratings by rater
library(reshape2)
library(ggplot2)

plot_data <- melt(data.frame(Subject = 1:n_subjects, rater_data), 
                 id.vars = "Subject", 
                 variable.name = "Rater", 
                 value.name = "Score")

ggplot(plot_data, aes(x = Rater, y = Score)) +
  geom_boxplot() +
  geom_point(alpha = 0.5, position = position_jitter(width = 0.2)) +
  theme_minimal() +
  labs(title = "Ratings by Rater", 
       y = "Score")

# Scatterplot matrix
pairs(rater_data, main = "Pairwise Rater Comparisons")
```

#### Bland-Altman Analysis
```r
library(BlandAltmanLeh)

# Example: Comparing two blood pressure measurement methods
set.seed(131415)
n <- 50

# Generate true blood pressure values
true_bp <- rnorm(n, 120, 15)

# Method 1: Standard method (slight positive bias)
method1 <- true_bp + rnorm(n, 2, 3)

# Method 2: New method (slight negative bias, more variable)  
method2 <- true_bp + rnorm(n, -1, 4)

# Bland-Altman plot
bland.altman.plot(method1, method2,
                  main = "Bland-Altman Plot: Method Comparison",
                  xlab = "Average of Methods",
                  ylab = "Difference (Method 1 - Method 2)")

# Calculate bias and limits of agreement
differences <- method1 - method2
bias <- mean(differences)
sd_diff <- sd(differences)
lower_limit <- bias - 1.96 * sd_diff
upper_limit <- bias + 1.96 * sd_diff

cat("Bias:", round(bias, 2), "\n")
cat("95% Limits of Agreement:", round(lower_limit, 2), "to", round(upper_limit, 2), "\n")

# Test for systematic bias
t.test(differences)
```

## Python Examples

### Mixed Models vs GEE in Python

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.genmod import families
from statsmodels.gee import GEE
from statsmodels.genmod.cov_struct import Exchangeable, AR1
import statsmodels.formula.api as smf

# Generate sample data
np.random.seed(123)
n_subjects = 100
n_timepoints = 4

# Create DataFrame
data = []
for subject in range(1, n_subjects + 1):
    treatment = np.random.binomial(1, 0.5)
    random_int = np.random.normal(0, 2)
    
    for time in range(1, n_timepoints + 1):
        outcome = 10 + 2*treatment + 0.5*time + random_int + np.random.normal(0, 1)
        data.append({
            'subject': subject,
            'time': time,
            'treatment': treatment,
            'outcome': outcome
        })

df = pd.DataFrame(data)

# Mixed Model using statsmodels
mixed_model = smf.mixedlm("outcome ~ treatment + time", 
                         df, 
                         groups=df["subject"])
mixed_result = mixed_model.fit()
print("Mixed Model Results:")
print(mixed_result.summary())

# GEE Analysis
gee_model = GEE.from_formula("outcome ~ treatment + time",
                           groups="subject",
                           data=df,
                           cov_struct=Exchangeable(),
                           family=families.Gaussian())
gee_result = gee_model.fit()
print("\nGEE Results:")
print(gee_result.summary())
```

### Agreement Statistics in Python

```python
import pandas as pd
import numpy as np
from sklearn.metrics import cohen_kappa_score, confusion_matrix
from scipy import stats
import matplotlib.pyplot as plt

# Cohen's Kappa Example
np.random.seed(456)
n = 50

# Generate ratings
true_status = np.random.binomial(1, 0.3, n)
rater1 = np.where(true_status == 1,
                 np.random.binomial(1, 0.9, np.sum(true_status == 1)),
                 np.random.binomial(1, 0.1, np.sum(true_status == 0)))

rater2 = np.where(true_status == 1,
                 np.random.binomial(1, 0.85, np.sum(true_status == 1)),
                 np.random.binomial(1, 0.15, np.sum(true_status == 0)))

# Calculate Cohen's kappa
kappa = cohen_kappa_score(rater1, rater2)
print(f"Cohen's Kappa: {kappa:.3f}")

# Confusion matrix
cm = confusion_matrix(rater1, rater2)
print("Confusion Matrix:")
print(cm)

# Observed agreement
observed_agreement = np.sum(rater1 == rater2) / len(rater1)
print(f"Observed Agreement: {observed_agreement:.3f}")

# Bland-Altman Plot
def bland_altman_plot(method1, method2):
    mean = np.mean([method1, method2], axis=0)
    diff = method1 - method2
    md = np.mean(diff)
    sd = np.std(diff, ddof=1)
    
    plt.figure(figsize=(10, 6))
    plt.scatter(mean, diff, alpha=0.6)
    plt.axhline(md, color='red', linestyle='-', label=f'Bias: {md:.2f}')
    plt.axhline(md + 1.96*sd, color='blue', linestyle='--', 
                label=f'Upper LoA: {md + 1.96*sd:.2f}')
    plt.axhline(md - 1.96*sd, color='blue', linestyle='--', 
                label=f'Lower LoA: {md - 1.96*sd:.2f}')
    plt.xlabel('Average of Methods')
    plt.ylabel('Difference (Method 1 - Method 2)')
    plt.title('Bland-Altman Plot')
    plt.legend()
    plt.grid(True, alpha=0.3)
    plt.show()
    
    return md, sd

# Example usage
np.random.seed(131415)
n = 50
true_bp = np.random.normal(120, 15, n)
method1 = true_bp + np.random.normal(2, 3, n)
method2 = true_bp + np.random.normal(-1, 4, n)

bias, sd_diff = bland_altman_plot(method1, method2)
print(f"Bias: {bias:.2f}")
print(f"95% Limits of Agreement: {bias - 1.96*sd_diff:.2f} to {bias + 1.96*sd_diff:.2f}")
```

## Practical Application Scenarios

### Scenario 1: Clinical Trial with Repeated Measures

**Context:** Testing new drug vs placebo, measurements at baseline, 1 month, 3 months, 6 months.

**Research Questions:**
- Mixed Model: "How much does the drug improve outcomes for individual patients?"
- GEE: "What is the average treatment effect in the population?"

**Code Implementation:**
```r
# Simulate clinical trial data
simulate_trial <- function(n_per_group = 100, effect_size = 2) {
  n_total <- n_per_group * 2
  times <- c(0, 1, 3, 6)
  
  data <- expand.grid(
    subject = 1:n_total,
    time = times
  ) %>%
    mutate(
      treatment = rep(c(0, 1), each = n_per_group * length(times)),
      # Random intercept and slope for each subject
      random_int = rep(rnorm(n_total, 0, 3), each = length(times)),
      random_slope = rep(rnorm(n_total, 0, 0.5), each = length(times)),
      # Baseline value
      baseline = rep(rnorm(n_total, 50, 10), each = length(times)),
      # Treatment effect grows over time
      treatment_effect = treatment * effect_size * time,
      # Generate outcome
      outcome = baseline + treatment_effect + 
                random_int + random_slope * time + 
                rnorm(n(), 0, 2)
    )
  
  return(data)
}

# Analyze with both approaches
trial_data <- simulate_trial()

# Mixed model with random intercept and slope
mixed_trial <- lmer(outcome ~ treatment * time + (time|subject), 
                   data = trial_data)

# GEE with unstructured correlation
gee_trial <- geeglm(outcome ~ treatment * time, 
                   id = subject,
                   corstr = "unstructured", 
                   data = trial_data)
```

### Scenario 2: Diagnostic Agreement Study

**Context:** Three radiologists reading mammograms for cancer detection.

```r
# Simulate mammogram readings
simulate_readings <- function(n_images = 200, cancer_prevalence = 0.15) {
  # True cancer status
  true_cancer <- rbinom(n_images, 1, cancer_prevalence)
  
  # Radiologist performance parameters
  sensitivities <- c(0.90, 0.85, 0.92)
  specificities <- c(0.88, 0.90, 0.85)
  
  readings <- matrix(nrow = n_images, ncol = 3)
  
  for(i in 1:3) {
    readings[, i] <- ifelse(
      true_cancer == 1,
      rbinom(sum(true_cancer == 1), 1, sensitivities[i]),
      rbinom(sum(true_cancer == 0), 1, 1 - specificities[i])
    )
  }
  
  colnames(readings) <- paste0("Radiologist_", 1:3)
  return(list(readings = readings, truth = true_cancer))
}

# Analyze agreement
mammo_data <- simulate_readings()

# Fleiss' kappa for all three radiologists
fleiss_kappa <- kappam.fleiss(mammo_data$readings)

# Pairwise kappas
pairwise_kappas <- list()
for(i in 1:2) {
  for(j in (i+1):3) {
    pair_name <- paste0("R", i, "_vs_R", j)
    pairwise_kappas[[pair_name]] <- kappa2(mammo_data$readings[, c(i, j)])
  }
}

print(fleiss_kappa)
print(pairwise_kappas)
```

This comprehensive collection provides both theoretical understanding and practical implementation examples for the statistical concepts covered in this repository.