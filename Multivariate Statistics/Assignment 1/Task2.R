## Task 2

library(psych)
library(GPArotation)
library(lavaan)
library(rstudioapi)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
load("fsdata.Rdata")

items <- c(
  "FS_pay_bills", "FS_afford_extras", "FS_afford_housing", "FS_save_money",
  "FSF_pay_bills", "FSF_afford_extras", "FSF_afford_housing", "FSF_save_money",
  "SFJ_no_info", "SFJ_no_chance_show", "SFJ_no_training", "SFJ_no_support_findjob",
  "SDJ_help_people", "SDJ_learn_new_things", "SDJ_develop_creativity",
  "SDJ_meet_people", "SDJ_feeling_self_worth",
  "HEALTH_felt_down", "HEALTH_limitation"
)

## standardized / centered versions
fs_complete <- na.omit(fsdata[, c("country", items)])
zfs <- fs_complete
zfs[, items] <- scale(fs_complete[, items], center = TRUE, scale = TRUE)
cfs <- fs_complete
cfs[, items] <- scale(fs_complete[, items], center = TRUE, scale = FALSE)


## 2a
cormat_fs <- cor(zfs[, items])

efa5_obl <- fa(cormat_fs,
               nfactors = 5,
               rotate   = "oblimin",
               fm       = "ml",
               covar    = FALSE,
               n.obs    = nrow(zfs))

efa5_obl
round(efa5_obl$communalities, 3)
print(efa5_obl$Structure, digits = 3, cutoff = 0)
round(efa5_obl$residual, 3)

p <- length(items)
resid <- efa5_obl$residual - diag(diag(efa5_obl$residual))
prop_large_resid <- sum(abs(resid) > 0.05) / (p * (p - 1))
prop_large_resid

## 2b
cfa5 <- '
  FS     =~ NA*FS_pay_bills + FS_afford_extras + FS_afford_housing + FS_save_money
  FSF    =~ NA*FSF_pay_bills + FSF_afford_extras + FSF_afford_housing + FSF_save_money
  SFJ    =~ NA*SFJ_no_info + SFJ_no_chance_show + SFJ_no_training + SFJ_no_support_findjob
  SDJ    =~ NA*SDJ_help_people + SDJ_learn_new_things + SDJ_develop_creativity +
             SDJ_meet_people + SDJ_feeling_self_worth
  HEALTH =~ NA*HEALTH_felt_down + HEALTH_limitation

  FS     ~~ 1*FS
  FSF    ~~ 1*FSF
  SFJ    ~~ 1*SFJ
  SDJ    ~~ 1*SDJ
  HEALTH ~~ 1*HEALTH

  FS     ~~ FSF + SFJ + SDJ + HEALTH
  FSF    ~~ SFJ + SDJ + HEALTH
  SFJ    ~~ SDJ + HEALTH
  SDJ    ~~ HEALTH
'

fit_cfa5 <- cfa(cfa5, data = cfs)

summary(fit_cfa5, fit.measures = TRUE, standardized = TRUE)
fitmeasures(fit_cfa5, c("chisq","df","pvalue","cfi","tli","rmsea","srmr"))

d <- standardizedSolution(fit_cfa5)

compositereliability <- function(lambda) {
  A <- (sum(lambda))^2
  B <- sum(1 - lambda^2)
  A / (A + B)
}

loadings_std <- subset(d, op == "=~", select = c("lhs","rhs","est.std"))
cov_std      <- subset(d, op == "~~" &
                         lhs %in% c("FS","FSF","SFJ","SDJ","HEALTH") &
                         rhs %in% c("FS","FSF","SFJ","SDJ","HEALTH"))

factors <- c("FS","FSF","SFJ","SDJ","HEALTH")
AVE <- CR <- MSV <- numeric(length(factors))

for (i in seq_along(factors)) {
  f <- factors[i]
  lambda_f <- loadings_std$est.std[loadings_std$lhs == f]
  AVE[i]   <- mean(lambda_f^2)
  CR[i]    <- compositereliability(lambda_f)
  
  cor_f <- cov_std$est.std[cov_std$lhs == f & cov_std$lhs != cov_std$rhs]
  MSV[i] <- if (length(cor_f) > 0) max(cor_f^2) else 0
}

report <- data.frame(
  Factor = factors,
  AVE    = round(AVE, 3),
  MSV    = round(MSV, 3),
  CR     = round(CR, 3)
)
report


## 2c
mod_cfa5 <- modificationIndices(fit_cfa5)
mod_errors <- subset(mod_cfa5, op == "~~" &
                       lhs %in% items &
                       rhs %in% items &
                       lhs != rhs)
head(mod_errors[order(mod_errors$mi, decreasing = TRUE), ], 20)

