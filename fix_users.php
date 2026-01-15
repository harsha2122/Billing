<?php

// Run this with: php fix_users.php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

// Delete existing users
DB::table('users')->whereIn('email', ['admin@example.com', 'superadmin@example.com'])->delete();

// Get first warehouse and company
$warehouse = DB::table('warehouses')->first();
$company = DB::table('companies')->first();

// Generate correct password hash for "12345678"
$passwordHash = Hash::make('12345678');
echo "Generated password hash: $passwordHash\n";

// Insert SuperAdmin - bypass model
DB::table('users')->insert([
    'name' => 'SuperAdmin',
    'email' => 'superadmin@example.com',
    'password' => $passwordHash,
    'user_type' => 'super_admins',
    'is_superadmin' => 1,
    'status' => 'enabled',
    'login_enabled' => 1,
    'company_id' => null,
    'warehouse_id' => null,
    'created_at' => now(),
    'updated_at' => now(),
]);

// Insert Admin - bypass model
DB::table('users')->insert([
    'name' => 'Admin',
    'email' => 'admin@example.com',
    'password' => $passwordHash,
    'user_type' => 'staff_members',
    'is_superadmin' => 0,
    'status' => 'enabled',
    'phone' => '1234567890',
    'login_enabled' => 1,
    'company_id' => $company ? $company->id : null,
    'warehouse_id' => $warehouse ? $warehouse->id : null,
    'created_at' => now(),
    'updated_at' => now(),
]);

echo "Users created successfully!\n";
echo "SuperAdmin: superadmin@example.com / 12345678\n";
echo "Admin: admin@example.com / 12345678\n";
