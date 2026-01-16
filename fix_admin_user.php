<?php

// Fix admin user - assign warehouse, company, and role
// Run with: php fix_admin_user.php

require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;
use App\Models\Company;
use App\Models\Warehouse;
use App\Models\Role;
use Illuminate\Support\Facades\DB;

echo "Starting admin user fix...\n";

try {
    // Get first company
    $company = Company::first();

    if (!$company) {
        echo "ERROR: No company found! Please create a company first.\n";
        echo "Run: php artisan admin:create \"Company Name\" admin@email.com password\n";
        exit(1);
    }

    echo "Found company: {$company->name} (ID: {$company->id})\n";

    // Check if company has currency
    if (!$company->currency_id) {
        echo "  ! Company has no currency. Setting default...\n";
        $currency = DB::table('currencies')->where('code', 'USD')->first();
        if ($currency) {
            $company->currency_id = $currency->id;
            $company->save();
            echo "  ✓ Set currency to USD (ID: {$currency->id})\n";
        } else {
            echo "  ! WARNING: No currencies found in database!\n";
        }
    }

    // Get first warehouse
    $warehouse = Warehouse::where('company_id', $company->id)->first();

    if (!$warehouse) {
        echo "ERROR: No warehouse found for company! Creating one...\n";

        $warehouse = new Warehouse();
        $warehouse->company_id = $company->id;
        $warehouse->name = $company->name . ' Warehouse';
        $warehouse->slug = strtolower(str_replace(' ', '-', $company->name));
        $warehouse->email = $company->email;
        $warehouse->phone = '1234567890';
        $warehouse->address = 'Default Address';
        $warehouse->save();

        echo "Created warehouse: {$warehouse->name} (ID: {$warehouse->id})\n";

        // Update company warehouse_id
        $company->warehouse_id = $warehouse->id;
        $company->save();
        echo "Updated company warehouse_id\n";
    } else {
        echo "Found warehouse: {$warehouse->name} (ID: {$warehouse->id})\n";
    }

    // Get admin role
    $adminRole = Role::where('company_id', $company->id)
        ->where('name', 'admin')
        ->first();

    if (!$adminRole) {
        echo "ERROR: No admin role found! Creating one...\n";

        $adminRole = new Role();
        $adminRole->company_id = $company->id;
        $adminRole->name = 'admin';
        $adminRole->display_name = 'Admin';
        $adminRole->description = 'Administrator role';
        $adminRole->save();

        echo "Created admin role (ID: {$adminRole->id})\n";

        // Give admin all permissions
        echo "Assigning all permissions to admin role...\n";
        $allPermissions = DB::table('permissions')->pluck('id')->toArray();
        $adminRole->perms()->sync($allPermissions);
        echo "  ✓ Assigned " . count($allPermissions) . " permissions\n";
    } else {
        echo "Found admin role: {$adminRole->display_name} (ID: {$adminRole->id})\n";

        // Check if role has permissions
        $permissionCount = $adminRole->perms()->count();
        if ($permissionCount == 0) {
            echo "  ! Admin role has no permissions. Assigning all...\n";
            $allPermissions = DB::table('permissions')->pluck('id')->toArray();
            $adminRole->perms()->sync($allPermissions);
            echo "  ✓ Assigned " . count($allPermissions) . " permissions\n";
        } else {
            echo "  ✓ Role has {$permissionCount} permissions\n";
        }
    }

    // Find admin users without proper setup
    $admins = User::where('user_type', 'staff_members')
        ->where(function($query) {
            $query->whereNull('warehouse_id')
                  ->orWhereNull('role_id')
                  ->orWhereNull('company_id');
        })
        ->get();

    if ($admins->isEmpty()) {
        echo "No admin users need fixing.\n";
        exit(0);
    }

    echo "\nFound " . $admins->count() . " admin user(s) to fix:\n";

    foreach ($admins as $admin) {
        echo "\nFixing user: {$admin->email}\n";
        echo "  - Current warehouse_id: " . ($admin->warehouse_id ?: 'NULL') . "\n";
        echo "  - Current role_id: " . ($admin->role_id ?: 'NULL') . "\n";
        echo "  - Current company_id: " . ($admin->company_id ?: 'NULL') . "\n";

        $admin->company_id = $company->id;
        $admin->warehouse_id = $warehouse->id;
        $admin->role_id = $adminRole->id;
        $admin->status = 'enabled';
        $admin->login_enabled = 1;
        $admin->save();

        echo "  ✓ Updated warehouse_id: {$warehouse->id}\n";
        echo "  ✓ Updated role_id: {$adminRole->id}\n";
        echo "  ✓ Updated company_id: {$company->id}\n";

        // Attach role if not already attached
        if (!$admin->hasRole('admin')) {
            $admin->attachRole($adminRole->id);
            echo "  ✓ Attached admin role\n";
        }
    }

    echo "\n✅ Admin user(s) fixed successfully!\n";
    echo "\nYou can now login with these credentials:\n";

    foreach ($admins as $admin) {
        echo "  Email: {$admin->email}\n";
    }

    echo "\nIf you don't know the password, reset it with:\n";
    echo "  UPDATE users SET password = '$2y$10\$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' WHERE email = 'admin@example.com';\n";
    echo "  (This sets password to: password)\n";

} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    echo $e->getTraceAsString() . "\n";
    exit(1);
}
