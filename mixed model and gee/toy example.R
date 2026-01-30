library(tidyverse)
library(lmerTest)
library(geepack)
library(MRMCaov)

n_reader = 3
n_subject = 100
R=1
modality = c(1,2)

dat <- data.frame(
  ref = rep(rep(rep(c(0,1),c(n_subject*(1-R/(R+1)),n_subject*R/(1+R))),n_reader),length(modality)),
  reader = rep(rep(1:n_reader,each=n_subject),length(modality)),
  mod = rep(modality,each=n_subject*n_reader),
  subject = rep(1:(n_subject),n_reader*length(modality)),
  noise = rnorm(n_subject* n_reader*length(modality),0,0.5),
  var_subject = rep(rnorm(n_subject,0,.5),n_reader*length(modality)),
  var_reader = rep(rnorm(n_reader,0,.5),each=n_subject) %>% rep(length(modality))) %>%
  mutate(score = ref + var_subject + var_reader + 0.5*ref*(mod==2)+noise,
         score_clean = ref + var_subject + 0.5*ref*(mod==2)+noise) %>%
  mutate(across(c(reader,subject),factor))

dat <- dat %>% 
  filter(mod == 1)

# without reader variation
unbiased_fit <- glm(ref ~ score_clean, data=dat %>% filter(reader==1), family=binomial)
summary(unbiased_fit)

#model each reader separately
for (i in 1:n_reader){
  cat("Reader ", i, "\n")
  lmer_fit4 <- glm(ref ~ score, data=dat %>% filter(reader == i), family=binomial)
  print(summary(lmer_fit4))
}


# wrong specification, wrong estimates, does not converge
lmer_fit1 <- glmer(ref ~ score + (1|reader)  + (1 | subject), data=dat, family=binomial)
summary(lmer_fit)

# model random reader but not random cases
lmer_fit21 <- glmer(ref ~ score + (1|reader) , data=dat, family=binomial)
summary(lmer_fit21)

# model random subject but not random readers
lmer_fit22 <- glmer(ref ~ score + (1|subject) , data=dat, family=binomial)
summary(lmer_fit22)

#no random effect adjustment
lmer_fit23 <- glm(ref ~ score, data=dat, family=binomial)
summary(lmer_fit23)

#correct model but reversed association
lmer_fit3 <- lmer(score ~ ref + (1|reader)  + (1 | subject), data=dat)
summary(lmer_fit3)



# GEE model

#cluster within subjects
gee_fit1 <- geeglm(ref ~ score, id=subject, data=dat, family=binomial, corstr="exchangeable")
summary(gee_fit1)

#cluster within readers
gee_fit2 <- geeglm(ref ~ score, id=reader, data=dat, family=binomial, corstr="exchangeable")
summary(gee_fit2)

#hierachical approach

latent_score <- lmer(score ~ (1|reader)  + (1 | subject), data=dat) 
#predict as average reader
dat$pred_score <- predict(latent_score, re.form=~(1 | subject))

hier_fit <- glm(ref ~ pred_score, data=dat %>% filter(reader==1), family=binomial)
summary(hier_fit)

avg_fit <- glm(ref ~ score, data=dat %>% group_by(subject) %>% summarise(score=mean(score), ref=first(ref)), family=binomial)
summary(avg_fit)
