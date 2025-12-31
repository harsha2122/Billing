<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

class ResetSuperAdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Find or create superadmin
        $superadmin = User::where('role', 'superadmin')->first();

        if (!$superadmin) {
            // Get first user and make them superadmin
            $superadmin = User::orderBy('id', 'asc')->first();

            if (!$superadmin) {
                // Create brand new superadmin
                $company = DB::table('companies')->first();

                $superadmin = new User();
                $superadmin->company_id = $company ? $company->id : null;
                $superadmin->name = 'Super Admin';
                $superadmin->email = 'superadmin@billing.com';
                $superadmin->password = Hash::make('superadmin123');
                $superadmin->role = 'superadmin';
                $superadmin->user_type = 'staff_members';
                $superadmin->status = 'enabled';
                $superadmin->login_enabled = true;
                $superadmin->save();

                echo "✅ NEW SUPERADMIN CREATED!\n";
            } else {
                $superadmin->role = 'superadmin';
                $superadmin->save();
                echo "✅ FIRST USER PROMOTED TO SUPERADMIN!\n";
            }
        }

        // Reset superadmin credentials
        $superadmin->name = 'Super Admin';
        $superadmin->email = 'superadmin@billing.com';
        $superadmin->password = Hash::make('superadmin123');
        $superadmin->role = 'superadmin';
        $superadmin->user_type = 'staff_members';
        $superadmin->status = 'enabled';
        $superadmin->login_enabled = true;
        $superadmin->save();

        echo "\n";
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
        echo "       🎉 SUPERADMIN CREDENTIALS 🎉\n";
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
        echo "\n";
        echo "  📧 Email:    superadmin@billing.com\n";
        echo "  🔑 Password: superadmin123\n";
        echo "  👤 Role:     superadmin\n";
        echo "  🆔 User ID:  {$superadmin->id}\n";
        echo "\n";
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
        echo "\n";
        echo "✅ Credentials updated successfully!\n";
        echo "✅ You can now login to your dashboard\n";
        echo "\n";

        // Assign all existing data to superadmin
        $superadminId = $superadmin->id;

        $tables = [
            'products',
            'orders',
            'expenses',
            'brands',
            'categories',
            'taxes',
            'units',
            'expense_categories',
            'warehouses',
            'warehouse_stocks',
            'stock_history',
            'stock_adjustments',
            'payments',
            'order_payments'
        ];

        foreach ($tables as $table) {
            if (DB::getSchemaBuilder()->hasTable($table) && DB::getSchemaBuilder()->hasColumn($table, 'admin_id')) {
                $count = DB::table($table)->whereNull('admin_id')->update(['admin_id' => $superadminId]);
                if ($count > 0) {
                    echo "  → Assigned {$count} records in {$table}\n";
                }
            }
        }

        echo "\n✅ All existing data assigned to superadmin!\n\n";
    }
}
