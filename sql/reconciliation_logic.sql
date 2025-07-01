-- Step 1: Clear old results (optional)
DELETE FROM validated_entitlements;

-- Step 2: Join the data and calculate expected cash
INSERT INTO validated_entitlements (event_id, isin, quantity, rate, expected_amount, actual_amount, status)
SELECT
    ep.event_id,
    ep.isin,
    ep.quantity,
    cn.rate,
    ROUND(ep.quantity * cn.rate, 4) AS expected_amount,
    ac.actual_amount,
    CASE
        WHEN ROUND(ep.quantity * cn.rate, 4) = ac.actual_amount THEN 'Match'
        ELSE 'Mismatch'
    END AS status
FROM entitled_positions ep
JOIN ca_notifications cn ON ep.event_id = cn.event_id AND ep.isin = cn.isin
LEFT JOIN actual_cash ac ON ep.event_id = ac.event_id AND ep.isin = ac.isin;
