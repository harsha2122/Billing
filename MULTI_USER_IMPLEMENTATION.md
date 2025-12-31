# Multi-User Role-Based System Implementation

## Overview
This document outlines the implementation of a multi-user role-based system for the Laravel billing + POS application.

## Roles
- **superadmin**: Full access to all data and user management
- **admin**: Access only to their own data

## Database Changes

### Migration: `2025_12_30_184801_update_tables_for_multi_user_system.php`

#### Changes Made:
1. **users table**: Added `role` enum column ('superadmin', 'admin')
2. **Core tables**: Added `admin_id` foreign key to:
   - brands
   - categories
   - taxes
   - units
   - products
   - orders
   - expenses
   - expense_categories
   - warehouses
   - warehouse_stocks
   - stock_history
   - stock_adjustments
   - payments
   - order_payments

## Code Architecture

### 1. AdminScope (`app/Scopes/AdminScope.php`)
Global scope that automatically filters data based on user role:
- **Superadmin**: See all data (no filtering)
- **Admin**: See only their own data (filtered by `admin_id`)
- **Users table**: Admins see themselves + users they created (via `created_by`)

### 2. HasAdminScope Trait (`app/Traits/HasAdminScope.php`)
Trait applied to models that need role-based data scoping:
- Automatically applies `AdminScope`
- Auto-assigns `admin_id` on record creation for admin users
- Auto-assigns `created_by` for users table
- Provides `admin()` relationship

### 3. Models Updated
The following models now use `HasAdminScope` trait:
- Product
- Order
- Expense
- Brand
- Category
- Tax
- Unit
- ExpenseCategory
- User
- Warehouse
- Payment
- OrderPayment
- WarehouseStock
- StockHistory
- StockAdjustment

### 4. Middleware

#### CheckSuperAdmin (`app/Http/Middleware/CheckSuperAdmin.php`)
Restricts access to superadmin users only.

**Usage in routes:**
```php
Route::middleware(['check.superadmin'])->group(function () {
    // Superadmin-only routes
});
```

#### CheckAdminOrSuperAdmin (`app/Http/Middleware/CheckAdminOrSuperAdmin.php`)
Restricts access to admin and superadmin users.

**Usage in routes:**
```php
Route::middleware(['check.admin'])->group(function () {
    // Admin and superadmin routes
});
```

## Controller Examples

### Example 1: Product Controller
```php
<?php

namespace App\Http\Controllers\Api;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    // Index - automatically filtered by AdminScope
    public function index(Request $request)
    {
        // Superadmin sees all products
        // Admin sees only their products (admin_id = auth()->id())
        $products = Product::with(['category', 'brand', 'unit'])
            ->paginate(10);
            
        return response()->json($products);
    }
    
    // Store - admin_id auto-assigned by HasAdminScope trait
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'item_code' => 'required|string|unique:products',
            // ... other fields
        ]);
        
        // admin_id is automatically set for admin users
        $product = Product::create($validated);
        
        return response()->json($product, 201);
    }
    
    // Show - automatically scoped
    public function show($id)
    {
        // Admin can only view their own products
        // Superadmin can view any product
        $product = Product::findOrFail($id);
        
        return response()->json($product);
    }
    
    // Update - automatically scoped
    public function update(Request $request, $id)
    {
        // Admin can only update their own products
        // Superadmin can update any product
        $product = Product::findOrFail($id);
        
        $validated = $request->validate([
            'name' => 'sometimes|string',
            // ... other fields
        ]);
        
        $product->update($validated);
        
        return response()->json($product);
    }
    
    // Delete - automatically scoped
    public function destroy($id)
    {
        // Admin can only delete their own products
        // Superadmin can delete any product
        $product = Product::findOrFail($id);
        $product->delete();
        
        return response()->json(['message' => 'Product deleted']);
    }
}
```

### Example 2: User Management Controller (Superadmin Only)
```php
<?php

namespace App\Http\Controllers\Api;

use App\Models\User;
use Illuminate\Http\Request;

class UserManagementController extends Controller
{
    public function __construct()
    {
        // Only superadmin can access these routes
        $this->middleware('check.superadmin');
    }
    
    // List all users
    public function index()
    {
        $users = User::with(['role', 'warehouse'])->paginate(20);
        return response()->json($users);
    }
    
    // Create new user
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:8',
            'role' => 'required|in:superadmin,admin',
            // ... other fields
        ]);
        
        $user = User::create($validated);
        
        return response()->json($user, 201);
    }
    
    // Update user role
    public function updateRole(Request $request, $id)
    {
        $validated = $request->validate([
            'role' => 'required|in:superadmin,admin',
        ]);
        
        $user = User::findOrFail($id);
        $user->update(['role' => $validated['role']]);
        
        return response()->json($user);
    }
    
    // Delete user
    public function destroy($id)
    {
        $user = User::findOrFail($id);
        
        // Prevent deleting yourself
        if ($user->id === auth()->id()) {
            return response()->json([
                'error' => 'Cannot delete your own account'
            ], 403);
        }
        
        $user->delete();
        
        return response()->json(['message' => 'User deleted']);
    }
}
```

