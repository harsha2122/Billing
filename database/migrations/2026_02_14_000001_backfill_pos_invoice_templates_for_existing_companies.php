<?php

use Database\Seeders\PosInvoiceTemplateSeeder;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        if (!Schema::hasTable('pos_invoice_templates')) {
            return;
        }

        // Get all non-global companies that don't have any invoice templates
        $companyIds = DB::table('companies')
            ->where('is_global', 0)
            ->whereNotIn('id', function ($query) {
                $query->select('company_id')
                    ->from('pos_invoice_templates')
                    ->distinct();
            })
            ->pluck('id');

        foreach ($companyIds as $companyId) {
            PosInvoiceTemplateSeeder::seedForCompany($companyId);
        }
    }

    public function down()
    {
        // No rollback needed — templates created by this migration
        // are indistinguishable from manually created ones
    }
};
