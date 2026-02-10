<?php

namespace Database\Seeders;

use App\Models\PosInvoiceTemplate;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PosInvoiceTemplateSeeder extends Seeder
{
    public function run()
    {
        // Only seed if table is empty
        if (PosInvoiceTemplate::count() > 0) {
            return;
        }

        $companyId = DB::table('companies')->first()->id ?? null;

        $templates = [
            [
                'company_id' => $companyId,
                'name' => 'GST Distributor Invoice',
                'slug' => 'gst-distributor',
                'template_type' => 'a4',
                'accent_color' => '#0d9488',
                'show_hsn' => true,
                'show_gst_breakup' => true,
                'show_eway_bill' => true,
                'show_irn' => true,
                'show_qr_code' => true,
                'show_amount_in_words' => true,
                'show_authorized_signatory' => true,
                'show_terms_conditions' => true,
                'is_default' => false,
            ],
            [
                'company_id' => $companyId,
                'name' => 'Double Divine',
                'slug' => 'double-divine',
                'template_type' => 'a4',
                'accent_color' => '#dc3545',
                'show_hsn' => true,
                'show_gst_breakup' => false,
                'show_eway_bill' => false,
                'show_irn' => false,
                'show_qr_code' => false,
                'show_amount_in_words' => true,
                'show_authorized_signatory' => true,
                'show_terms_conditions' => true,
                'is_default' => false,
            ],
            [
                'company_id' => $companyId,
                'name' => 'GST Theme 2',
                'slug' => 'gst-theme-2',
                'template_type' => 'a4',
                'accent_color' => '#6c63ff',
                'show_hsn' => true,
                'show_gst_breakup' => false,
                'show_eway_bill' => false,
                'show_irn' => false,
                'show_qr_code' => false,
                'show_amount_in_words' => true,
                'show_authorized_signatory' => true,
                'show_terms_conditions' => true,
                'is_default' => false,
            ],
            [
                'company_id' => $companyId,
                'name' => 'GST Theme 1',
                'slug' => 'gst-theme-1',
                'template_type' => 'a4',
                'accent_color' => '#5b57d1',
                'show_hsn' => true,
                'show_gst_breakup' => false,
                'show_eway_bill' => false,
                'show_irn' => false,
                'show_qr_code' => false,
                'show_amount_in_words' => true,
                'show_authorized_signatory' => true,
                'show_terms_conditions' => true,
                'is_default' => false,
            ],
            [
                'company_id' => $companyId,
                'name' => 'Landscape Theme 1',
                'slug' => 'landscape-theme-1',
                'template_type' => 'landscape',
                'accent_color' => '#2196F3',
                'show_hsn' => true,
                'show_gst_breakup' => false,
                'show_eway_bill' => false,
                'show_irn' => false,
                'show_qr_code' => false,
                'show_amount_in_words' => true,
                'show_authorized_signatory' => true,
                'show_terms_conditions' => true,
                'is_default' => false,
            ],
            [
                'company_id' => $companyId,
                'name' => 'Tally Theme',
                'slug' => 'tally-theme',
                'template_type' => 'a4',
                'accent_color' => '#1976D2',
                'show_hsn' => true,
                'show_gst_breakup' => false,
                'show_eway_bill' => false,
                'show_irn' => false,
                'show_qr_code' => false,
                'show_amount_in_words' => true,
                'show_authorized_signatory' => true,
                'show_terms_conditions' => true,
                'is_default' => true,
            ],
        ];

        foreach ($templates as $template) {
            PosInvoiceTemplate::create($template);
        }
    }
}
