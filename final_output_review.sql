-- View clean release records
SELECT * FROM release_instructions ORDER BY release_date DESC;

-- View exceptions that need investigation
SELECT * FROM exceptions_report ORDER BY issue, client_id;

-- Optional: Count exceptions by type
SELECT issue, COUNT(*) AS count FROM exceptions_report GROUP BY issue;
