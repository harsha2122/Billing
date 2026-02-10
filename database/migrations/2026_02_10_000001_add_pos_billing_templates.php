<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddPosBillingTemplates extends Migration
{
    public function up()
    {
        // Add HSN/SAC to products
        Schema::table('products', function (Blueprint $table) {
            $table->string('hsn_sac_code', 20)->nullable()->default(null)->after('item_code');
        });

        // Add GSTIN and State to companies
        Schema::table('companies', function (Blueprint $table) {
            $table->string('gstin', 20)->nullable()->default(null)->after('address');
            $table->string('state', 50)->nullable()->default(null)->after('gstin');
            $table->string('state_code', 5)->nullable()->default(null)->after('state');
        });

        // Add GSTIN and State to warehouses
        Schema::table('warehouses', function (Blueprint $table) {
            $table->string('gstin', 20)->nullable()->default(null)->after('address');
            $table->string('state', 50)->nullable()->default(null)->after('gstin');
            $table->string('state_code', 5)->nullable()->default(null)->after('state');
        });

        // Add e-way bill, IRN, QR code to orders
        Schema::table('orders', function (Blueprint $table) {
            $table->string('e_way_bill_number', 50)->nullable()->default(null)->after('terms_condition');
            $table->string('irn_number', 100)->nullable()->default(null)->after('e_way_bill_number');
            $table->text('qr_code_data')->nullable()->default(null)->after('irn_number');
            $table->bigInteger('pos_invoice_template_id')->unsigned()->nullable()->default(null)->after('qr_code_data');
        });

        // Add HSN/SAC snapshot to order_items (captured at order time)
        Schema::table('order_items', function (Blueprint $table) {
            $table->string('hsn_sac_code', 20)->nullable()->default(null)->after('subtotal');
        });

        // Create pos_invoice_templates table
        Schema::create('pos_invoice_templates', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('company_id')->unsigned()->nullable();
            $table->string('name', 100);
            $table->string('slug', 100);
            $table->string('template_type', 20)->default('a4'); // a4, thermal, landscape
            $table->string('accent_color', 20)->default('#1890ff');
            $table->boolean('show_hsn')->default(true);
            $table->boolean('show_gst_breakup')->default(false);
            $table->boolean('show_eway_bill')->default(false);
            $table->boolean('show_irn')->default(false);
            $table->boolean('show_qr_code')->default(false);
            $table->boolean('show_amount_in_words')->default(true);
            $table->boolean('show_authorized_signatory')->default(true);
            $table->boolean('show_terms_conditions')->default(true);
            $table->boolean('is_default')->default(false);
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('pos_invoice_templates');

        Schema::table('order_items', function (Blueprint $table) {
            $table->dropColumn('hsn_sac_code');
        });

        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn(['e_way_bill_number', 'irn_number', 'qr_code_data', 'pos_invoice_template_id']);
        });

        Schema::table('warehouses', function (Blueprint $table) {
            $table->dropColumn(['gstin', 'state', 'state_code']);
        });

        Schema::table('companies', function (Blueprint $table) {
            $table->dropColumn(['gstin', 'state', 'state_code']);
        });

        Schema::table('products', function (Blueprint $table) {
            $table->dropColumn('hsn_sac_code');
        });
    }
}
