# Sera Sales Performance and Growth Analysis

## Objective
As a Data Engineer, I will optimize Sera's subscription payment data for growth analysis. This involves transforming the raw transactions database into a suitable 
format, followed by building a dashboard to visualize key business metrics and derive actionable insights.

## Tools
- PostgreSQL
- Power BI

## Techniques
- Data transformation in SQL
- Data analysis in SQL
- Data modelling and visualization

## Datasource
<a href = "https://resagratia.com"> Datascience Capstone Project on Resagratia </a>

## Data Transformation in SQL

I transformed the Sera database into a more workable format through various string manipulations and combined all the transformations into a single VIEW (sera.sales).

<a href = "https://github.com/dadahoro/sera-growth-analysis/blob/main/sera_sales_data_transformation_VIEW.sql"> Data transformation in SQL </a>

## Data Analysis in SQL

I conducted exploratory data analysis in SQL to understand the dataset. This analysis, performed for Sera management, focused on successful and abandoned transactions as well as subscription trends.

<a href = "https://github.com/dadahoro/sera-growth-analysis/blob/main/sera_sales_data_analysis.sql"> Data Analysis in SQL </a>

## Key Question
A key question the stakeholders would like to know is if the number of transactions per user increases their chances of subscribing.
Does transaction frequency (total subscription attempts) impact subscription rates (successful payments)?

Correlation and linear regression analysis would be suitable statistical methods to assess the relationship between transaction frequency and subscription rates.

### Interpretation of Results:

- Correlation Coefficient (0.53):
  The correlation coefficient (r) of 0.53 indicates a moderate positive correlation between transaction frequency (total subscription attempts) and subscription rates (successful payments). This suggests that as the number of subscription attempts increases, the likelihood of successful payments tends to increase as well, but the relationship is not very strong.

- Slope of the Least-Squares-Fit Linear Equation (0.08):
  The slope of 0.128 means that for every additional subscription attempt, the successful payment rate increases by 0.08 units. This positive slope further supports the finding that increased attempts are associated with higher success rates, but the effect size is relatively small.

- R Squared (0.28):
  The R squared value of 0.28 indicates that approximately 28% of the variation in subscription rates can be explained by the variation in transaction frequency. This means that while there is some explanatory power, a large portion of the variation in successful payments is influenced by other factors not included in this analysis.

<a href = "https://github.com/dadahoro/sera-growth-analysis/blob/main/sera_sales_key_question_data_analysis.sql"> Correlation and Regression Analysis in SQL </a>

## Data Visualization in Tableau

### Dashboard
![Dashboard](https://github.com/dadahoro/sera-growth-analysis/blob/main/assets/sera%20sales%20dashboard.png)

### Scatter plot and linear regression line
![Relationships](https://github.com/dadahoro/sera-growth-analysis/blob/main/assets/total%20subscriptions%20attempts%20and%20successful%20payments.png)

## Growth Analysis and Recommendations
- Increase Subscription Attempts:
  Since there is a positive relationship between subscription attempts and successful payments, encouraging more subscription attempts may lead to higher success rates. This could involve simplifying the subscription process or providing incentives for retrying after a failed attempt.

- Investigate Other Factors:
  Given that the R squared value is only 0.268, it's crucial to identify other factors that might influence subscription success rates. This could include analyzing user behavior, payment method effectiveness, pricing strategies, and user demographics.

- Optimize User Experience:
  Streamlining the subscription process to minimize friction can help improve success rates. This includes ensuring the payment gateway is reliable, the user interface is intuitive, and providing clear instructions and support.

- Targeted Interventions:
  Identify segments of users who are more likely to retry and succeed after a failed attempt and target them with specific interventions such as personalized reminders, discount offers, or simplified payment methods.

## Download
<a href = "https://github.com/dadahoro/sera-growth-analysis/raw/main/assets/Davo%20Dahoro%20Resa%20DSP%20Capstone%20Sera%20Growth%20Analysis.twbx"> Download Tableau workbook </a>

<a href = "https://public.tableau.com/app/profile/davo.dahoro/viz/DavoDahoroResaDSPCapstone/SERASalesDashboard"> Check out my Tableau Public Profile </a>




