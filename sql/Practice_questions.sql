SELECT * FROM claims LIMIT 10;


-- 1. List every claim in Ohio (policy_state = 'OH') over $50,000, highest first.
SELECT
	policy_number,
	total_claim_amount
FROM claims
WHERE
	policy_state = 'OH'
	AND
		total_claim_amount > 50000
ORDER BY total_claim_amount DESC;


-- 2. How many claims came from each state?
SELECT policy_state,
	COUNT(policy_number) AS claim_count
FROM claims
GROUP BY policy_state 
ORDER BY claim_count DESC;


-- 3. What's the average claim amount per state, rounded to 2 decimals, highest first?
SELECT policy_state,
	ROUND(AVG(total_claim_amount),2) AS avg_claim_amount
FROM claims
GROUP BY policy_state 
ORDER BY avg_claim_amount DESC;


-- 4. For each state, calculate a claims-to-premium ratio: sum of claims ÷ sum of premium.
SELECT policy_state,
	ROUND(SUM(total_claim_amount)/SUM(policy_annual_premium),2) AS claims_to_premium
FROM claims
GROUP BY policy_state
ORDER BY claims_to_premium DESC;


-- 5. Which states have more than 50 claims AND an average claim above $25,000?
SELECT policy_state,
	COUNT(*) AS number_of_claims,
	ROUND(AVG(total_claim_amount),2) AS avg_claim_amount
FROM claims
GROUP BY policy_state
HAVING COUNT(*) > 50 AND AVG(total_claim_amount) > 25000;


-- 6. Which individual claims are above the overall average claim amount?
SELECT policy_number, total_claim_amount
FROM claims
WHERE total_claim_amount > (SELECT AVG(total_claim_amount) FROM claims);


-- 7. Bucket claims into Low (<$20k), Medium ($20k–$60k), High (>$60k) and count each.
SELECT
	CASE
		WHEN total_claim_amount < 20000 THEN 'Low'
		WHEN total_claim_amount <= 60000 THEN 'Medium'
		ELSE 'High'
	END AS severity_bucket,
	COUNT(*) AS claim_count
FROM claims
GROUP BY severity_bucket 
	

-- 8. Count claims by month of incident_date.
SELECT 
	DATE_FORMAT(incident_date, '%Y-%m') AS incident_month,
	COUNT(*) AS claim_count
FROM claims 
GROUP BY incident_month
ORDER BY incident_month 


-- 9. This dataset marks missing values as a literal "?" instead of blank. Count only rows where collision_type is actually filled in.
-- SELECT
-- 	COUNT(*) AS valid_rows
-- FROM claims 
-- WHERE collision_type != '?';


-- 10. What share of claims were flagged as fraud, broken down by incident severity?


