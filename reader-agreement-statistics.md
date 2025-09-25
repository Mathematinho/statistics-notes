# Reader Agreement Statistics

## Comprehensive Guide to Inter-Rater Reliability and Agreement

### Introduction

Reader agreement statistics are essential tools for assessing the reliability and consistency of measurements when multiple observers, raters, or measurement methods are involved. This guide covers the most important agreement statistics, their appropriate use cases, interpretations, and practical considerations.

## Types of Data and Corresponding Statistics

### For Categorical Data
- **Cohen's Kappa** (2 raters)
- **Weighted Kappa** (2 raters, ordered categories)
- **Fleiss' Kappa** (multiple raters)

### For Continuous Data
- **Intraclass Correlation Coefficient (ICC)**
- **Bland-Altman Analysis**
- **Limits of Agreement**

## Categorical Data Agreement

### Cohen's Kappa (κ)

**Purpose:** Measures agreement between two raters for categorical data, correcting for chance agreement.

**Formula:**
```
κ = (Po - Pe) / (1 - Pe)
```

Where:
- **Po** = Observed proportional agreement = Σ(diagonal)/N
- **Pe** = Expected proportional agreement by chance = Σ(marginal products)/N²

**Step-by-step calculation example:**

Suppose two radiologists rate 100 X-rays as Normal/Abnormal:

|           | Rater 2 Normal | Rater 2 Abnormal | Total |
|-----------|----------------|------------------|-------|
| **Rater 1 Normal** | 60 | 10 | 70 |
| **Rater 1 Abnormal** | 5 | 25 | 30 |
| **Total** | 65 | 35 | 100 |

1. **Observed agreement:** Po = (60 + 25)/100 = 0.85
2. **Expected agreement by chance:** 
   - Pe = [(70×65) + (30×35)]/100² = (4550 + 1050)/10000 = 0.56
3. **Kappa:** κ = (0.85 - 0.56)/(1 - 0.56) = 0.29/0.44 = 0.66

**Interpretation Guidelines (Landis & Koch, 1977):**
- **< 0.00:** Poor agreement (worse than chance)
- **0.00-0.20:** Slight agreement  
- **0.21-0.40:** Fair agreement
- **0.41-0.60:** Moderate agreement
- **0.61-0.80:** Substantial agreement
- **0.81-1.00:** Almost perfect agreement

**Alternative Interpretation (Fleiss, 1981):**
- **< 0.40:** Poor agreement
- **0.40-0.75:** Fair to good agreement
- **> 0.75:** Excellent agreement

### The Prevalence Paradox

**Problem:** Kappa can be misleadingly low even with high observed agreement when:
1. One category is much more prevalent than others
2. Marginal distributions are very unbalanced

**Example:**
- 95% agreement between raters
- But if 95% of cases are in one category, chance agreement is also ~95%
- Results in very low kappa despite high observed agreement

**Solutions:**
1. Report both kappa and observed agreement
2. Use prevalence-adjusted kappa: PABAK = 2×Po - 1
3. Consider alternative measures like Gwet's AC1

### Weighted Kappa

**Purpose:** Accounts for the degree of disagreement in ordered categorical data.

**When to use:**
- Ordered categories (mild/moderate/severe)
- Some disagreements are more serious than others
- Want to give partial credit for near-agreement

**Weighting schemes:**
1. **Linear weights:** w_ij = 1 - |i-j|/(k-1)
2. **Quadratic weights:** w_ij = 1 - (i-j)²/(k-1)²

**Example:** 3-point severity scale (Mild/Moderate/Severe)
- Mild vs Moderate disagreement: less serious
- Mild vs Severe disagreement: more serious

**Linear weights matrix:**
|       | Mild | Moderate | Severe |
|-------|------|----------|--------|
| **Mild** | 1.0 | 0.5 | 0.0 |
| **Moderate** | 0.5 | 1.0 | 0.5 |
| **Severe** | 0.0 | 0.5 | 1.0 |

### Fleiss' Kappa

**Purpose:** Extension of Cohen's kappa for multiple raters (≥3).

**Key features:**
- All raters don't need to rate all subjects
- Provides single overall agreement measure
- Accounts for chance agreement

**Formula:**
```
κ = (P̄ - P̄e) / (1 - P̄e)
```

Where:
- P̄ = Mean pairwise agreement across all subjects
- P̄e = Mean expected chance agreement

**When to use:**
- 3 or more raters
- Each subject rated by same number of raters (but can be subset)
- Want single agreement statistic

