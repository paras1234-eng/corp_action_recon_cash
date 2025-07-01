-- Export mismatches and issues (for review)
SELECT * FROM validated_entitlements
WHERE status != 'Match';

-- Export clean records ready to release
SELECT * FROM validated_entitlements
WHERE status = 'Match';
