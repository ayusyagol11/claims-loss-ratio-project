
USE claims_loss_ratio;

--- Verify the number of rows in the claims_raw table
SELECT COUNT(*) AS row_count FROM claims_raw;  -- expect 1000
DESCRIBE claims_raw;

-- Change the data type of policy_bind_date and incident_date to DATE
ALTER TABLE claims_raw ADD COLUMN policy_bind_date_fixed DATE;
UPDATE claims_raw SET policy_bind_date_fixed = STR_TO_DATE(policy_bind_date, '%Y-%m-%d');

ALTER TABLE claims_raw ADD COLUMN incident_date_fixed DATE;
UPDATE claims_raw SET incident_date_fixed = STR_TO_DATE(incident_date, '%Y-%m-%d');

--- Drop the original policy_bind_date and incident_date columns
ALTER TABLE claims_raw DROP COLUMN _c39;


--- Drop the original policy_bind_date and incident_date columns
SELECT COUNT(*) AS suspect_rows
FROM claims_raw
WHERE policy_state = '?' OR incident_state = '?' OR incident_severity = '?'
   OR auto_make = '?' OR total_claim_amount IS NULL OR policy_annual_premium IS NULL;