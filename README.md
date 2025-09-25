# Statistics Notes

A comprehensive collection of statistical tools and concepts that can be confusing or require deeper understanding. This repository serves as a reference guide for complex statistical methods and their practical applications.

## Table of Contents

1. [Mixed Models vs Generalized Estimating Equations (GEE)](#mixed-models-vs-gee)
2. [Reader Agreement Statistics](#reader-agreement-statistics)  
3. [Quick Reference Guides](#quick-reference-guides)
4. [Code Examples and Practical Applications](#code-examples)
5. [References](#references)

## Detailed Guides

For comprehensive coverage of each topic, see the detailed guides:

- **[Mixed Models vs GEE - Detailed Guide](mixed-models-vs-gee.md)** - In-depth comparison with mathematical foundations, practical examples, and implementation code
- **[Reader Agreement Statistics - Comprehensive Guide](reader-agreement-statistics.md)** - Complete coverage of agreement statistics with step-by-step examples and interpretations
- **[Code Examples and Practical Applications](code-examples.md)** - R and Python implementation examples with sample data generation and real-world scenarios

---

## Mixed Models vs GEE

### Overview

Both Mixed Models and Generalized Estimating Equations (GEE) are statistical methods used to analyze correlated or clustered data, but they differ in their assumptions, interpretations, and use cases.

### Mixed Models (Linear Mixed Models - LMM, Generalized Linear Mixed Models - GLMM)

**What they are:**
- Statistical models that account for both fixed effects (population-level effects) and random effects (subject-specific or cluster-specific effects)
- Assume that observations within clusters are correlated due to shared random effects

**Key characteristics:**
- **Model-based approach**: Makes specific assumptions about the distribution of random effects
- **Subject-specific interpretation**: Results apply to individual subjects
- **Handles missing data**: Uses all available data under Missing At Random (MAR) assumption
- **Flexible correlation structures**: Can model complex correlation patterns through random effects

**When to use:**
- When you're interested in individual-level predictions
- When you want to understand between-subject and within-subject variability
- When missing data is a concern
- When you have a genuine interest in the random effects themselves
- When you have nested or hierarchical data structures

**Assumptions:**
- Random effects are normally distributed
- Residuals are normally distributed (for LMM)
- Missing data is Missing At Random (MAR)

**Example applications:**
- Longitudinal studies tracking patients over time
- Educational research with students nested in schools
- Clinical trials with repeated measurements

### Generalized Estimating Equations (GEE)

**What they are:**
- Semi-parametric approach that estimates population-averaged effects
- Uses working correlation matrices to account for within-cluster correlation
- Provides robust standard errors even if correlation structure is misspecified

**Key characteristics:**
- **Population-averaged interpretation**: Results apply to the average response in the population
- **Robust to correlation misspecification**: Consistent estimates even with wrong correlation structure
- **No distributional assumptions**: Only requires correct specification of mean and variance
- **Marginal approach**: Focuses on marginal means rather than subject-specific effects

**When to use:**
- When you're interested in population-level effects
- When the correlation structure is uncertain or complex
- When you don't need subject-specific predictions
- When you want robust inference without strong distributional assumptions
- When missing data is minimal (GEE typically requires complete cases)

**Assumptions:**
- Correct specification of the mean model
- Missing data is Missing Completely At Random (MCAR) - stronger than Mixed Models
- Large sample sizes for asymptotic properties

**Example applications:**
- Cross-sectional studies with clustering
- Public health interventions at community level
- Survey data with complex sampling schemes

### Key Differences Summary

| Aspect | Mixed Models | GEE |
|--------|--------------|-----|
| **Interpretation** | Subject-specific | Population-averaged |
| **Missing Data** | MAR acceptable | MCAR required |
| **Assumptions** | Strong distributional | Minimal distributional |
| **Correlation** | Model-based | Working correlation |
| **Predictions** | Individual-level | Population-level |
| **Robustness** | Sensitive to assumptions | Robust to correlation misspec. |

### Practical Decision Guide

**Choose Mixed Models when:**
- You need individual predictions
- Missing data is present
- You're interested in random effects
- You have confidence in distributional assumptions
- You want to understand both between and within-subject variation

**Choose GEE when:**
- You want population-level inference
- Correlation structure is uncertain
- You prefer robust methods
- Complete or nearly complete data
- You don't need subject-specific predictions

---

## Reader Agreement Statistics

### Overview

Reader agreement statistics measure the reliability and consistency between different raters or measurement methods. These are crucial in fields where subjective assessments are made, such as medical diagnosis, quality control, or research scoring.

### Types of Agreement

#### 1. **Cohen's Kappa (κ)**

**Purpose:** Measures agreement between two raters for categorical data, accounting for chance agreement.

**Formula:**
```
κ = (Po - Pe) / (1 - Pe)
```
Where:
- Po = Observed agreement
- Pe = Expected agreement by chance

**Interpretation:**
- κ < 0: Poor agreement (worse than chance)
- 0.00-0.20: Slight agreement
- 0.21-0.40: Fair agreement
- 0.41-0.60: Moderate agreement
- 0.61-0.80: Substantial agreement
- 0.81-1.00: Almost perfect agreement

**When to use:**
- Two raters
- Categorical outcomes
- Same categories for both raters

**Limitations:**
- Sensitive to prevalence (prevalence paradox)
- Assumes categories are unordered
- Can be affected by marginal distributions

#### 2. **Weighted Kappa**

**Purpose:** Extension of Cohen's kappa that accounts for the degree of disagreement.

**Key features:**
- Assigns weights to different types of disagreement
- Useful for ordered categorical data
- Common weighting schemes: linear, quadratic

**When to use:**
- Ordered categorical data (e.g., severity scales)
- When some disagreements are more serious than others

#### 3. **Fleiss' Kappa**

**Purpose:** Measures agreement among multiple raters (3 or more) for categorical data.

**Key features:**
- Extension of Cohen's kappa for multiple raters
- All raters don't need to rate all subjects
- Provides overall agreement measure

**When to use:**
- More than two raters
- Categorical outcomes
- Not all raters need to assess all subjects

#### 4. **Intraclass Correlation Coefficient (ICC)**

**Purpose:** Measures agreement for continuous or ordinal data, particularly useful for test-retest reliability.

**Types of ICC:**

**ICC(1,1) - One-way random effects, single measurement:**
- Each subject rated by different set of raters
- Raters are random sample from population

**ICC(2,1) - Two-way random effects, single measurement:**
- Each subject rated by same set of raters
- Raters are random sample from population

**ICC(3,1) - Two-way fixed effects, single measurement:**
- Each subject rated by same set of raters
- Raters are the only raters of interest

**Interpretation:**
- < 0.50: Poor reliability
- 0.50-0.75: Moderate reliability
- 0.75-0.90: Good reliability
- > 0.90: Excellent reliability

**When to use:**
- Continuous or ordinal data
- Multiple measurements per subject
- Interested in reliability of measurements

#### 5. **Bland-Altman Analysis**

**Purpose:** Assesses agreement between two continuous measurement methods.

**Key components:**
- Difference vs. average plots
- Limits of agreement (mean ± 1.96 × SD of differences)
- Bias assessment (systematic difference)

**When to use:**
- Two continuous measurement methods
- Want to assess bias and precision
- Comparing new method to gold standard

### Practical Considerations

#### Sample Size Planning
- Kappa statistics: Generally need >50 subjects for stable estimates
- ICC: Depends on number of raters and expected ICC value
- Use power analysis tools for precise calculations

#### Common Pitfalls
1. **Prevalence Paradox:** Kappa can be low even with high observed agreement if one category is very rare
2. **Missing Data:** Can affect agreement statistics; consider patterns of missingness
3. **Rater Training:** Poor training can lead to systematic disagreements
4. **Category Definition:** Poorly defined categories lead to poor agreement

#### Reporting Guidelines
- Report confidence intervals
- Describe rater characteristics and training
- Report prevalence of each category
- Consider multiple agreement measures
- Discuss clinical/practical significance

### Example Interpretations

**Medical Diagnosis Example:**
- κ = 0.65 for cancer diagnosis between two radiologists
- Interpretation: "Substantial agreement" but may not be sufficient for clinical decisions
- Consider: Training, additional raters, or consensus protocols

- **Quality Control Example:**
- ICC(2,1) = 0.82 for product ratings among 3 inspectors
- Interpretation: "Good reliability" suggests consistent quality assessments
- Consider: Standardized procedures working well

---

## Quick Reference Guides

### Mixed Models vs GEE Quick Decision

| **Question** | **Mixed Models** | **GEE** |
|-------------|------------------|---------|
| Need individual predictions? | ✅ Yes | ❌ No |
| Interest in population averages? | ❌ Limited | ✅ Yes |
| Missing data present? | ✅ Handles well (MAR) | ❌ Requires MCAR |
| Uncertain correlation structure? | ❌ Sensitive to misspecification | ✅ Robust |
| Want robust inference? | ❌ Model-dependent | ✅ Semi-parametric |
| Hierarchical/nested data? | ✅ Natural fit | ❌ Limited |

### Reader Agreement Quick Reference

| **Data Type** | **# Raters** | **Statistic** | **Interpretation Threshold** |
|---------------|--------------|---------------|------------------------------|
| Categorical | 2 | Cohen's κ | > 0.60 substantial |
| Categorical (ordered) | 2 | Weighted κ | > 0.60 substantial |
| Categorical | 3+ | Fleiss' κ | > 0.60 substantial |
| Continuous | 2+ | ICC | > 0.75 good |
| Continuous | 2 (methods) | Bland-Altman | Clinically acceptable limits |

### Common Mistakes to Avoid

#### Mixed Models vs GEE
- ❌ Comparing coefficients directly (different interpretations)
- ❌ Using GEE when substantial missing data
- ❌ Using mixed models without considering random effects necessity
- ❌ Ignoring the research question type (individual vs population)

#### Reader Agreement  
- ❌ Using correlation instead of agreement statistics
- ❌ Ignoring prevalence effects on kappa
- ❌ Not reporting confidence intervals
- ❌ Using inappropriate statistic for data type

---

## Code Examples

For hands-on implementation and practical applications, see the **[Code Examples and Practical Applications](code-examples.md)** guide, which includes:

### R and Python Examples
- Complete data generation and analysis workflows
- Mixed Models vs GEE implementations with sample datasets
- Reader agreement statistics with step-by-step calculations
- Visualization and interpretation examples

### Practical Scenarios
- **Clinical Trial Analysis:** Longitudinal treatment effects
- **Diagnostic Agreement:** Multi-rater reliability studies  
- **Method Comparison:** Bland-Altman analysis implementation
- **Real-world Applications:** Educational and medical research examples

---

## References

### Mixed Models vs GEE
1. Fitzmaurice, G., Laird, N., & Ware, J. (2011). *Applied Longitudinal Analysis* (2nd ed.). Wiley.
2. Diggle, P., Heagerty, P., Liang, K. Y., & Zeger, S. (2002). *Analysis of Longitudinal Data* (2nd ed.). Oxford University Press.
3. Molenberghs, G., & Verbeke, G. (2005). *Models for Discrete Longitudinal Data*. Springer.
4. Zeger, S. L., & Liang, K. Y. (1986). Longitudinal data analysis for discrete and continuous outcomes. *Biometrics*, 42(1), 121-130.

### Reader Agreement Statistics
1. Landis, J. R., & Koch, G. G. (1977). The measurement of observer agreement for categorical data. *Biometrics*, 33(1), 159-174.
2. Fleiss, J. L., Levin, B., & Paik, M. C. (2003). *Statistical Methods for Rates and Proportions* (3rd ed.). Wiley.
3. Shrout, P. E., & Fleiss, J. L. (1979). Intraclass correlations: Uses in assessing rater reliability. *Psychological Bulletin*, 86(2), 420-428.
4. Bland, J. M., & Altman, D. G. (1986). Statistical methods for assessing agreement between two methods of clinical measurement. *Lancet*, 327(8476), 307-310.
5. McGraw, K. O., & Wong, S. P. (1996). Forming inferences about some intraclass correlation coefficients. *Psychological Methods*, 1(1), 30-46.

---

*Last updated: 2024*