<?php

namespace App\Console\Commands;

use App\Models\Permission;
use App\Models\Role;
use App\Scopes\CompanyScope;
use Illuminate\Console\Command;

class FixTenantAdminPermissions extends Command
{
    protected $signature = 'fix:tenant-admin-permissions {--company_id= : Fix specific company only}';
    protected $description = 'Fix tenant admin roles by attaching all permissions';

    public function handle()
    {
        $companyId = $this->option('company_id');

        // Get all permissions
        $allPermissionIds = Permission::pluck('id')->toArray();

        if (empty($allPermissionIds)) {
            $this->error('No permissions found in database. Please run seeders first.');
            return 1;
        }

        // Get admin roles for tenant companies (non-global)
        $query = Role::withoutGlobalScope(CompanyScope::class)
            ->where('name', 'admin')
            ->whereNotNull('company_id');

        if ($companyId) {
            $query->where('company_id', $companyId);
        }

        $adminRoles = $query->get();

        if ($adminRoles->isEmpty()) {
            $this->info('No tenant admin roles found to fix.');
            return 0;
        }

        $this->info('Found ' . $adminRoles->count() . ' tenant admin role(s) to fix.');

        $fixed = 0;
        foreach ($adminRoles as $role) {
            // Check current permission count
            $currentPerms = $role->perms()->count();

            // Attach all permissions
            $role->savePermissions($allPermissionIds);

            $newPerms = $role->perms()->count();

            $this->line("Company ID {$role->company_id}: {$currentPerms} -> {$newPerms} permissions");
            $fixed++;
        }

        $this->info("Successfully fixed {$fixed} tenant admin role(s) with " . count($allPermissionIds) . " permissions each.");

        return 0;
    }
}
