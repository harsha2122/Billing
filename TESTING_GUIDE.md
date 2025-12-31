# Multi-User System Testing Guide

## ✅ Pre-Testing Setup

### 1. Run Migration
```bash
cd c:\xampp\htdocs\billing
php artisan migrate
```

### 2. Regenerate Autoload
```bash
composer dump-autoload
```

### 3. Clear Cache
```bash
php artisan config:clear
php artisan cache:clear
php artisan route:clear
```

---

## 🧪 Testing Checklist

### Phase 1: Database & Migration Testing

- [ ] **Migration Success**
  - Run `php artisan migrate`
  - Check `users` table has `role` column
  - Check all core tables have `admin_id` column
  - Verify first user has `role = 'superadmin'`

- [ ] **Data Assignment**
  - Check existing products have `admin_id` set
  - Check existing orders have `admin_id` set
  - Check existing expenses have `admin_id` set

---

### Phase 2: Authentication & Role Testing

#### Test 1: Superadmin Login
```bash
# Login as superadmin (first user)
POST /api/auth/login
{
  "email": "admin@example.com",
  "password": "12345678"
}
```

**Expected:**
- ✅ Login successful
- ✅ Response includes `user.role = 'superadmin'`
- ✅ Token generated

#### Test 2: Create Admin User (Superadmin Only)
```bash
POST /api/admin/users
Headers: Authorization: Bearer {superadmin_token}
{
  "name": "Test Admin",
  "email": "testadmin@example.com",
  "password": "password123",
  "role": "admin"
}
```

**Expected:**
- ✅ User created successfully
- ✅ New user has `role = 'admin'`

#### Test 3: Admin Login
```bash
POST /api/auth/login
{
  "email": "testadmin@example.com",
  "password": "password123"
}
```

**Expected:**
- ✅ Login successful
- ✅ Response includes `user.role = 'admin'`

---

### Phase 3: Data Scoping Testing

#### Test 4: Superadmin Sees All Products
```bash
GET /api/products
Headers: Authorization: Bearer {superadmin_token}
```

**Expected:**
- ✅ Returns ALL products from all admins
- ✅ No filtering applied

#### Test 5: Admin Sees Only Their Products
```bash
GET /api/products
Headers: Authorization: Bearer {admin_token}
```

**Expected:**
- ✅ Returns ONLY products where `admin_id = admin's user id`
- ✅ Cannot see other admins' products

#### Test 6: Admin Creates Product
```bash
POST /api/products
Headers: Authorization: Bearer {admin_token}
{
  "name": "Test Product",
  "item_code": "TEST001",
  ...
}
```

**Expected:**
- ✅ Product created successfully
- ✅ Product has `admin_id = admin's user id` (auto-assigned)

#### Test 7: Admin Cannot Access Other Admin's Product
```bash
# Get product ID from another admin
GET /api/products/{other_admin_product_id}
Headers: Authorization: Bearer {admin_token}
```

**Expected:**
- ❌ 404 Not Found (product filtered out by scope)
- ✅ Security: Cannot access via URL manipulation

---

### Phase 4: Middleware Testing

#### Test 8: Admin Cannot Access User Management
```bash
GET /api/admin/users
Headers: Authorization: Bearer {admin_token}
```

**Expected:**
- ❌ 403 Forbidden
- ✅ Error: "Access denied. Superadmin role required."

#### Test 9: Superadmin Can Access User Management
```bash
GET /api/admin/users
Headers: Authorization: Bearer {superadmin_token}
```

**Expected:**
- ✅ 200 OK
- ✅ Returns list of all users

---

### Phase 5: POS & Billing Flow Testing

#### Test 10: Admin Creates Sale Order
```bash
POST /api/pos/orders
Headers: Authorization: Bearer {admin_token}
{
  "order_type": "sales",
  "products": [...],
  ...
}
```

**Expected:**
- ✅ Order created successfully
- ✅ Order has `admin_id = admin's user id`
- ✅ Stock updated correctly
- ✅ Invoice generated

#### Test 11: Admin Views Their Sales
```bash
GET /api/sales
Headers: Authorization: Bearer {admin_token}
```

**Expected:**
- ✅ Returns only sales where `admin_id = admin's user id`
- ✅ Cannot see other admins' sales

#### Test 12: Superadmin Views All Sales
```bash
GET /api/sales
Headers: Authorization: Bearer {superadmin_token}
```

**Expected:**
- ✅ Returns ALL sales from all admins

---

### Phase 6: Dashboard & Reports Testing

#### Test 13: Admin Dashboard Stats
```bash
POST /api/dashboard
Headers: Authorization: Bearer {admin_token}
```

