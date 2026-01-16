# DEPLOY TO PRODUCTION - Remove Verify Purchase Page

## Issue
The production server (billing.growbizsell.com) is showing a "Verify Purchase" page at `/admin/verify`. This is OLD compiled frontend assets.

## Verified in Current Code
✅ No `/admin/verify` route exists in router files
✅ Default route redirects to `/admin/login`
✅ All verify/purchase logic is nulled in `resources/js/common/composable/modules.js`
✅ Frontend assets compiled successfully with NO verify routes

## Deploy Steps for Production Server

### 1. Pull Latest Code on Production
```bash
cd /path/to/billing/on/production
git pull origin claude/fix-login-page-loader-fHR9T
```

### 2. Install Dependencies (if needed)
```bash
composer install --optimize-autoloader --no-dev
npm install
```

### 3. Rebuild Frontend Assets
```bash
npm run prod
```

### 4. Clear All Caches
```bash
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
```

### 5. Clear Browser Cache
- Hard refresh: `Ctrl+Shift+R` (Windows) or `Cmd+Shift+R` (Mac)
- Or clear browser cache completely

### 6. Verify
- Navigate to `billing.growbizsell.com`
- Should redirect to `/admin/login` directly
- NO verify purchase page should appear

## If Still Showing Verify Page

Check if production has different code:
```bash
# On production server
grep -rn "verify" resources/js/main/router/ --include="*.js"
```

If it shows any verify routes, the production code is different from this repo. You need to replace it with this clean version.

## Current Router Configuration
- Default path `''` → redirects to `/admin/login`
- catchAll path `/:catchAll(.*)` → redirects to `/`
- NO verify routes exist anywhere
