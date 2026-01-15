<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminUsersSeeder extends Seeder
{
    public function run()
    {
        // Create SuperAdmin
        if (!User::where('email', 'superadmin@example.com')->exists()) {
            $superAdmin = new User();
            $superAdmin->name = 'SuperAdmin';
            $superAdmin->email = 'superadmin@example.com';
            $superAdmin->password = Hash::make('12345678');
            $superAdmin->user_type = 'super_admins';
            $superAdmin->is_superadmin = 1;
            $superAdmin->status = 'enabled';
            $superAdmin->login_enabled = 1;
            $superAdmin->company_id = null;
            $superAdmin->warehouse_id = null;
            $superAdmin->save();

            $this->command->info('SuperAdmin created: superadmin@example.com');
        } else {
            $this->command->info('SuperAdmin already exists: superadmin@example.com');
        }

        // Create Admin
        if (!User::where('email', 'admin@example.com')->exists()) {
            $admin = new User();
            $admin->name = 'Admin';
            $admin->email = 'admin@example.com';
            $admin->password = Hash::make('12345678');
            $admin->user_type = 'staff_members';
            $admin->is_superadmin = 0;
            $admin->status = 'enabled';
            $admin->phone = '1234567890';
            $admin->login_enabled = 1;
            $admin->company_id = 1;
            $admin->warehouse_id = 1;
            $admin->save();

            $this->command->info('Admin created: admin@example.com');
        } else {
            $this->command->info('Admin already exists: admin@example.com');
        }

        $this->command->info('Password for both users: 12345678');
    }
}
