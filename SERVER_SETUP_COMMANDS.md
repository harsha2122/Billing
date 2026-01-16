# Server Setup Commands - Database Migration & Seeding

## OPTION 1: Fresh Install (Recommended for New Server)

### Step 1: Run Migrations
```bash
php artisan migrate:fresh
```

### Step 2: Run All Seeders (Creates Everything)
```bash
php artisan db:seed
```

**This creates:**
- ✅ Units, Warehouses, Currencies, Languages
- ✅ Payment Modes
- ✅ Company (Stockifly)
- ✅ Roles (admin, salesman, stock_manager)
- ✅ Admin User: `admin@example.com` / `12345678`
- ✅ Sample products, orders, customers, suppliers

### Step 3: Create SuperAdmin
```bash
php artisan superadmin:create superadmin@example.com YourPassword123
```

**Or with custom name:**
```bash
php artisan superadmin:create superadmin@example.com YourPassword123 --name="Your Name"
```

---

## OPTION 2: Only Create Admin Users (Existing Database)

### Create SuperAdmin Only
```bash
php artisan db:seed --class=AdminUsersSeeder
```

**This creates:**
- ✅ SuperAdmin: `superadmin@example.com` / `12345678`
- ✅ Admin: `admin@example.com` / `12345678`

**OR use command:**
```bash
php artisan superadmin:create your-email@example.com YourPassword
```

---

## OPTION 3: Step-by-Step Seeding

### Run Individual Seeders in Order
```bash
php artisan db:seed --class=UnitTableSeeder
php artisan db:seed --class=WarehouseTableSeeder
php artisan db:seed --class=CurrencyTableSeeder
php artisan db:seed --class=LangTableSeeder
php artisan db:seed --class=PaymentModesTableSeeder
php artisan db:seed --class=CompanyTableSeeder
php artisan db:seed --class=RolesTableSeeder
php artisan db:seed --class=UsersTableSeeder
php artisan db:seed --class=AdminUsersSeeder
```

---

## Default Credentials Created

### SuperAdmin (for SaaS mode)
- **Email:** `superadmin@example.com`
- **Password:** `12345678`
- **Type:** super_admins
- **Access:** All companies

### Admin (for regular company)
- **Email:** `admin@example.com`
- **Password:** `12345678`
- **Type:** staff_members
- **Role:** admin
- **Company:** Stockifly

### Other Users (from UsersTableSeeder)
- **Salesman:** `salesman@example.com` / `12345678`
- **Stock Manager:** `stockmanager@example.com` / `12345678`

---

## After Seeding

### Clear Caches
```bash
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
```

### Set Permissions
```bash
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
```

### Create Storage Link
```bash
php artisan storage:link
```

---

## Production Server Complete Setup

```bash
# 1. Navigate to project
cd /path/to/billing

# 2. Pull latest code
git pull origin claude/fix-login-page-loader-fHR9T

# 3. Install dependencies
composer install --no-dev --optimize-autoloader
npm install
npm run prod

# 4. Setup database (FRESH INSTALL ONLY)
php artisan migrate:fresh
php artisan db:seed

# 5. Create SuperAdmin (if SaaS mode)
php artisan superadmin:create admin@yourdomain.com SecurePassword123

# 6. Clear caches
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# 7. Set permissions
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

# 8. Create storage link
php artisan storage:link
```

---

## Check App Type

```bash
grep APP_TYPE .env
```

- `saas` → Use SuperAdmin (`superadmin@example.com`)
- `non-saas` → Use Admin (`admin@example.com`)

---

## Create Custom SuperAdmin

```bash
php artisan superadmin:create your-email@domain.com YourSecurePassword --name="Your Name"
```

---

## IMPORTANT NOTES

⚠️ **DO NOT run `php artisan db:seed` on production if you have existing data!**
⚠️ **`migrate:fresh` will DELETE all existing data!**
⚠️ **Change default passwords immediately after first login!**

For existing databases, use:
```bash
php artisan db:seed --class=AdminUsersSeeder
```

Or create superadmin individually:
```bash
php artisan superadmin:create your-email@example.com password123
```
