# mainly cateloging all the different agreement statistics, pitfalls, r codes, issues

## all the different kappa

any kappa-like statistic does chance-correction, may over correct when distribution is skewed. creating "kappa paradox".


### Cohen/Weighted Cohen

only work with 2 readers, nominal and ordinal (weighted), does not work on continuous

### Conger

extend to 2+ readers, nominal and ordinal (weighted), does not work on continuous

```
irrCAC::conger.kappa.raw(ratings, weights = "quadratic",...)$est
```

### Light's kappa

it just averages across multiple pairwise cohen's kappa. use pairwise complete data when there's NA.

`irr::kappam.light` has no direct CI output
`psy::lkappa` also no CI ouput



## Gwet's AC1 (unweighted), AC2 (weighted)

```{r}
irrCAC::gwet.ac1.raw(ratings, weights = "quadratic",...)$est
```



## ICC

irr::icc does not handle NA well
irrICC::icc2.nointer.fn does not handle NA well

psych::ICC calculate ICC1/2/3 with CI in one go



## krippendorff alpha

## CCC