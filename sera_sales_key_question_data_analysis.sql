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