**Limitations:**
- Assumes raters are exchangeable (no systematic differences)
- Less informative than individual pairwise kappas
- May mask individual rater problems

## Continuous Data Agreement

### Intraclass Correlation Coefficient (ICC)

**Purpose:** Measures consistency and agreement for continuous measurements.

**Conceptual framework:**
ICC represents the proportion of variance due to between-subject differences:
```
ICC = σ²_between / (σ²_between + σ²_within)
```

### Types of ICC

#### ICC(1,1): One-way random effects, single measurement
- **Use case:** Each subject rated by different set of raters from larger population
- **Model:** Y_ij = μ + b_i + e_ij
- **Interpretation:** Reliability of single rating from randomly selected rater

#### ICC(2,1): Two-way random effects, single measurement  
- **Use case:** Each subject rated by same set of raters, raters are random sample
- **Model:** Y_ij = μ + b_i + r_j + e_ij
- **Interpretation:** Reliability of single rating, removing rater effects

#### ICC(3,1): Two-way fixed effects, single measurement
- **Use case:** Each subject rated by same fixed set of raters
- **Model:** Y_ij = μ + b_i + r_j + e_ij (but rater effects are fixed)
- **Interpretation:** Reliability for these specific raters only

### ICC Interpretation

**General guidelines:**
- **< 0.50:** Poor reliability
- **0.50-0.75:** Moderate reliability  
- **0.75-0.90:** Good reliability
- **> 0.90:** Excellent reliability

**Context-specific considerations:**
- **Clinical measurements:** Often want ICC > 0.80
- **Research instruments:** ICC > 0.70 often acceptable
- **High-stakes decisions:** May require ICC > 0.90

### ICC vs Pearson Correlation

**Pearson correlation:**
- Measures linear association
- Invariant to linear transformations
- Can be high even with systematic bias

**ICC:**
- Measures both consistency and agreement
- Sensitive to systematic differences
- More appropriate for agreement studies

**Example:**
- If Rater 1 always rates 10 points higher than Rater 2
- Pearson r might be 0.95 (high correlation)
- ICC might be 0.60 (moderate agreement due to systematic bias)

### Bland-Altman Analysis

**Purpose:** Assess agreement between two continuous measurement methods.

**Components:**
1. **Difference plot:** Plot of differences vs averages
2. **Mean difference (bias):** Systematic error
3. **Limits of agreement:** Mean ± 1.96 × SD of differences
4. **95% of differences fall within these limits**

**Interpretation:**
- **Bias close to 0:** No systematic difference
- **Narrow limits:** Good precision
- **Random scatter:** No systematic patterns
- **Outliers:** Investigate unusual cases

**Clinical significance:**
- Are the limits of agreement clinically acceptable?
- Example: Blood pressure measurement methods
  - Limits of ±10 mmHg might be acceptable
  - Limits of ±30 mmHg would not be

### Advanced Bland-Altman Considerations

**Proportional bias:**
- Differences change with magnitude of measurement
- Solution: Use proportional limits or log transformation

**Repeated measurements:**
- Multiple measurements per subject-method combination
- Use mixed effects models for Bland-Altman

**More than two methods:**
- Pairwise comparisons
- Multiple comparisons corrections

## Practical Implementation

### Sample Size Planning

**For Kappa:**
- Generally need ≥50 subjects for stable estimates
- More subjects needed when prevalence is extreme
- Consider confidence interval width rather than just significance

**For ICC:**
- Depends on:
  - Number of raters (k)
  - Expected ICC value
  - Desired confidence interval width

**Sample size formula for ICC (approximate):**
```
n ≈ 2(1-ICC)² × (z_α/2 + z_β)² / (w²ICC²)
```

Where w is desired confidence interval half-width.

### Software Implementation

#### R Examples

**Cohen's Kappa:**
```r
library(irr)
kappa2(cbind(rater1, rater2))

# With weights
kappa2(cbind(rater1, rater2), weight = "linear")
```

**Fleiss' Kappa:**
```r
library(irr)
kappam.fleiss(ratings_matrix)
```

**ICC:**
```r
library(psych)
ICC(ratings_data, type = "ICC3", unit = "single")

# or using irr package
library(irr)
icc(ratings_data, model = "twoway", type = "agreement", unit = "single")
```

**Bland-Altman:**
```r
library(BlandAltmanLeh)
bland.altman.plot(method1, method2)

# or manually
differences <- method1 - method2
means <- (method1 + method2) / 2
plot(means, differences)
abline(h = mean(differences), col = "red")
abline(h = mean(differences) + 1.96*sd(differences), col = "blue", lty = 2)
abline(h = mean(differences) - 1.96*sd(differences), col = "blue", lty = 2)
```

