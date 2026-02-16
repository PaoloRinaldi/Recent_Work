<img src="./profilepicture.jpg" width="160" align="right" style="width: 100px; height: 140px; object-fit: cover; margin-left: 20px;">
<div>
  <b><font size="6">Quantitative Analysis Portfolio | Paolo Rinaldi</font></b>
</div>
Welcome to my portfolio! This repository showcases my core projects developed during my ongoing Master’s Degree, with a focus on Statistical Modeling, Machine Learning, Time Series Analysis and Financial Market Analysis.



## 📊 Key Projects

### 1. Machine Learning & Predictive Modeling
Development of a robust classification pipeline to predict the likelihood of loan default for LendingClub borrowers. The project focuses on handling highly imbalanced datasets where the cost of a "False Negative" (failing to identify a default) significantly outweighs other errors.
<br>**Methodology:** 
* Data Engineering: Conducted extensive Feature Selection and encoding for categorical variables. Addressed class imbalance using SMOTE (Synthetic Minority Over-sampling Technique) to improve the minority class representation.
* Model Benchmarking: Implemented and compared multiple architectures, including Logistic Regression, Random Forest, and Extreme Gradient Boosting (XGBoost).
* Hyperparameter Tuning: Optimized model performance via Grid Search and Cross-Validation, focusing on the trade-off between Precision and Recall.
* Evaluation Metrics: Prioritized the Area Under the Precision-Recall Curve (AUPRC) and Recall score over simple Accuracy to ensure the model effectively captures high-risk profiles.
* Key Insight: The XGBoost model combined with SMOTE achieved the best balance, significantly reducing potential financial losses by identifying 85% of high-risk defaults during the testing phase.
* **Tools:** Python (Scikit-learn, XGBoost, Pandas, Matplotlib/Seaborn), Jupyter Notebook
* **Full Presentation:** [View PDF Report](./Machine%20Learning/MachineLearning_Exam_Rinaldi.pdf)
* **Full Python script:** [View Script](./Machine%20Learning/MachineLearning_Exam_Rinaldi.ipynb)

![ML Preview](./Machine%20Learning/GIF_MachineLearning.gif)

### 2. Portfolio Management
A comprehensive financial analysis project focused on the valuation of one equity asset (Apollo Global Management) and the strategic construction of an investment portfolio.
<br>**Methodology:** 
* Technical Analysis & Momentum Strategies: Implemented a suite of technical indicators including Bollinger Bands, Relative Strength Index (RSI), Moving Average Convergence Divergence (MACD), and Stochastic Oscillators to identify mean-reversion and momentum trends.
* Fundamental Equity Valuation: Developed multi-stage valuation models, including Dividend Discount Models (DDM), Free Cash Flow to Firm (FCFF), and Residual Income models. Conducted sensitivity analysis and Monte Carlo Simulations to estimate the intrinsic value under stochastic uncertainty.
* Forecasting Techniques: Applied Holt’s Linear Trend and ETS (Error, Trend, Seasonal) models for Earnings Per Share (EPS) and sales forecasting, enabling data-driven growth projections.
* Advanced Portfolio Optimization: Utilized the Black-Litterman Model to combine market equilibrium with subjective investor views, allowing for a more robust asset allocation compared to standard Mean-Variance optimization.
* Key Insight: By integrating quantitative technical signals with probabilistic fundamental valuation (Monte Carlo), the framework identifies "mispriced" securities where technical momentum aligns with significant fundamental upside.
* **Tools:** Microsoft Excel (Advanced Modeling, Excel Solver, Monte Carlo Simulation, Black-Litterman Framework)
* **Full Presentation:** [View PDF Report](./Portfolio%20Management/Rinaldi_Paolo_PP_Topics_in_Portfolio_mgmt20.06.25.pdf)
* **Full Excel File:** [View File](./Portfolio%20Management/Rinaldi_Paolo_Excel_Topics_in_Portfolio_Mgmt20.06.25.xlsx)

![Portfolio Mgmt Preview](./Portfolio%20Management/Gif_PortfolioManagement.gif)


### 3. Advanced Time Series Analysis (ATSA)
A comparative study between NextEra Energy (NEE), a leader in renewable energy, and ExxonMobil (XOM), representing the traditional oil & gas sector. The analysis covers a 10-year daily price horizon (2015–2025) to identify market leadership and short-term interactions
<br>**Methodology:** 
* Univariate Modeling: Conducted stationarity testing via Augmented Dickey-Fuller (ADF) and implemented $ARMA(1,1) + GARCH(1,1)$ models to capture conditional heteroskedasticity and volatility persistence. 
* Forecasting Evaluation: Applied the Diebold-Mariano test to evaluate the predictive accuracy of volatility-adjusted models against simpler linear specifications. 
* Multivariate Dynamics: Performed Johansen Cointegration tests to check for long-run equilibrium. 
* Causality & Spillovers: Developed a Vector Autoregression (VAR) model to assess lead-lag relationships, discovering that NEE significantly Granger-causes XOM returns, suggesting a portfolio rebalancing effect in the energy market. 
* Key Insight: The study highlights a clear informational asymmetry where green energy performance acts as a leading indicator for traditional energy sector sell-offs.
* **Tools:** R (urca, vars, fGarch, forecast), Time Series Forecasting.
* **Full Presentation:** [View PDF Report](./Advanced%20Time%20Series%20Analysis/Powepoint_Homework_ATSA_Rinaldi_2025.pdf)
* **Full R script:** [View Script](./Advanced%20Time%20Series%20Analysis/Homework_Rscript.R)

