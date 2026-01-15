<?php

namespace App\Console\Commands;

use App\Models\Company;
use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;

class CreateSuperAdmin extends Command
{
    protected $signature = 'superadmin:create {email} {password} {--name=SuperAdmin}';
    protected $description = 'Create a superadmin user';

    public function handle()
    {
        $email = $this->argument('email');
        $password = $this->argument('password');
        $name = $this->option('name');

        if (User::where('email', $email)->exists()) {
            $this->error('User with this email already exists!');
            return 1;
        }

        $superAdmin = new User();
        $superAdmin->name = $name;
        $superAdmin->email = $email;
        $superAdmin->password = Hash::make($password);
        $superAdmin->user_type = 'super_admins';
        $superAdmin->is_superadmin = true;
        $superAdmin->company_id = null;
        $superAdmin->save();

        $this->info('SuperAdmin created successfully!');
        $this->info('Email: ' . $email);
        $this->info('Password: ' . $password);

        return 0;
    }
}
