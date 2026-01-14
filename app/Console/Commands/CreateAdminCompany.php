<?php

namespace App\Console\Commands;

use App\Classes\Common;
use App\Models\Company;
use App\Models\Currency;
use App\Models\Lang;
use App\Models\Role;
use App\Models\User;
use App\Models\Warehouse;
use App\Scopes\CompanyScope;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class CreateAdminCompany extends Command
{
    protected $signature = 'admin:create {company_name} {email} {password} {--name=Admin}';
    protected $description = 'Create a new admin company with admin user';

    public function handle()
    {
        $companyName = $this->argument('company_name');
        $email = $this->argument('email');
        $password = $this->argument('password');
        $adminName = $this->option('name');

        if (User::where('email', $email)->exists()) {
            $this->error('User with this email already exists!');
            return 1;
        }

        DB::beginTransaction();
        try {
            // Create Company
            $company = new Company();
            $company->name = $companyName;
            $company->short_name = $companyName;
            $company->email = $email;
            $company->is_global = 0;
            $company->status = 'active';
            $company->verified = true;
            $company->save();

            // Create Warehouse
            $warehouse = new Warehouse();
            $warehouse->company_id = $company->id;
            $warehouse->name = $companyName . ' Warehouse';
            $warehouse->slug = strtolower(str_replace(' ', '-', $companyName));
            $warehouse->email = $email;
            $warehouse->phone = '1234567890';
            $warehouse->address = 'Address';
            $warehouse->save();

            // Add Currencies
            Common::addCurrencies($company);

            // Update company warehouse
            $company->warehouse_id = $warehouse->id;
            $company->save();

            // Create Admin Role
            $adminRole = new Role();
            $adminRole->company_id = $company->id;
            $adminRole->name = 'admin';
            $adminRole->display_name = 'Admin';
            $adminRole->description = 'Admin role';
            $adminRole->save();

            // Create Admin User
            $admin = new User();
            $admin->company_id = $company->id;
            $admin->warehouse_id = $warehouse->id;
            $admin->role_id = $adminRole->id;
            $admin->name = $adminName;
            $admin->email = $email;
            $admin->password = Hash::make($password);
            $admin->user_type = 'staff_members';
            $admin->is_superadmin = false;
            $admin->status = 'enabled';
            $admin->save();

            // Update company admin_id
            $company->admin_id = $admin->id;
            $company->save();

            // Insert init settings
            Common::insertInitSettings($company);

            // Create walk-in customer
            Common::createCompanyWalkInCustomer($company);

            DB::commit();

            $this->info('Admin company created successfully!');
            $this->info('Company: ' . $companyName);
            $this->info('Admin Email: ' . $email);
            $this->info('Admin Password: ' . $password);

            return 0;
        } catch (\Exception $e) {
            DB::rollBack();
            $this->error('Failed to create admin company: ' . $e->getMessage());
            return 1;
        }
    }
}
