# Fix Dashboard 400 and Sales 403 Errors

## Problem

When logging in, you see these errors in browser console:
```
POST /api/v1/dashboard 400 (Bad Request)
GET /api/v1/sales 403 (Forbidden)
```

## Root Cause

Admin user is missing critical data:
- ❌ No `warehouse_id` → Dashboard fails
- ❌ No `role_id` → Permission checks fail
- ❌ No `company_id` → Can't access company data
- ❌ Role has no permissions → Sales endpoint returns 403

## Solution

### On Production Server

```bash
# 1. Pull latest code
git pull origin claude/fix-login-page-loader-fHR9T

# 2. Run fix script
php fix_admin_user.php
```

### Expected Output

```
Starting admin user fix...
Found company: Stockifly (ID: 1)
Found warehouse: Stockifly Warehouse (ID: 1)
Found admin role: Admin (ID: 1)
  ✓ Role has 45 permissions

Found 1 admin user(s) to fix:

Fixing user: admin@example.com
  - Current warehouse_id: NULL
  - Current role_id: NULL
  - Current company_id: NULL
  ✓ Updated warehouse_id: 1
  ✓ Updated role_id: 1
  ✓ Updated company_id: 1
  ✓ Attached admin role

✅ Admin user(s) fixed successfully!
```

### After Running Script

1. **Clear browser cache** (Ctrl+Shift+R)
2. **Logout and login again**
3. Dashboard should load without errors

---

## What The Script Does

✅ Finds or creates company
✅ Finds or creates warehouse
✅ Finds or creates admin role with ALL permissions
✅ Updates admin user with:
   - `company_id`
   - `warehouse_id`
   - `role_id`
   - Attaches role to user
✅ Sets company currency if missing

---

## Manual Fix (If Script Fails)

### 1. Check Company Setup

```sql
SELECT id, name, currency_id, warehouse_id FROM companies;
```

If `currency_id` or `warehouse_id` is NULL:

```sql
-- Set currency
UPDATE companies
SET currency_id = (SELECT id FROM currencies WHERE code = 'USD' LIMIT 1)
WHERE id = 1;

-- Set warehouse
UPDATE companies
SET warehouse_id = (SELECT id FROM warehouses WHERE company_id = 1 LIMIT 1)
WHERE id = 1;
```

### 2. Fix Admin User

```sql
-- Update admin user
UPDATE users
SET
    company_id = 1,
    warehouse_id = (SELECT id FROM warehouses WHERE company_id = 1 LIMIT 1),
    role_id = (SELECT id FROM roles WHERE name = 'admin' AND company_id = 1 LIMIT 1),
    status = 'enabled',
    login_enabled = 1
WHERE email = 'admin@example.com';
```

### 3. Attach Role to User

```sql
-- Check if role is attached
SELECT * FROM role_user WHERE user_id = (SELECT id FROM users WHERE email = 'admin@example.com');

-- If not attached, add it
INSERT INTO role_user (user_id, role_id)
VALUES (
    (SELECT id FROM users WHERE email = 'admin@example.com'),
    (SELECT id FROM roles WHERE name = 'admin' LIMIT 1)
);
```

### 4. Assign Permissions to Admin Role

```sql
-- Check permissions
SELECT COUNT(*) FROM permission_role
WHERE role_id = (SELECT id FROM roles WHERE name = 'admin' LIMIT 1);

-- If 0, assign all permissions
INSERT INTO permission_role (permission_id, role_id)
SELECT id, (SELECT id FROM roles WHERE name = 'admin' AND company_id = 1 LIMIT 1)
FROM permissions;
```

---

## Verify Fix

### 1. Check User Data

```sql
SELECT
    id,
    email,
    company_id,
    warehouse_id,
    role_id,
    status,
    login_enabled
FROM users
WHERE email = 'admin@example.com';
```

**Should return:**
- ✅ company_id: NOT NULL
- ✅ warehouse_id: NOT NULL
- ✅ role_id: NOT NULL
- ✅ status: 'enabled'
- ✅ login_enabled: 1

### 2. Check Role Permissions

```sql
SELECT COUNT(*) as permission_count
FROM permission_role
WHERE role_id = (SELECT role_id FROM users WHERE email = 'admin@example.com' LIMIT 1);
```

**Should return:** permission_count > 0 (typically 40-50)

### 3. Test Login

1. Logout completely
2. Clear browser cache
3. Login with admin credentials
4. Check browser console (F12)
5. **No 400 or 403 errors should appear**

---

## Still Having Issues?

### Check Laravel Logs

```bash
tail -f storage/logs/laravel.log
```

### Check Database Connection

```bash
php artisan tinker
>>> DB::connection()->getPdo();
>>> \App\Models\User::where('email', 'admin@example.com')->first();
```

### Recreate Admin Completely

```bash
# Delete old admin
mysql -u root -p database_name -e "DELETE FROM users WHERE email = 'admin@example.com';"

# Create new admin
php artisan admin:create "My Company" admin@example.com SecurePassword123 --name="Admin User"
```

---

## Prevention

When creating new admin users, always use:

```bash
php artisan admin:create "Company Name" admin@email.com password --name="Admin Name"
```

This command creates:
- ✅ Company
- ✅ Warehouse
- ✅ Admin role with permissions
- ✅ Admin user with all fields set correctly
