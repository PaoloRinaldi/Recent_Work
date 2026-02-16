library(readr)
library(CADFtest)
library(fGarch)
library(forecast)
library(vars)
library(urca)

# PART 1: UNIVARIATE ANALYSIS

# DEFINE THE TIME SERIES AND GIVE THE SOURCE OF THE DATA


# Dataset 1: NextEra Energy daily prices (01/01/2015 - 31/10/2025)
# (for univariate and multivariate analyses) 

NextEra_Energy_Stock_Price_History <- read_csv("C:/Users/Paolo/Desktop/R KUL Courses/Advanced Time Series Analysis/Homework ATSA/NextEra Energy Stock Price Historydaily.csv")
NEE <- NextEra_Energy_Stock_Price_History
NEE

attach(NEE)
Price

Price_NEE_ts <- ts(Price, frequency=1, start=c(2015,1))
print(Price_NEE_ts)
print(summary(Price_NEE_ts))

# LOG-PRICES AND PLOT
logPrice_NEE_ts <- log(Price_NEE_ts)
ts.plot(logPrice_NEE_ts, main="Log-Prices NEE")

# LOG-DIFF PRICES AND PLOT
dlogPrice_NEE_ts <- diff(logPrice_NEE_ts)
ts.plot(dlogPrice_NEE_ts, main="Log-Diff Prices NEE")

# ACF PLOT
acf(dlogPrice_NEE_ts, main="ACF of Log-Diff Prices NEE")

# PACF PLOT
pacf(dlogPrice_NEE_ts, main="PACF of Log-Diff Prices NEE")

# CADF test
max.lag <- round(sqrt(length(logPrice_NEE_ts)))

cadf_logPrice_NEE_ts <- CADFtest(logPrice_NEE_ts, type="trend", criterion="BIC", max.lag.y=max.lag)
print(summary(cadf_logPrice_NEE_ts))

cadf_dlogPrice_NEE_ts <- CADFtest(dlogPrice_NEE_ts, type="drift", criterion="BIC", max.lag.y=max.lag)
print(summary(cadf_dlogPrice_NEE_ts))

# MODEL SELECTION AND TEST 1
fit_arima1_NEE <- arima(logPrice_NEE_ts, order=c(1,1,0))
print(fit_arima1_NEE)
Box.test(fit_arima1_NEE$residuals, lag=max.lag, type="Ljung-Box")

# MODEL SELECTION AND TEST 2
fit_arima2_NEE <- arima(logPrice_NEE_ts, order=c(0,1,1))
print(fit_arima2_NEE)
Box.test(fit_arima2_NEE$residuals, lag=max.lag, type="Ljung-Box")

# MODEL SELECTION AND TEST 3
fit_arima3_NEE <- arima(logPrice_NEE_ts, order=c(1,1,1))
print(fit_arima3_NEE)
Box.test(fit_arima3_NEE$residuals, lag=max.lag, type="Ljung-Box")


# Test for Conditional Heteroskedasticity (to detect ARCH effects)
residuals_sq_NEE <- fit_arima3_NEE$residuals^2
Box.test(residuals_sq_NEE, lag=max.lag, type="Ljung-Box")
# we strongly reject the H0 hyp: squared residuals are white noise
# we grasp that the variance of the returns is not constant over time (conditional heteroskedasticity)
# probably our model would be more accurate if we add GARCH!

fitgarch <- garchFit(formula=~garch(1,1),data=dlogPrice_NEE_ts,include.mean = F)
summary(fitgarch)
# garch model for the variance is validated
# use QMLE because normality is rejected: "assume normality while not believing in normality"
mymodel <- garchFit(formula=~garch(1,1),data=dlogPrice_NEE_ts,include.mean = F, cond.dist = "QMLE")
plot(mymodel) # da capire come plottarlo dal momento che blocca il codice

# MODEL 3 conversion to arma(1,1), in order to mix it with garch
fit_arma11_NEE <- arima(dlogPrice_NEE_ts, order=c(1,0,1))
print(fit_arma11_NEE)
Box.test(fit_arma11_NEE$residuals, lag=max.lag, type="Ljung-Box")

# validation of the chosen model arma + garch
fitarimagarch1 <- garchFit(formula=~arma(1,1)+garch(1,1),data=dlogPrice_NEE_ts, cond.dist="QMLE")
summary(fitarimagarch1)

# forecast using the chosen model arma + garch
fcst_arimagarch <- predict(fitarimagarch1, n.ahead=10)
print(fcst_arimagarch)

expected=fcst_arimagarch$meanForecast
lower=fcst_arimagarch$meanForecast-qnorm(0.975)*fcst_arimagarch$standardDeviation
upper=fcst_arimagarch$meanForecast+qnorm(0.975)*fcst_arimagarch$standardDeviation
cbind(lower,expected,upper)

#forecast using another model arima(1,1,1) in order to perform Diebold-Mariano test
fcst_arima <- predict(fit_arima3_NEE, n.ahead=10)
print(fcst_arima)