![ATSA Preview](./Advanced%20Time%20Series%20Analysis/GIF_ATSA.gif)


### 4. Multivariate Statistics (MVS)
Two different group projects.
* **First project:** Identification of latent dimensions in consumer preferences and the study of correlations between distinct sets of multivariate variables.
<br>**Methodology:**
* Principal Component Analysis (PCA): Used to reduce dimensionality and visualize data variance.
* Exploratory Factor Analysis (EFA): Applied with Varimax rotation to extract interpretable latent factors from raw survey data.
* Canonical Correlation Analysis (CCA): Employed to analyze the maximal correlation between two different sets of variables (e.g., behavioral vs. demographic data).
* Key Findings: successfully condensed high-dimensional data into a few key latent factors that explain the majority of the variance; identified significant "Canonical Variates" that highlight how specific groups of independent variables drive outcomes in the dependent set.
* **Full Report:** [View PDF Report](./Multivariate%20Statistics/Assignment%201/MVS_Assignment_1.pdf)
* **Full R script:** [View Script](./Multivariate%20Statistics/Assignment%201/Task1.R) ; [View Script](./Multivariate%20Statistics/Assignment%201/Task2.R)

* **Second project:** Classification of observations into homogeneous groups and the geometric representation of complex distances.
<br>**Methodology:** 
* Cluster Analysis: Implemented both Hierarchical Clustering (using Ward's method) and Non-hierarchical Clustering (K-means) to segment the dataset.
* Cluster Validation: Used Silhouette plots and statistical indices to determine the optimal number of clusters.
* Multidimensional Scaling (MDS) & PCoA: Applied to project non-Euclidean distance matrices into a 2D space for intuitive visualization of similarities/dissimilarities.
* Key Findings: identified robust clusters of observations (e.g., countries or consumers) sharing distinct socio-economic or behavioral profiles; the MDS mapping provided a clear visual representation of the "distance" between entities, revealing hidden proximity patterns that were not visible in the original high-dimensional space.
* **Full Report:** [View PDF Report](./Multivariate%20Statistics/Assignment%202/MVS_Assignment_2.pdf)
* **Full R script:** [View Script](./Multivariate%20Statistics/Assignment%202/Assignment%202%20Multivariate.R)

* **Tools:** R (psych, GPArotation, CCA, cluster, factoextra, vegan, ggplot2, tidyverse, corrplot)

![MVS Preview](./Multivariate%20Statistics/GIF_MVS.gif)


### 5. Optimization & Linear Programming
Developed a mathematical optimization model to determine the most profitable allocation of capital across a diverse set of mortgage and loan applications. The goal was to select an optimal portfolio that maximizes expected interest income while staying within strict risk tolerance thresholds.
<br>**Methodology:** 
* Integer & Linear Programming: Formulated the selection process as a Mixed-Integer Linear Programming (MILP) problem, where decision variables represent the acceptance or rejection of specific loan applications.
* Objective Function: Designed to maximize the total expected net return, accounting for interest rates and expected loss distributions (derived from credit scoring models).
* Constraint Engineering: Implemented complex financial constraints, including total budget limits, diversification requirements across different risk grades, and a maximum allowable "Average Probability of Default" for the entire portfolio.
* Solver Integration: Utilized Gurobi to solve large-scale optimization instances, ensuring the identification of the global optimal solution among thousands of possible combinations.
* Key Insight: The optimization framework demonstrated how a data-driven allocation strategy can outperform traditional "rule-of-thumb" lending by precisely balancing the trade-off between high-yield/high-risk assets and stable/low-return mortgages.
* **Tools:** Python (Gurobi Optimizer, Pandas, NumPy).
* **Full Report:** [View PDF Report](./Alorithms%20for%20Optimization/LinearProgramming_presentation.pdf)
* **Full Python script:** [View Script](./Alorithms%20for%20Optimization/LinearProgramming_exam.ipynb)

![Algorithms and LP Preview](./Alorithms%20for%20Optimization/GIF_AlgorithmsforOpt.gif)


---

## 🛠 Technical Stack
* **Languages and Softwares:** Python, R, Excel, Powerpoint, Latex
* **Specialties:** Time Series Analysis, Machine Learning for Regression and Classification, Technical and Fundamental Analysis of stocks, Linear Programming
* **Soft Skills:** Data visualization, Quantitative reporting, Problem solving, Oral presentation

---

## 📫 Contact Me
* **LinkedIn:** [https://www.linkedin.com/in/paolo-rinaldi00/]
* **Email:** [rinaldipaolo910@gmail.com]