### Confidence Intervals

**Always report confidence intervals:**
- Indicate precision of agreement estimates
- Help distinguish between poor agreement and imprecise estimation
- Essential for sample size planning

**Bootstrap confidence intervals:**
- Useful when analytical formulas complex
- Particularly helpful for weighted kappa, ICC

### Common Pitfalls and Solutions

#### 1. Prevalence Effects
**Problem:** Low kappa despite high agreement when categories are imbalanced
**Solutions:**
- Report observed agreement alongside kappa
- Use prevalence-adjusted measures (PABAK, AC1)
- Consider clinical significance of disagreements

#### 2. Missing Data
**Problem:** Different handling can affect results substantially
**Solutions:**  
- Report missing data patterns
- Use appropriate missing data methods
- Sensitivity analyses with different assumptions

#### 3. Rater Effects
**Problem:** Systematic differences between raters
**Solutions:**
- Training and calibration exercises
- Monitor individual rater performance
- Consider random vs fixed effects models

#### 4. Category Definition
**Problem:** Poorly defined categories lead to poor agreement
**Solutions:**
- Clear operational definitions
- Training materials and examples
- Regular calibration exercises

#### 5. Multiple Comparisons
**Problem:** Multiple agreement statistics without adjustment
**Solutions:**
- Pre-specify primary agreement measure
- Adjust for multiple comparisons when appropriate
- Focus on confidence intervals rather than p-values

## Study Design Considerations

### Rater Selection
- **Training requirements:** Standardized protocols
- **Experience level:** Match to study objectives  
- **Independence:** Avoid influence between raters
- **Blinding:** To subject characteristics when possible

### Data Collection
- **Balanced design:** Equal numbers across categories when possible
- **Random ordering:** Prevent order effects
- **Adequate sample:** Represent target population
- **Quality control:** Monitor data collection process

### Analysis Plan
- **Primary measure:** Pre-specify based on data type and research question
- **Secondary measures:** Additional perspectives on agreement
- **Subgroup analyses:** Different populations or conditions
- **Sensitivity analyses:** Assess robustness of conclusions

## Reporting Guidelines

### Essential Elements
1. **Study design:** Rater characteristics, training, blinding
2. **Data description:** Sample size, missing data, category prevalences
3. **Agreement measures:** Appropriate for data type, with confidence intervals
4. **Clinical interpretation:** Practical significance of agreement levels
5. **Limitations:** Acknowledge assumptions and limitations

### Example Reporting Template

> "Two experienced radiologists independently reviewed 150 chest X-rays for presence of pneumonia. Raters were blinded to clinical information and previous readings. Inter-rater agreement was assessed using Cohen's kappa. 
>
> Agreement was substantial (κ = 0.72, 95% CI: 0.61-0.83) with 89% observed agreement. The prevalence of pneumonia was 32% (48/150 cases). Three cases had missing ratings due to technical issues and were excluded from analysis.
>
> This level of agreement suggests that either radiologist could reliably identify pneumonia, though the confidence interval indicates some uncertainty in the agreement estimate."

---

## Summary Decision Tree

### Choosing the Right Statistic

**Data Type:**
- **Categorical** → Kappa family
- **Continuous** → ICC or Bland-Altman

**Number of Raters:**
- **Two raters, categorical** → Cohen's kappa
- **Multiple raters, categorical** → Fleiss' kappa  
- **Multiple raters, continuous** → ICC

**Ordered Categories:**
- **Yes** → Weighted kappa
- **No** → Regular kappa

**Research Focus:**
- **Reliability** → ICC
- **Agreement between methods** → Bland-Altman
- **Classification accuracy** → Kappa

**Remember:** Multiple measures often provide complementary information - consider reporting several when appropriate.

## Advanced Topics

### Alternative Agreement Measures
- **Gwet's AC coefficients:** Less affected by prevalence
- **Brennan & Prediger coefficients:** Different chance correction
- **Scott's Pi:** Alternative to Cohen's kappa

### Longitudinal Agreement
- **Repeated measurements:** Mixed effects approaches
- **Learning curves:** Agreement changes over time
- **Drift detection:** Monitoring agreement stability

### Multilevel Agreement
- **Nested data:** Students in schools, patients in hospitals
- **Cross-classified:** Multiple crossing factors
- **Hierarchical models:** Account for multiple levels

This comprehensive guide provides the foundation for understanding and applying reader agreement statistics appropriately in research and practice.