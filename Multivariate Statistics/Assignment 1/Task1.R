## Task 1
library(rstudioapi)
library(paran)

## Set working directory to the script location
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
load("life.Rdata")

## Standardize
zlife <- scale(life, center = TRUE, scale = TRUE)

## PCA
pca_life <- prcomp(zlife)

# Eigenvalues, proportion and cumulative proportion of explained variance
eigvals <- pca_life$sd^2
round(eigvals, 3)
round(eigvals / ncol(zlife), 3)
round(cumsum(eigvals / ncol(zlife)), 3)

## Horn’s procedure
set.seed(1425) # Set seed for reproducibility (KU LEUVEN's founding year btw)
paran(zlife, iterations = 5000, graph = TRUE,
      cfa = FALSE, centile = 0)

## Loadings
A <- pca_life$rotation %*% diag(pca_life$sd)
round(A, 2)

## Standardized component scores
Z  <- predict(pca_life)
Zs <- Z %*% diag(1 / pca_life$sd)

## Biplot
par(cex = 0.8)
biplot(pca_life, pc.biplot = TRUE,
       xlim = c(-2.6, 2.6),
       ylim = c(-2.6, 2.6))
