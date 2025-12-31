<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

class SuperAdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Check if superadmin already exists
        $superadmin = User::where('role', 'superadmin')->first();

        if ($superadmin) {
            echo "✅ Superadmin already exists!\n";
            echo "Email: {$superadmin->email}\n";
            echo "You can reset the password if needed.\n";
            return;
        }

        // Get the first user or create new superadmin
        $firstUser = User::orderBy('id', 'asc')->first();

        if ($firstUser) {
            // Update first user to superadmin
            $firstUser->role = 'superadmin';
            $firstUser->name = 'Super Admin';
            $firstUser->email = 'superadmin@billing.com';
            $firstUser->password = Hash::make('superadmin123');
            $firstUser->user_type = 'staff_members';
            $firstUser->status = 'enabled';
            $firstUser->save();

            echo "✅ First user updated to Superadmin!\n";
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
            echo "📧 Email: superadmin@billing.com\n";
            echo "🔑 Password: superadmin123\n";
            echo "👤 Role: superadmin\n";
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
        } else {
            // Create new superadmin
            $company = DB::table('companies')->first();

            $superadmin = User::create([
                'company_id' => $company ? $company->id : null,
                'name' => 'Super Admin',
                'email' => 'superadmin@billing.com',
                'password' => Hash::make('superadmin123'),
                'role' => 'superadmin',
                'user_type' => 'staff_members',
                'status' => 'enabled',
                'login_enabled' => true,
            ]);

            echo "✅ New Superadmin created!\n";
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
            echo "📧 Email: superadmin@billing.com\n";
            echo "🔑 Password: superadmin123\n";
            echo "👤 Role: superadmin\n";
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
        }

        // Update all existing data to belong to superadmin
        $superadminId = User::where('role', 'superadmin')->first()->id;

        DB::table('products')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('orders')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('expenses')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('brands')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('categories')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('taxes')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('units')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('expense_categories')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('warehouses')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('warehouse_stocks')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('stock_history')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('stock_adjustments')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('payments')->whereNull('admin_id')->update(['admin_id' => $superadminId]);
        DB::table('order_payments')->whereNull('admin_id')->update(['admin_id' => $superadminId]);

        echo "\n✅ All existing data assigned to superadmin!\n";
    }
}