cfa5_mod <- '
  FS     =~ NA*FS_pay_bills + FS_afford_extras + FS_afford_housing + FS_save_money
  FSF    =~ NA*FSF_pay_bills + FSF_afford_extras + FSF_afford_housing + FSF_save_money
  SFJ    =~ NA*SFJ_no_info + SFJ_no_chance_show + SFJ_no_training + SFJ_no_support_findjob
  SDJ    =~ NA*SDJ_help_people + SDJ_learn_new_things + SDJ_develop_creativity +
             SDJ_meet_people + SDJ_feeling_self_worth
  HEALTH =~ NA*HEALTH_felt_down + HEALTH_limitation

  FS     ~~ 1*FS
  FSF    ~~ 1*FSF
  SFJ    ~~ 1*SFJ
  SDJ    ~~ 1*SDJ
  HEALTH ~~ 1*HEALTH

  FS     ~~ FSF + SFJ + SDJ + HEALTH
  FSF    ~~ SFJ + SDJ + HEALTH
  SFJ    ~~ SDJ + HEALTH
  SDJ    ~~ HEALTH

  FSF_afford_extras  ~~ FSF_save_money
'

fit_cfa5_mod <- cfa(cfa5_mod, data = cfs)

summary(fit_cfa5_mod, fit.measures = TRUE, standardized = TRUE)
fitmeasures(fit_cfa5_mod, c("chisq","df","pvalue","cfi","tli","rmsea","srmr"))


## 2d
sem_base <- '
  FS     =~ NA*FS_pay_bills + FS_afford_extras + FS_afford_housing + FS_save_money
  FSF    =~ NA*FSF_pay_bills + FSF_afford_extras + FSF_afford_housing + FSF_save_money
  SFJ    =~ NA*SFJ_no_info + SFJ_no_chance_show + SFJ_no_training + SFJ_no_support_findjob
  SDJ    =~ NA*SDJ_help_people + SDJ_learn_new_things + SDJ_develop_creativity +
             SDJ_meet_people + SDJ_feeling_self_worth
  HEALTH =~ NA*HEALTH_felt_down + HEALTH_limitation

  FS     ~~ 1*FS
  FSF    ~~ 1*FSF
  SFJ    ~~ 1*SFJ
  SDJ    ~~ 1*SDJ
  HEALTH ~~ 1*HEALTH

  FS     ~~ FSF + SFJ + SDJ + HEALTH
  FSF    ~~ SFJ + SDJ + HEALTH
  SFJ    ~~ SDJ + HEALTH
  SDJ    ~~ HEALTH

  FSF_afford_extras  ~~ FSF_save_money

  FS ~ FSF + SFJ + SDJ + HEALTH
'

sem_base_eqReg <- '
  FS     =~ NA*FS_pay_bills + FS_afford_extras + FS_afford_housing + FS_save_money
  FSF    =~ NA*FSF_pay_bills + FSF_afford_extras + FSF_afford_housing + FSF_save_money
  SFJ    =~ NA*SFJ_no_info + SFJ_no_chance_show + SFJ_no_training + SFJ_no_support_findjob
  SDJ    =~ NA*SDJ_help_people + SDJ_learn_new_things + SDJ_develop_creativity +
             SDJ_meet_people + SDJ_feeling_self_worth
  HEALTH =~ NA*HEALTH_felt_down + HEALTH_limitation

  FS     ~~ 1*FS
  FSF    ~~ 1*FSF
  SFJ    ~~ 1*SFJ
  SDJ    ~~ 1*SDJ
  HEALTH ~~ 1*HEALTH

  FS     ~~ FSF + SFJ + SDJ + HEALTH
  FSF    ~~ SFJ + SDJ + HEALTH
  SFJ    ~~ SDJ + HEALTH
  SDJ    ~~ HEALTH

  FSF_afford_extras  ~~ FSF_save_money

  FS ~ a1*FSF + a2*SFJ + a3*SDJ + a4*HEALTH
'

fit_conf_free    <- sem(sem_base,       data = cfs, group = "country")
fit_conf_eqReg   <- sem(sem_base_eqReg, data = cfs, group = "country")
fit_metric_free  <- sem(sem_base,       data = cfs, group = "country",
                        group.equal = "loadings")
fit_metric_eqReg <- sem(sem_base_eqReg, data = cfs, group = "country",
                        group.equal = "loadings")

fm_conf_free    <- fitmeasures(fit_conf_free,
                               c("chisq","df","pvalue","cfi","tli","rmsea","srmr","aic","bic"))
fm_conf_eqReg   <- fitmeasures(fit_conf_eqReg,
                               c("chisq","df","pvalue","cfi","tli","rmsea","srmr","aic","bic"))
fm_metric_free  <- fitmeasures(fit_metric_free,
                               c("chisq","df","pvalue","cfi","tli","rmsea","srmr","aic","bic"))
fm_metric_eqReg <- fitmeasures(fit_metric_eqReg,
                               c("chisq","df","pvalue","cfi","tli","rmsea","srmr","aic","bic"))

round(rbind(
  config_free_reg   = fm_conf_free,
  config_equal_reg  = fm_conf_eqReg,
  metric_free_reg   = fm_metric_free,
  metric_equal_reg  = fm_metric_eqReg
), 3)

anova(fit_conf_free,   fit_conf_eqReg)
anova(fit_conf_free,   fit_metric_free)
anova(fit_metric_free, fit_metric_eqReg)

# fit_conf_eqReg performed best
std_final <- standardizedSolution(fit_conf_eqReg)
std_final[std_final$op == "~" & std_final$lhs == "FS", ]
