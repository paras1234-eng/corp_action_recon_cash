-- review_final_outputs.sql
-- Optional SQL queries for post-reconciliation review

-- 🔹 View clean records ready for release
SELECT * FROM release_instructions ORDER BY release_date DESC;

-- 🔹 View exceptions that need manual investigation
SELECT * FROM exceptions_report ORDER BY issue, client_id;

-- 🔹 Count exceptions by type
SELECT issue, COUNT(*) AS total_issues
FROM exceptions_report
GROUP BY issue;

sql/
├── create_tables.sql           # Creates the required SQL tables
├── data_load.sql               # Loads the input CSVs into SQL
├── reconciliation_logic.sql    # Core logic for entitlement calculation and matching
├── generate_outputs.sql        # Extracts final exception and release reports
+ ├── review_final_outputs.sql    # Optional queries to review clean and exception records
