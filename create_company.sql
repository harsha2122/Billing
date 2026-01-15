-- Check if company exists
SELECT * FROM companies;

-- If no company exists, create one
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
    '123 Main St, City, State, 12345',
    'sidebar',
    1,
    1,
    1,
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
