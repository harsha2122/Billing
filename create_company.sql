-- Check if company exists
SELECT * FROM companies;

-- Check required foreign keys
SELECT id FROM currencies LIMIT 1;
SELECT id FROM langs LIMIT 1;
SELECT id FROM warehouses LIMIT 1;

-- Create company with NULL foreign keys (will be set later)
INSERT INTO companies (
    name,
    short_name,
    email,
    phone,
    website,
    address,
    app_layout,
    currency_id,
    lang_id,
    warehouse_id,
    left_sidebar_theme,
    primary_color,
    date_format,
    time_format,
    auto_detect_timezone,
    timezone,
    session_driver,
    app_debug,
    update_app_notification,
    created_at,
    updated_at
)
VALUES (
    'My Company',
    'MyCompany',
    'admin@example.com',
    '1234567890',
    'https://example.com',
    '123 Main St, City, State',
    'sidebar',
    NULL,
    NULL,
    NULL,
    'dark',
    '#1890ff',
    'DD-MM-YYYY',
    'hh:mm a',
    1,
    'Asia/Kolkata',
    'file',
    0,
    1,
    NOW(),
    NOW()
);

-- Update with actual IDs if they exist
UPDATE companies
SET
    currency_id = (SELECT id FROM currencies LIMIT 1),
    lang_id = (SELECT id FROM langs LIMIT 1),
    warehouse_id = (SELECT id FROM warehouses LIMIT 1)
WHERE id = LAST_INSERT_ID();
