-- SQLBook: Code
--- Profile the segmented fields in the claims_raw table
SELECT policy_state, COUNT(*) AS n FROM claims_raw GROUP BY policy_state ORDER BY n DESC;

SELECT COUNT(DISTINCT auto_make) AS n_makes FROM claims_raw;

SELECT COUNT(DISTINCT incident_severity) AS n_severities FROM claims_raw;

SELECT MIN(incident_date) AS earliest, MAX(incident_date) AS latest FROM claims_raw;



--Building a clean working layer on top of the claims_raw table rather than directly modifying the raw table. This is a good practice to avoid accidental data loss or corruption.
CREATE OR REPLACE VIEW claims AS
SELECT
    policy_number,
    policy_state,
    policy_annual_premium,
    incident_date,
    incident_state,
    incident_severity,
    incident_type,
    auto_make,
    auto_model,
    total_claim_amount,
    injury_claim,
    property_claim,
    vehicle_claim
FROM claims_raw;