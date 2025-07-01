-- Create table for corporate action event notifications
CREATE TABLE IF NOT EXISTS ca_notifications (
    event_id TEXT,
    isin TEXT,
    event_type TEXT,
    rate DECIMAL(10,4),
    currency TEXT
);

-- Create table for positions eligible for the event
CREATE TABLE IF NOT EXISTS entitled_positions (
    position_id TEXT,
    event_id TEXT,
    isin TEXT,
    quantity INTEGER
);

-- Create table for actual cash received
CREATE TABLE IF NOT EXISTS actual_cash (
    payment_id TEXT,
    event_id TEXT,
    isin TEXT,
    actual_amount DECIMAL(12,4),
    currency TEXT
);

-- Table for storing matched and validated records
CREATE TABLE IF NOT EXISTS validated_entitlements (
    event_id TEXT,
    isin TEXT,
    quantity INTEGER,
    rate DECIMAL(10,4),
    expected_amount DECIMAL(12,4),
    actual_amount DECIMAL(12,4),
    status TEXT
);
