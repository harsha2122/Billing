<?php

namespace Database\Seeders;

use App\Classes\Common;
use App\Models\Company;
use Illuminate\Database\Seeder;

class DefaultPaymentModesSeeder extends Seeder
{
    /**
     * Seed UPI, Bank Transfer, and Cash payment modes for every tenant company
     * that does not already have any payment modes.
     *
     * Safe to run multiple times — skips companies that already have modes.
     */
    public function run(): void
    {
        Company::withoutGlobalScope('company')
            ->where('is_global', 0)
            ->get()
            ->each(function (Company $company) {
                Common::insertDefaultPaymentModes($company);
            });
    }
}