**Expected:**
- ✅ Stats show only admin's data:
  - Total sales (admin's only)
  - Total products (admin's only)
  - Total expenses (admin's only)
- ✅ No data from other admins

#### Test 14: Superadmin Dashboard Stats
```bash
POST /api/dashboard
Headers: Authorization: Bearer {superadmin_token}
```

**Expected:**
- ✅ Stats show ALL data:
  - Total sales (all admins)
  - Total products (all admins)
  - Total users count

#### Test 15: Profit/Loss Report
```bash
POST /api/reports/profit-loss
Headers: Authorization: Bearer {admin_token}
```

**Expected:**
- ✅ Report shows only admin's data
- ✅ Calculations correct for admin's scope

---

### Phase 7: Security Testing

#### Test 16: URL Manipulation Attack
```bash
# Admin tries to access another admin's product by ID
GET /api/products/{superadmin_product_id}
Headers: Authorization: Bearer {admin_token}
```

**Expected:**
- ❌ 404 Not Found
- ✅ Product filtered by AdminScope

#### Test 17: Admin Cannot Change Own Role
```bash
PUT /api/admin/users/{admin_id}/role
Headers: Authorization: Bearer {admin_token}
{
  "role": "superadmin"
}
```

**Expected:**
- ❌ 403 Forbidden (middleware blocks access)

#### Test 18: Admin Cannot Delete Superadmin
```bash
DELETE /api/admin/users/{superadmin_id}
Headers: Authorization: Bearer {admin_token}
```

**Expected:**
- ❌ 403 Forbidden (middleware blocks access)

---

### Phase 8: Edge Cases Testing

#### Test 19: Empty Admin Data
```bash
# Create new admin with no data
# Login as new admin
GET /api/products
Headers: Authorization: Bearer {new_admin_token}
```

**Expected:**
- ✅ Returns empty array []
- ✅ No errors

#### Test 20: Superadmin Deletes Admin with Data
```bash
DELETE /api/admin/users/{admin_with_data_id}
Headers: Authorization: Bearer {superadmin_token}
```

**Expected:**
- ❌ Error: "Cannot delete user with associated data"
- ✅ Suggests reassigning data first

#### Test 21: Data Reassignment
```bash
POST /api/admin/users/reassign-data
Headers: Authorization: Bearer {superadmin_token}
{
  "from_user_id": "{admin1_xid}",
  "to_user_id": "{admin2_xid}"
}
```

**Expected:**
- ✅ All admin1's data now belongs to admin2
- ✅ Products, orders, expenses transferred

---

## 📊 Test Results Template

```
=== MULTI-USER SYSTEM TEST RESULTS ===

Date: _______________
Tester: _______________

Phase 1: Database & Migration
[ ] Migration Success
[ ] Data Assignment

Phase 2: Authentication & Role
[ ] Superadmin Login
[ ] Create Admin User
[ ] Admin Login

Phase 3: Data Scoping
[ ] Superadmin Sees All Products
[ ] Admin Sees Only Their Products
[ ] Admin Creates Product
[ ] Admin Cannot Access Other's Product

Phase 4: Middleware
[ ] Admin Cannot Access User Management
[ ] Superadmin Can Access User Management

Phase 5: POS & Billing
[ ] Admin Creates Sale Order
[ ] Admin Views Their Sales
[ ] Superadmin Views All Sales

Phase 6: Dashboard & Reports
[ ] Admin Dashboard Stats
[ ] Superadmin Dashboard Stats
[ ] Profit/Loss Report

Phase 7: Security
[ ] URL Manipulation Attack Blocked
[ ] Admin Cannot Change Own Role
[ ] Admin Cannot Delete Superadmin

Phase 8: Edge Cases
[ ] Empty Admin Data
[ ] Cannot Delete Admin with Data
[ ] Data Reassignment

OVERALL RESULT: [ PASS / FAIL ]

Notes:
_________________________________
_________________________________
```

---

## 🐛 Common Issues & Fixes

### Issue 1: "Column 'role' not found"
**Fix:**
```bash
php artisan migrate
```

### Issue 2: "Column 'admin_id' not found"
**Fix:**
```bash
php artisan migrate:fresh
# WARNING: This will delete all data!
```

### Issue 3: Admin sees no data
**Fix:**
```sql
-- Assign existing data to admin
UPDATE products SET admin_id = {admin_user_id} WHERE admin_id IS NULL;
UPDATE orders SET admin_id = {admin_user_id} WHERE admin_id IS NULL;
UPDATE expenses SET admin_id = {admin_user_id} WHERE admin_id IS NULL;
```

### Issue 4: Helper functions not found
**Fix:**
```bash
composer dump-autoload
php artisan config:clear
```

### Issue 5: Middleware not working
**Fix:**
- Check `app/Http/Kernel.php` has middleware registered
- Clear route cache: `php artisan route:clear`

---

## 🚀 Post-Testing Actions

After all tests pass:

1. **Backup Database**
   ```bash
   # Create backup before deploying
   ```

2. **Update Frontend**
   - Hide "User Management" menu for admin users
   - Show role-specific dashboards
   - Update UI based on `isSuperAdmin()` helper

3. **Deploy to Production**
   - Run migration on production
   - Test with real users
   - Monitor for issues

4. **Train Users**
   - Explain superadmin vs admin roles
   - Show data scoping behavior
   - Demonstrate user management (superadmin only)

---

## 📞 Support

If tests fail or you encounter issues:
1. Check the error logs: `storage/logs/laravel.log`
2. Review the implementation docs: `MULTI_USER_IMPLEMENTATION.md`
3. Verify all files are in place
4. Ensure migration ran successfully
