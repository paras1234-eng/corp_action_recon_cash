# Corporate Action Reconciliation – Fixed Income (SQL Automation Project)

This project automates the reconciliation of fixed income corporate action events, specifically validating **cash entitlements** against actual payments received. It uses **pure SQL** to perform the full entitlement calculation, exception detection, and output generation simulating real-world financial operations workflow.

## Use Case

In capital markets operations, when coupon or redemption payments are due, discrepancies can arise between:
- **What clients are entitled to (based on positions and event details)**
- **What was actually paid by the issuer or agent**

This automation identifies those mismatches upfront using structured logic.


##  Tech Stack

- SQL (tested on MySQL-compatible engines via DbGate)
- CSV input/output for real-world simulation
- Manual or GUI-based SQL execution (no Python dependencies)


##  Project Structure

```
├── input_data/               # CSVs with entitlements, events, and cash received
├── output_data/              # CSVs for exception and release results
├── sql/                      # Modular SQL scripts
│   ├── create_tables.sql
│   ├── data_load.sql
│   ├── reconciliation_logic.sql
│   ├── generate_outputs.sql
│   └── review_final_outputs.sql
└── README.md
```

---

##  Execution Steps

1. **Create Tables**  
   Run `create_tables.sql` to set up the required tables.

2. **Load Data**  
   Import the CSVs using the DbGate GUI (or similar SQL tool):  
   - `ca_notifications.csv` → `ca_notifications`  
   - `entitled_positions.csv` → `entitled_positions`  
   - `actual_cash.csv` → `actual_cash`

3. **Run Reconciliation Logic**  
   Execute `reconciliation_logic.sql` to calculate expected entitlements and match them with actuals.

4. **Generate Outputs**  
   Run `generate_outputs.sql` to separate:
   -  Exceptions → unmatched payments  
   -  Clean records → eligible for release

5. **Review (Optional)**  
   Use `review_final_outputs.sql` for counts, filters, and exception summaries.

---

##  Output

- `exceptions_report.csv` → All mismatches needing review  
- `release_instructions.csv` → Clean payments ready for release

---

##  Tags

`#fixed-income` `#reconciliation` `#cash-entitlement` `#sql-automation` `#corporate-actions` `#banking-operations` `#data-quality`

---

##  License

MIT License

---

##  Author

**Paras Rathod**  
[GitHub Profile](https://github.com/paras1234-eng)  
[LinkedIn](https://www.linkedin.com/in/paras-rathod-09429135)


