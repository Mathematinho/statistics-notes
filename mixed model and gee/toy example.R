library(tidyverse)
library(lmerTest)
library(geepack)
library(MRMCaov)
library(gtsummary)

show_est <- function(x,label_name){
  tbl_regression(x,conf.int=F,
                 label = score ~ label_name)%>%
    modify_column_unhide(column = std.error)
}

n_reader = 3
n_subject = 100
R=1
modality = c(1,2)

dat <- data.frame(
  ref = rep(rep(rep(c(0,1),c(n_subject*(1-R/(R+1)),n_subject*R/(1+R))),n_reader),length(modality)),
  reader = rep(rep(1:n_reader,each=n_subject),length(modality)),
  mod = rep(modality,each=n_subject*n_reader),
  subject = rep(1:(n_subject),n_reader*length(modality)),
  var_subject = rep(rnorm(n_subject,0,1),n_reader*length(modality)),
  var_reader = rep(rnorm(n_reader,0,.3),each=n_subject) %>% rep(length(modality)),
  var_reader_subject = rnorm(n_subject*n_reader,0,0.1)
  ) %>%
  mutate(fixed = ref + var_subject + 0.5*ref*(modality==2),
         score = fixed + var_reader + var_reader_subject,
         score_clean = fixed) %>%
  mutate(score_avg = mean(score),.by=c(subject,mod)) %>%
  mutate(across(c(reader,subject),factor)) %>% 
  filter(mod == 1) %>%
  mutate(across(c(reader,mod,subject),factor))


# without reader variation, fixed effect only
without_reader_noise <- glm(ref ~ score, data=dat %>% filter(reader==1) %>%
                      select(ref,score = score_clean), family=binomial)
#averaged reader
avg_fit <- glm(ref ~ score, data=dat %>% filter(reader==1) %>%
                 select(ref,score = score_avg), family=binomial)
#ignore random effects
glm_fit <- glm(ref ~ score, data=dat, family=binomial)

#weight each observation by the number of readers per subject
glm_fit_w <- glm(ref ~ score, data=dat %>% group_by(subject) %>% mutate(n=n()) %>% ungroup() %>% mutate(w=1/n), family=binomial, weights=w)

# wrong specification, wrong estimates, does not converge
#lmer_fit1 <- glmer(ref ~ score + (1|reader)  + (1 | subject), data=dat, family=binomial)

# model random reader but not random cases
lmer_fit21 <- glmer(ref ~ score + (1|reader) , data=dat, family=binomial)
# model random subject but not random readers
lmer_fit22 <- glmer(ref ~ score + (1|subject) , data=dat, family=binomial)
#correct model but reversed association
lmer_fit3 <- lmer(score ~ ref + (1|reader)  + (1 | subject), data=dat)

# GEE model
#cluster within subjects
gee_fit1 <- geeglm(ref ~ score, id=subject, data=dat %>% arrange(subject,reader), family=binomial, corstr="exchangeable")
#cluster within readers
gee_fit2 <- geeglm(ref ~ score, id=reader, data=dat %>% arrange(reader,subject), family=binomial, corstr="exchangeable")

#hierachical approach

latent_score <- lmer(score ~ (1|reader)  + (1 | subject), data=dat) 
#predict as average reader
dat$pred_score <- predict(latent_score, re.form=~(1 | subject))
hier_fit <- glm(ref ~ score, data=dat %>% filter(reader==1) %>%
                  select(ref,score = pred_score), family=binomial)

#show all in one table
tbl_stack(list(
  show_est(without_reader_noise,"without reader variation"),
  show_est(avg_fit,"Average reader"),
  show_est(glm_fit,"logistic with no rnd eff"),
  show_est(glm_fit_w,"logistic with no rnd eff, weighted"),
  show_est(lmer_fit21,"logistic with reader only rnd eff"),
  show_est(lmer_fit22,"logistic with subject only rnd eff"),
  show_est(gee_fit1,"GEE with subject cluster"),
  show_est(gee_fit2,"GEE with reader cluster"),
  show_est(hier_fit,"Hierarchical approach")
)
)