### Example 3: Dashboard Controller
```php
<?php

namespace App\Http\Controllers\Api;

use App\Models\Product;
use App\Models\Order;
use App\Models\Expense;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function stats()
    {
        $user = auth()->user();
        
        if ($user->role === 'superadmin') {
            // Superadmin sees global stats
            $stats = [
                'total_products' => Product::count(),
                'total_orders' => Order::count(),
                'total_sales' => Order::where('order_type', 'sales')->sum('total'),
                'total_purchases' => Order::where('order_type', 'purchases')->sum('total'),
                'total_expenses' => Expense::sum('amount'),
                'total_users' => User::where('role', 'admin')->count(),
            ];
        } else {
            // Admin sees only their stats (automatically scoped)
            $stats = [
                'total_products' => Product::count(),
                'total_orders' => Order::count(),
                'total_sales' => Order::where('order_type', 'sales')->sum('total'),
                'total_purchases' => Order::where('order_type', 'purchases')->sum('total'),
                'total_expenses' => Expense::sum('amount'),
            ];
        }
        
        return response()->json($stats);
    }
}
```

## Route Protection Examples

### routes/api.php
```php
<?php

use Illuminate\Support\Facades\Route;

// Public routes
Route::post('/login', [AuthController::class, 'login']);

// Protected routes - require authentication
Route::middleware(['auth:api'])->group(function () {
    
    // Admin and Superadmin routes
    Route::middleware(['check.admin'])->group(function () {
        Route::apiResource('products', ProductController::class);
        Route::apiResource('orders', OrderController::class);
        Route::apiResource('expenses', ExpenseController::class);
        Route::get('/dashboard/stats', [DashboardController::class, 'stats']);
    });
    
    // Superadmin-only routes
    Route::middleware(['check.superadmin'])->prefix('admin')->group(function () {
        Route::apiResource('users', UserManagementController::class);
        Route::put('/users/{id}/role', [UserManagementController::class, 'updateRole']);
        Route::get('/global-stats', [DashboardController::class, 'globalStats']);
    });
});
```

## Security Features

### 1. Automatic Data Scoping
- Admin users automatically see only their data
- No need to manually add `where('admin_id', auth()->id())` in every query
- Prevents URL manipulation attacks

### 2. Automatic Owner Assignment
- When admin creates a record, `admin_id` is automatically set
- When admin creates a user, `created_by` is automatically set

### 3. Middleware Protection
- Routes are protected at the middleware level
- Unauthorized access returns 403 Forbidden

### 4. Model-Level Security
- Global scopes ensure data isolation
- Even if a developer forgets to add middleware, data is still scoped

## Migration Instructions

### Step 1: Run Migration
```bash
php artisan migrate
```

This will:
- Add `role` column to users table
- Add `admin_id` to all core tables
- Set first user as superadmin
- Assign existing data to first user

### Step 2: Update Routes
Add middleware to your routes as shown in the examples above.

### Step 3: Test
1. Login as superadmin - verify you can see all data
2. Create a new admin user
3. Login as admin - verify you only see your own data
4. Try to access another admin's data via URL - should fail

## Important Notes

### Existing Data
- All existing data will be assigned to the first user (superadmin)
- You may need to manually reassign data to appropriate admins

### POS Flow
- POS functionality remains intact
- Admin users can only process sales for their own products/customers
- Superadmin can process sales for any products/customers

### Company Scope
- The existing `CompanyScope` is still active
- `AdminScope` works alongside it for multi-tenancy

### Performance
- Global scopes add a WHERE clause to every query
- For large datasets, ensure proper indexing on `admin_id` columns

## Troubleshooting

### Issue: Admin can't see any data
**Solution**: Ensure the admin_id is set on existing records:
```php
// Run this in tinker or a seeder
$adminId = auth()->id();
Product::whereNull('admin_id')->update(['admin_id' => $adminId]);
```

### Issue: Superadmin can't see all data
**Solution**: Verify the user's role is exactly 'superadmin':
```php
$user = auth()->user();
dd($user->role); // Should be 'superadmin'
```

### Issue: Getting "Access denied" errors
**Solution**: Check middleware is correctly applied and user is authenticated.

## Future Enhancements

1. **Role Permissions**: Add granular permissions within admin role
2. **Data Sharing**: Allow admins to share specific records
3. **Audit Logging**: Track who created/modified records
4. **Bulk Assignment**: UI for superadmin to reassign data between admins
