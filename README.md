# Claims Cost & Loss Ratio by Segment

**Where is an auto insurer losing money, and why?**

**[View the live dashboard on Tableau Public →](https://public.tableau.com/app/profile/aayush.yagol/viz/claims_cost_loss_ratio_dashboard/Dashboard1)**

![Claims cost and loss ratio by segment dashboard](tableau_dashboard/Claims-cost-and-loss-ratio-by-segment.png)

---

## The business problem (in plain English)

An insurance company makes money when the premiums customers pay are larger than the claims it pays out. The standard way to measure this is the **loss ratio**:

> **Loss ratio = money paid out in claims ÷ money collected in premiums**

If a group of customers costs far more in claims than it brings in through premiums, the insurer is losing money on that group. The fix might be repricing, changing the coverage on offer, or tightening who gets approved. But first the insurer has to find **which group** is the problem.

This project answers one question an underwriting or pricing team would ask:

> *"Is our claims cost driven by **where** customers live, or by **how bad** their accidents are?"*

The answer decides where the team spends its effort. If location drives cost, the fix is regional pricing. If accident severity drives cost, the fix is in risk selection, coverage design, and claims handling. Getting it wrong means spending money on the wrong fix.

## Why I built it

I work as a Claims Advisor, so I see claim patterns every day, one claim at a time. I wanted to test my on-the-job instincts against real numbers, and to build the kind of **portfolio-monitoring dashboard** a team checks regularly to catch problems early, before they show up in the quarterly results.

## What I found

**Accident severity, not location, drives claims cost.**

| Looking at claims by... | Claims-to-premium ratio ranges from... | Spread |
| --- | --- | --- |
| **Accident severity** | 4.3 (Trivial Damage) → **51.1** (Major Damage) | **~12× difference** |
| **Policy state** (IL, IN, OH) | 41.6 → 42.2 | ~0.6 points, almost no difference |

**What this means for the business:**

- **Repricing by state wouldn't help much.** All three states perform almost the same.
- **The real cost pressure is concentrated in Major Damage and Total Loss claims**, which together make up 56% of claims and about two-thirds of total claims cost.
- The team should focus on the factors that predict *severe* accidents (vehicle type, driver profile, coverage limits), not on geography.

| Severity | Claims | Avg cost per claim | Claims-to-premium ratio |
| --- | --- | --- | --- |
| Major Damage | 276 | $64,067 | 51.1 |
| Total Loss | 280 | $62,081 | 49.2 |
| Minor Damage | 354 | $48,643 | 38.6 |
| Trivial Damage | 90 | $5,302 | 4.3 |

## An honest caveat

The dataset only contains customers **who filed a claim**. It doesn't include the many customers who paid premiums and never claimed. A true company-wide loss ratio needs both groups, so the ratios above are **much higher than a real insurer's** would be.

That's why the dashboard labels the metric a **claims-to-premium ratio for claiming policies**, not a true loss ratio. The *comparison between segments* is still valid: severity separates cost far more than state does. The absolute numbers shouldn't be read as company-wide profitability. I state this limitation on the dashboard itself rather than hiding it.

---

## How I built it (technical details)

### Tools

| Tool | Used for |
| --- | --- |
| **MySQL** | Loading, cleaning, profiling, aggregating, and validating the data |
| **SQL** | Aggregations (`GROUP BY`, `SUM`, `AVG`), views, subqueries, type conversion |
| **Tableau Public** | Interactive dashboard and data storytelling |

### Process

1. **Load & clean** (`sql/1.verify_and_clean.sql`)
   - Checked the row count against the source (1,000 rows)
   - Converted text date columns to proper `DATE` types with `STR_TO_DATE`
   - Dropped an empty artifact column and scanned for placeholder values (`'?'`) and `NULL`s in the key fields

2. **Profile the data** (`sql/2.profile_the_segmented_fields.sql`)
   - Checked the distribution of each candidate segment (state, severity, vehicle make)
   - Checked the date range, which changed the scope of the project (see Design decisions)
   - Built a **clean `claims` view** over the raw table, so analysis never modifies the source data

3. **Aggregate by segment** (`sql/3.core_sql.sql`)
   - Calculated claim count, average claim cost, total claims cost, total premium, and the claims-to-premium ratio for each policy state and each severity level
   - Exported the results to CSV (`csv/`) as the Tableau data source

4. **Validate before charting** (`sql/4.hand_sanity_checks.sql`)
   - **Spot check:** sampled raw rows in the smallest segment (Trivial Damage) to make sure no outliers were distorting the average
   - **Row-count reconciliation:** confirmed that the per-segment counts add back up to the full table (1,000 = 1,000), so no rows were lost or double-counted by the `GROUP BY`

5. **Visualize** (`tableau_dashboard/`)
   - Built the dashboard in Tableau Public with the data limitation stated on the dashboard

### Design decisions

- **Segmented by `policy_state`, not `incident_state`.** Insurers organize and price their business by where the policy was *written*, not where the accident *happened*. Using the right field keeps the analysis aligned with how underwriting decisions are actually made.
- **Added severity as a second lens.** The state view showed almost no difference, so I tested a second explanation instead of stopping at a flat result. That's where the real finding came from.
- **Left out a monthly trend chart on purpose.** Profiling showed the claims cover only a 60-day window (Jan 1 – Mar 1, 2015). A trend chart over two months would suggest patterns that aren't there. The query stays in the SQL for transparency, but it isn't charted.
- **Used CSV extracts instead of a live connection.** Tableau Public's free desktop app can't connect directly to MySQL, so I exported clean summary tables.

---

## Dataset

- **Source:** [insurance_claims.csv](https://raw.githubusercontent.com/Jai-Ds/Insurance-Fraud-Claims-Detection/master/insurance_claims.csv). Synthetic auto insurance claims, originally built for an IBM Watson fraud-detection tutorial
- **Size:** 1,000 claims, one row per claim
- **Coverage:** Illinois, Indiana, and Ohio policies, with incidents from Jan–Mar 2015

## Repository contents

```text
├── data/
│   └── insurance_claims.csv            # Raw source data
├── sql/
│   ├── 1.verify_and_clean.sql          # Row checks, type conversion, missing-value scan
│   ├── 2.profile_the_segmented_fields.sql  # Segment profiling + clean view
│   ├── 3.core_sql.sql                  # Segment aggregations (state, severity, monthly)
│   ├── 4.hand_sanity_checks.sql        # Spot check + row-count reconciliation
│   └── Practice_questions.sql          # Extra SQL practice on the same data
├── csv/
│   ├── policy_state_summary.csv        # Tableau data source: by state
│   └── severity_summary.csv            # Tableau data source: by severity
└── tableau_dashboard/
    ├── Claims-cost-and-loss-ratio-by-segment.png   # Dashboard screenshot
    └── claims_cost_loss_ratio_dashboard.twb        # Tableau workbook
```

## Skills demonstrated

- **Business framing:** turning a vague question ("where are we losing money?") into a testable comparison
- **SQL:** cleaning, profiling, views, aggregation, subqueries, and validation queries
- **Data quality:** reconciliation checks and outlier spot checks before trusting the results
- **Analytical judgment:** choosing the right segment field, testing another explanation, and dropping a misleading chart
- **Honest communication:** stating the dataset's limits up front instead of overstating the findings
- **Data visualization:** a clean, single-screen Tableau dashboard built for a non-technical audience
