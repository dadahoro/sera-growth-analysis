--DATA ANALYSIS IN SQL
SELECT *
FROM sera.sales;

--Q1 How many transactions occurred?
SELECT COUNT(transaction_id) AS total_transactions
FROM sera.sales;

--Q2 What is the period covered in the analysis?
SELECT
  DATE(MIN(datetime)) AS min_date,
  DATE(MAX(datetime)) AS max_date
FROM sera.sales;

--The count of years, months, and days between min_date and max_date
WITH date_extremes AS (
  SELECT
    MIN(datetime) AS min_date,
    MAX(datetime) AS max_date
  FROM sera.sales
)
SELECT
  EXTRACT(YEAR FROM age(max_date, min_date)) AS years,
  EXTRACT(MONTH FROM age(max_date, min_date)) AS months,
  EXTRACT(DAY FROM age(max_date, min_date) - INTERVAL '1 year' * EXTRACT(YEAR FROM age(max_date, min_date)) - INTERVAL '1 month' * EXTRACT(MONTH FROM age(max_date, min_date))) AS days
FROM date_extremes;

--Q3 Show the transaction count by status and percentage of total for each status.
SELECT
	COUNT(CASE WHEN status = 'success' THEN 1 END) AS total_success,	
	COUNT(CASE WHEN status = 'failed' THEN 1 END) AS total_failed,	
	COUNT(CASE WHEN status = 'abandoned' THEN 1 END) AS total_abandoned,	
	COUNT(*) AS total_rows,
	ROUND((COUNT(CASE WHEN status = 'success' THEN 1 END)*1.0 / COUNT(*)), 1) AS successful_perc,
	ROUND((COUNT(CASE WHEN status = 'failed' THEN 1 END)*1.0 / COUNT(*)), 1) AS failed_perc,
	ROUND((COUNT(CASE WHEN status = 'abandoned' THEN 1 END)*1.0 / COUNT(*)), 1) AS abandoned_perc
FROM sera.sales;

--Q4 Show the monthly subscription revenue split by channel (1USD=950NGN).
WITH subscription_sales AS (
  SELECT *,
    ROUND(CASE
      WHEN currency = 'USD' THEN amount * 950
      ELSE amount
    END, 2) AS amount_in_ngn
  FROM sera.sales
)
SELECT
	DATE_TRUNC('month', datetime) AS month,
	SUM(amount_in_ngn) AS total_monthly_subscription,
  	SUM(CASE WHEN channel = 'card' THEN amount_in_ngn END) AS card_monthly_subscription,	
	SUM(CASE WHEN channel = 'bank_transfer' THEN amount_in_ngn END) AS bank_transfer_monthly_subscription,	
	SUM(CASE WHEN channel = 'bank' THEN amount_in_ngn END) AS bank_monthly_subscription,
	SUM(CASE WHEN channel = 'ussd' THEN amount_in_ngn END) AS ussd_monthly_subscription
FROM subscription_sales
GROUP BY DATE_TRUNC('month', datetime)
ORDER BY month;
	
--Q5 Show the total transactions by channel split by the transaction status. 
--Which channel has the highest rate of success? 
--Which has the highest rate of failure? 
SELECT
	channel,
	COUNT(*) AS total_txn,
	COUNT(CASE WHEN status = 'success' THEN 1 END) AS total_successful,
	COUNT(CASE WHEN status = 'abandoned' THEN 1 END) AS total_abandoned,
	COUNT(CASE WHEN status = 'failed' THEN 1 END) AS total_failed,
	
	ROUND((COUNT(CASE WHEN status = 'success' THEN 1 END)*1.0 / COUNT(*))*100, 2) AS total_success_rate,
	ROUND((COUNT(CASE WHEN status = 'abandoned' THEN 1 END)*1.0 / COUNT(*))*100, 2) AS total_abandoned_rate,
	ROUND((COUNT(CASE WHEN status = 'failed' THEN 1 END)*1.0 / COUNT(*))*100, 2) AS total_failed_rate
FROM sera.sales
GROUP BY channel;

--Q6 How many subscribers are there in total? 
--A subscriber is a user with a successful payment.
SELECT
	COUNT(DISTINCT(user_id)) AS unique_subscriber_count
FROM sera.sales
WHERE status = 'success';

--Q7 A user is active within a month when there is an attempt to subscribe. 
--Generate a list of users showing their number of active months, 
--total successful, abandoned and failed transactions. 

WITH unique_users_monthly_status AS (
  SELECT
    user_id,
    DATE_TRUNC('month', datetime) AS month,
    COUNT(status) AS total_monthly_subscription_attempts,
    COUNT(CASE WHEN status = 'success' THEN 1 END) AS total_successful,
    COUNT(CASE WHEN status = 'abandoned' THEN 1 END) AS total_abandoned,
    COUNT(CASE WHEN status = 'failed' THEN 1 END) AS total_failed
  FROM sera.sales
  GROUP BY user_id, DATE_TRUNC('month', datetime)
)
SELECT 
  	user_id,
	COUNT(month) AS months_active,
	SUM(total_successful) AS total_successful,
 	SUM(total_abandoned) AS total_abandoned,
  	SUM(total_failed) AS total_failed
FROM unique_users_monthly_status
GROUP BY user_id
ORDER BY months_active DESC;

--Q8 Identify the users with more than 1 active month without a successful transaction.
WITH unique_users_status AS (
  SELECT
    user_id,
    DATE_TRUNC('month', datetime) AS month,
    COUNT(status) AS total_monthly_subscription_attempts,
    COUNT(CASE WHEN status = 'success' THEN 1 END) AS total_successful,
    COUNT(CASE WHEN status = 'abandoned' THEN 1 END) AS total_abandoned,
    COUNT(CASE WHEN status = 'failed' THEN 1 END) AS total_failed
  FROM sera.sales
  GROUP BY user_id, DATE_TRUNC('month', datetime)
)
SELECT
  user_id,
  COUNT(DISTINCT month) AS months_active,
  SUM(total_successful) AS total_successful,
  SUM(total_abandoned) AS total_abandoned,
  SUM(total_failed) AS total_failed
FROM unique_users_status
GROUP BY user_id
HAVING COUNT(DISTINCT month) > 1 AND SUM(total_successful) = 0
ORDER BY months_active DESC;


--Key Question
--A key question the stakeholders would like to know is if the number of transactions per user increases their chances of subscribing.
--Does transaction frequency impact subscription rates (successful payment)?
WITH status_statistics AS (	
	SELECT *
		FROM(
			SELECT
				    DISTINCT(user_id),
				    COUNT(status) AS total_subscription_attempts,
				    COUNT(CASE WHEN status = 'success' THEN 1 END) AS total_successful,
				    COUNT(CASE WHEN status = 'abandoned' THEN 1 END) AS total_abandoned,
				    COUNT(CASE WHEN status = 'failed' THEN 1 END) AS total_failed
				FROM sera.sales
				GROUP BY DISTINCT(user_id)
				ORDER BY total_subscription_attempts DESC
		)	
	WHERE total_successful > 0
)	
SELECT  
	CORR(total_successful, total_subscription_attempts), -- correlation coefficient
	regr_slope(total_successful, total_subscription_attempts), -- slope of the least-squares-fit linear equation 
	regr_r2(total_successful, total_subscription_attempts) -- (R^2) square of the correlation coefficient
FROM status_statistics