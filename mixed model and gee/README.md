# mixed model and gee

## a special case

there is this common situaion in MRMC design that 

1. we want to study the association between an imaging measurement x and a pathology outcome y
1. the dependent variable $y_case$, that only varies across cases, having the same value for different readers. i.e., y_case has zero across reader variation. 
1. while the independent variable $x$ is a measurement on image that varies across both case and reader.



it is wrong to model as 

```{r}
lmer(y_case ~ x + (1|case) + (1|reader),...
```

Since y_case has no reader variation, (1|case) capture all variation in y_case. effect of x cannot be estimated.

```{r}
lmer(x ~ y_case + (1|case) + (1|reader),...
```

correctly models the reverse relationship. How much change in x, on average, associated with one unit change in y


---

it is also no appropriate to model

```{r}
lmer(y_case ~ x + (1|reader),...
```
and

```{r}
lm(y_case ~ x,...
```
both give same results on $x$. Because there is no reader variance in y_case, the random effect (1|reader) has variance 0.

all case*reader rows are considered as independent, it loose the MRMC design.

best case senario with fully cross-design it may underestimate standard error. worst case senario, with severe missing data, may be bias as well.


---

GEE approach 

```{r}
geepack::geeglm(y_case ~ x, id = case,...
```
this is wrong. when using case as cluster, there is no variation within cluster.


```{r}
geepack::geeglm(y_case ~ x, id = reader,...
```
this is then correctly adjust clustering of reader. it estimates the correlation matrix within each reader (n_cases × n_cases)




---

hierachical/latent variable approach (from chat gpt)

assume there is an underlying unobservable true $x$, $x_{true}$. it can be estimated using 

```{r}
lmer(x ~ (1|reader) + (1|case),...
```

then, we can predict $x_{true}^{hat}$ as $pred(x|case)$. i.e. predict the latent x value by conditioning on case, (for an average reader). 

note: this is "for an average reader" (or for the latent true x), different than GEE (for any random reader).

then use

```{r}
lm(y ~ x_true^hat,...
```

to estimate the association between y and the latent x. This approach removes the reader variance instead of consider it as noise in GEE. should have smaller standard error.

---

aggregating can also be an option

calculate reader average x for each case, then

```{r}
lm(y ~ x_avg,...)
```

complete ignore reader variation, but focus on association.





























