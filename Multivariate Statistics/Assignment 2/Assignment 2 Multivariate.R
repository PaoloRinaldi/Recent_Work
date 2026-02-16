library(rstudioapi)
library(paran)
library(MASS)
library(class)
library(gbm)


# Standardize

ztrains1 <- scale(train.data.s1, center=TRUE, scale=TRUE)
ztrains2 <- scale(train.data.s2, center=TRUE, scale=TRUE)

# pca > 0.90 scenario 1

pca_s1 <- prcomp(train.data.s1)

prop_var_s1 <- summary(pca_s1)$importance[3, ] 
num_comp_s1 <- min(which(prop_var_s1 >= 0.90))

num_comp_s1

# pca > 0.90 scenario 2

pca_s2 <- prcomp(train.data.s2)

prop_var_s2 <- summary(pca_s2)$importance[3, ] 
num_comp_s2 <- min(which(prop_var_s2 >= 0.90))

num_comp_s2

# train and test scenario 1

train_pca_s1 <- pca_s1$x[, 1:num_comp_s1]
test_pca_s1 <- predict(pca_s1, newdata = test.data)[, 1:num_comp_s1]

train_pca_s1
test_pca_s1

# train and test scenario 2

train_pca_s2 <- pca_s2$x[, 1:num_comp_s2]
test_pca_s2 <- predict(pca_s2, newdata = test.data)[, 1:num_comp_s2]

train_pca_s2
test_pca_s2

# !!! SCENARIO 1 !!!

# first, we transform train and test data in dataframe

train_df_s1 <- data.frame(train_pca_s1, y = train.target.s1)
test_df_s1  <- data.frame(test_pca_s1,  y = test.target)

# FIT LDA MODEL on scenario 1 and provide confusion matrix and classification error

lda.out.s1 <- lda(y ~ ., data = train_df_s1)
pred.lda.s1 <- predict(lda.out.s1, train_df_s1)
table_train_s1 <- table(observed = train_df_s1$y, predicted = pred.lda.s1$class)
print(table_train_s1)

# err Gemini's method 

err_train_lda_s1 <- mean(pred.lda.s1$class != train_df_s1$y)
err_train_lda_s1

# err Professor's method

1-sum(diag(table_train_s1))/sum(table_train_s1)

# FIT QDA MODEL on scenario 1 and provide confusion matrix and classification error

qda.out.s1<-qda(y ~ ., data = train_df_s1)
pred.qda.s1 <- predict(qda.out.s1, train_df_s1)
table_train_qda_s1 <- table(observed = train_df_s1$y, predicted = pred.qda.s1$class)
print(table_train_qda_s1)

# err Gemini's method 

err_train_qda_s1 <- mean(pred.qda.s1$class != train_df_s1$y)
err_train_qda_s1

# err Professor's method

1-sum(diag(table_train_qda_s1))/sum(table_train_qda_s1)