**Corporate Action Reconciliation & Cash Entitlement Automation (SQL Project)**

This project automates the end-to-end reconciliation and release process for fixed income corporate actions, such as coupon payments and redemptions. It simulates real-world operations workflows typically handled in Excel and emails, and demonstrates how SQL automation can streamline exception detection and payment processing.

**Real-World Problem**

In fixed income operations, when a bond pays a coupon or gets redeemed, operations teams must:
Load the corporate action event data (ISIN, rate per unit)
Determine what each client is entitled to based on their position
Check the actual cash received
Reconcile expected vs actual
Release funds for clean items and investigate mismatches
Manual handling of these steps often leads to:
Delays in cash releases
Missed or underpaid clients
Audit breaks and compliance issues

**What This Project Does**

Step
| Step | Task                                             | Purpose                                 |
| ---- | ------------------------------------------------ | --------------------------------------- |
| 1    | Load event data (`ca_notifications.csv`)         | Corporate action notice from custodian  |
| 2    | Load client positions (`entitled_positions.csv`) | Record date holdings                    |
| 3    | Load actual cash received (`actual_cash.csv`)    | Cash received for each client/ISIN      |
| 4    | Calculate expected cash                          | Based on rate × position                |
| 5    | Reconcile expected vs actual                     | Find missing, overpaid, underpaid cases |
| 6    | Generate exception and release reports           | For Ops and downstream processing       |

**Project Structure**

corp_action_recon_cash/
├── inputs/
│   ├── ca_notifications.csv
│   ├── entitled_positions.csv
│   └── actual_cash.csv
├── outputs/
│   ├── exceptions_report.csv
│   └── release_instructions.csv
├── final_output_review.sql
└── README.md

**Input Files (Simulated)**

ca_notifications.csv

isin,rate_per_unit
US1234567890,1.50
US9876543210,2.00
US0001112223,0.75

entitled_positions.csv

client_id,isin,position
C001,US1234567890,1000
C002,US9876543210,500
C003,US0001112223,2000

actual_cash.csv

client_id,isin,cash_received
C001,US1234567890,1500.00
C002,US9876543210,1000.00
C003,US0001112223,1300.00

**Output Files**

exceptions_report.csv

client_id,isin,expected_amount,received_amount,issue
C002,US9876543210,1000.00,1000.00,Match
C003,US0001112223,1500.00,1300.00,Underpaid

release_instructions.csv

client_id,isin,release_amount,release_date
C001,US1234567890,1500.00,2025-06-30

**SQL Code and Flow**
The full SQL logic for entitlement calculation, exception capture, and release is saved in:
final_output_review.sql
**You can view or run this file to reproduce the outputs in any SQL environment.**
Core Logic Covered:
-- STEP 1: Calculate expected cash entitlement
SELECT 
    ep.client_id,
    ep.isin,
    ep.position,
    cn.rate_per_unit,
    ROUND(ep.position * cn.rate_per_unit, 2) AS expected_amount
FROM entitled_positions ep
JOIN ca_notifications cn ON ep.isin = cn.isin;

-- STEP 2: Generate exceptions_report (mismatches)
INSERT INTO exceptions_report (client_id, isin, expected_amount, received_amount, issue)
SELECT
    ep.client_id,
    ep.isin,
    ROUND(ep.position * cn.rate_per_unit, 2) AS expected_amount,
    ac.cash_received AS received_amount,
    CASE
        WHEN ac.cash_received IS NULL THEN 'Missing'
        WHEN ac.cash_received < ROUND(ep.position * cn.rate_per_unit, 2) THEN 'Underpaid'
        WHEN ac.cash_received > ROUND(ep.position * cn.rate_per_unit, 2) THEN 'Overpaid'
        ELSE 'Match'
    END AS issue
FROM entitled_positions ep
JOIN ca_notifications cn ON ep.isin = cn.isin
LEFT JOIN actual_cash ac ON ep.client_id = ac.client_id AND ep.isin = ac.isin
WHERE ac.cash_received IS NULL
   OR ac.cash_received != ROUND(ep.position * cn.rate_per_unit, 2);

-- STEP 3: Generate release_instructions (clean matched data)
INSERT INTO release_instructions (client_id, isin, release_amount, release_date)
SELECT
    ep.client_id,
    ep.isin,
    ac.cash_received,
    CURDATE() AS release_date
FROM entitled_positions ep
JOIN ca_notifications cn ON ep.isin = cn.isin
JOIN actual_cash ac ON ep.client_id = ac.client_id AND ep.isin = ac.isin
WHERE ac.cash_received = ROUND(ep.position * cn.rate_per_unit, 2);

-- STEP 4: Review counts of exceptions by type
SELECT issue, COUNT(*) AS issue_count
FROM exceptions_report
GROUP BY issue;

**Real-World Impact**

Problem in Firms
How This Project Helps
Clients complain about wrong amounts
Flags underpaid/overpaid clients
Manual Excel checks delay payments
Automates all calculations using SQL
Ops teams unsure which payments to release
Clear separation between clean and exception data
Auditors request evidence
Stored, queryable tables + exported reports

**Optional Enhancements (Future)**

Store exceptions and release tables in a historical SQL table
Add email alerts for mismatches
Build a web front-end for file upload + visual summary

**Key SQL Concepts Used**

JOIN for entitlement vs cash matching
CASE WHEN for exception logic
ROUND() for accurate decimal comparison
INSERT INTO ... SELECT for automation of outputs

Final Notes

This project simulates a real, high-risk process in fixed income operations — and turns it into a clean, automated, auditable solution using only SQL.
It is beginner-friendly, easy to understand, and designed to demonstrate not only automation logic but also business knowledge.

Feel free to fork, improve, or adapt this for more asset classes!
