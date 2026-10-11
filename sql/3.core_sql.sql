
-- Claim volume, severity, cost, premium, and claims-to-premium ratio by policy state
SELECT
    policy_state,
    COUNT(*)                                              AS claim_count,
    ROUND(AVG(total_claim_amount), 2)                     AS avg_severity,
    SUM(total_claim_amount)                                AS total_claims_cost,
    SUM(policy_annual_premium)                             AS total_premium,
    ROUND(SUM(total_claim_amount) / SUM(policy_annual_premium), 3) AS claims_to_premium_ratio
FROM claims
GROUP BY policy_state
ORDER BY claims_to_premium_ratio DESC;



-- Monthly Trend Analysis: claim count, severity, cost, premium, and claims-to-premium ratio by month
SELECT
    DATE_FORMAT(incident_date, '%Y-%m') AS month,
    COUNT(*) AS claim_count,
    ROUND(SUM(total_claim_amount), 2) AS total_claims_cost,
    ROUND(SUM(policy_annual_premium), 2) AS total_premium,
    ROUND(SUM(total_claim_amount) / SUM(policy_annual_premium), 3) AS claims_to_premium_ratio
FROM claims
GROUP BY month
ORDER BY month;


-- Date Range Analysis
SELECT MIN(incident_date) AS earliest, MAX(incident_date) AS latest
FROM claims;


-- claim volume, severity, cost, premium, and claims-to-premium ratio by incident severity
SELECT
    incident_severity,
    COUNT(*)                                          AS claim_count,
    ROUND(AVG(total_claim_amount), 2)                 AS avg_severity_cost,
    ROUND(SUM(total_claim_amount), 2)                 AS total_claims_cost,
    ROUND(SUM(policy_annual_premium), 2)              AS total_premium,
    ROUND(SUM(total_claim_amount) / SUM(policy_annual_premium), 3) AS claims_to_premium_ratio
FROM claims
GROUP BY incident_severity
ORDER BY claims_to_premium_ratio DESC;


