-- Check 1 — spot check of claims with trivial damage severity
SELECT
    total_claim_amount,
    policy_annual_premium
FROM claims
WHERE incident_severity = 'Trivial Damage'
LIMIT 10;

-- Check 2 — row-count reconciliation (catches lost/duplicated rows)
SELECT
    (SELECT COUNT(*) FROM claims) AS total_rows,
    (SELECT SUM(claim_count) FROM (
        SELECT incident_severity, COUNT(*) AS claim_count
        FROM claims
        GROUP BY incident_severity
    ) AS grouped) AS summed_from_groups;