expected1=fcst_arima$pred
lower1=fcst_arima$pred-qnorm(0.975)*fcst_arima$se
upper1=fcst_arima$pred+qnorm(0.975)*fcst_arima$se
cbind(lower1,expected1,upper1)

#forecast using another model arma(1,1) in order to perform Diebold-Mariano test
fcst_arma11 <- predict(fit_arma11_NEE, n.ahead=10)
print(fcst_arma11)

expected2=fcst_arma11$pred
lower2=fcst_arma11$pred-qnorm(0.975)*fcst_arma11$se
upper2=fcst_arma11$pred+qnorm(0.975)*fcst_arma11$se
cbind(lower2,expected2,upper2)

# we can finally start the Diebold-Mariano test
y <- dlogPrice_NEE_ts
S <- round(0.75*length(y))
h <- 1

# model 1 (arma(1,1)+garch(1,1))
error1.h <- c()
for (i in S:(length(y)-h))
{
  predict.h <- predict(fitarimagarch1, n.ahead=h)$meanForecast[h]
  error1.h <- c(error1.h, y[i+h] - predict.h)
}

# model 2 (arma(1,1))
error2.h <- c()
for (i in S:(length(y)-h))
{
  predict.h <- predict(fit_arma11_NEE, n.ahead=h)$pred[h]
  error2.h <- c(error2.h, y[i+h] - predict.h)
}

# MAE
MAE1 <- mean(abs(error1.h))
MAE2 <- mean(abs(error2.h))
print(paste("MAE arma(1,1)+garch(1,1) model:", MAE1))
print(paste("MAE arma(1,1) model:", MAE2))

# actual Diebold-Mariano test
dm.test(error1.h, error2.h, h=h, power=1)

# -------------------------------------------------------

# PART 2: MULTIVARIATE ANALYSIS

# Dataset 2: Exxon Mobil daily prices (01/01/2015 - 31/10/2025)
# (only for multivariate analysis) 

Exxon_Mobil_Stock_Price_History <- read_csv("Exxon Mobil Stock Price Historydaily.csv")
XOM <- Exxon_Mobil_Stock_Price_History
XOM

attach(XOM)
Price

Price_XOM_ts <- ts(Price, frequency=1, start=c(2015,1))
print(Price_XOM_ts)
print(summary(Price_XOM_ts))

# LOG-PRICES AND PLOT
logPrice_XOM_ts <- log(Price_XOM_ts)
ts.plot(logPrice_XOM_ts, main="Log-Prices XOM")

# LOG-DIFF PRICES AND PLOT
dlogPrice_XOM_ts <- diff(logPrice_XOM_ts)
ts.plot(dlogPrice_XOM_ts, main="Log-Diff Prices XOM")

# we create the dataframe in log-levels
logPricedata <- data.frame(logPrice_XOM_ts, logPrice_NEE_ts)
names(logPricedata) <- c("logPriceXOM", "logPriceNEE")

# lag selection 
lag_selection <- VARselect(logPricedata, lag.max=10, type="const")
print(lag_selection$selection)

# we select the optimal lag
K_opt <- 2

# we perform the Trace Test
trace_test <- ca.jo(logPricedata, type="trace", K=K_opt, ecdet="const", spec="transitory")
summary(trace_test)

# we perform the Maximum Eigenvalue Test
maxeigen_test <- ca.jo(logPricedata, type="eigen", K=K_opt, ecdet="const", spec="transitory")
summary(maxeigen_test)

# VAR analysis on returns

# we recall the log-diff (the returns)
head(dlogPrice_XOM_ts) 
head(dlogPrice_NEE_ts)

# we create the new dataframe for VAR
dlogPricedata <- data.frame(dlogPrice_XOM_ts, dlogPrice_NEE_ts)
names(dlogPricedata) <- c("dlogPrice_XOM_ts", "dlogPrice_NEE_ts")

# lag selection
var_select <- VARselect(dlogPricedata, lag.max=10, type="const")
print(var_select$selection)

# we select the optimal lag
p_opt <- var_select$selection["SC(n)"]
print(paste("VAR order selected:", p_opt))

# we estimate the VAR model
fit_var <- VAR(dlogPricedata, p=p_opt, type="const")
summary(fit_var)

# Impulse Response Functions (IRF)

# IRF: NEE shock -> XOM response 
irf_nee_xom <- irf(fit_var, impulse="dlogPrice_NEE_ts", response="dlogPrice_XOM_ts", n.ahead=10, boot=TRUE)
plot(irf_nee_xom, main="XOM response to an NEE shock")

# IRF: XOM shock -> NEE response
irf_xom_nee <- irf(fit_var, impulse="dlogPrice_XOM_ts", response="dlogPrice_NEE_ts", n.ahead=10, boot=TRUE)
plot(irf_xom_nee, main="NEE response to a XOM shock")
