# Corporate Action Reconciliation & Cash Entitlement Automation (SQL Only)

## Real-World Problem This Project Solves

In investment operations, corporate actions like **coupon payments** and **bond redemptions** require accurate cash processing. However, in real environments:

- **Position data** may be incomplete or misaligned with records
- **Actual cash received** may differ from what was expected due to rounding issues, breaks, or incorrect reference data
- **Corporate action notifications** often contain inconsistent or incorrect event rates

Operations teams manually reconcile these in Excel — cross-referencing entitlements, comparing calculations, and identifying breaks.  
**This process is time-consuming, repetitive, error-prone, and lacks auditability.**

---

## Project Overview

This project uses **pure SQL** to simulate an automated reconciliation system. It replicates what financial institutions do daily using structured logic to compare:

- What we **should** receive (based on event rates × eligible positions)
- What we **actually** received (from agents, custodians, or internal systems)

---

## Real-World Impact of This Automation

Flags breaks **before settlement**  
Avoids **under- or over-payments** to clients or funds  
Saves hours of manual Excel work per event  
Provides an **auditable, repeatable** process for reconciling high-value transactions  
Helps junior ops analysts understand key logic used in reconciling coupon/redemption events

---

##  Key Concepts & SQL Techniques Used

- **Data Loading via CSV**  
  All input data (event notifications, positions, actual payments) is loaded into SQL tables.

- **Joins & Matching Logic**  
  Events are matched to positions using ISIN and event ID. This is the core reconciliation link.

- **Entitlement Calculation**  
  `Expected Cash = Quantity × Rate` — calculated in SQL using `CASE`, `ROUND()`, and arithmetic expressions.

- **Break Identification**  
  Mismatches between expected and actual cash are captured using `JOIN` and `WHERE` filters:
  - Missing positions
  - Missing payments
  - Incorrect rates
  - Cash differences

- **Output Reporting**  
  Clean records go to `release_instructions.csv`, while exceptions go to `exceptions_report.csv`.

---

##  File Structure

<pre>
sql/
├── create_tables.sql           # Creates the required SQL tables
├── data_load.sql               # Loads the input CSVs into SQL
├── reconciliation_logic.sql    # Core logic for entitlement calculation and matching
├── generate_outputs.sql        # Extracts final exception and release reports

input_data/
├── ca_notifications.csv        # Details of coupon/redemption events
├── entitled_positions.csv      # Positions eligible for entitlements
├── actual_cash.csv             # Actual cash received from agents

output_data/
├── exceptions_report.csv       # Flagged mismatches and errors
├── release_instructions.csv    # Validated, clean records

README.md                       # You are here
LICENSE                         # Open license for public use
.gitignore                      # Ignores local or temporary files
</pre>

---

##  How to Run This Project (Tested in DbGate)

1. Create a new SQL database (e.g., `corp_action_recon_cash`)
2. Run the scripts in order:
```sql
-- Step 1: Create empty tables
RUN sql/create_tables.sql;

-- Step 2: Load sample CSVs (via DbGate import or INSERTs)
RUN sql/data_load.sql;

-- Step 3: Run reconciliation logic
RUN sql/reconciliation_logic.sql;

-- Step 4: Extract final reports
RUN sql/generate_outputs.sql;
