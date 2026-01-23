<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddMissingColumnsToSubscriptionPlans extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('subscription_plans', function (Blueprint $table) {
            // Add max_users if it doesn't exist
            if (!Schema::hasColumn('subscription_plans', 'max_users')) {
                $table->integer('max_users')->default(0)->after('max_products');
            }

            // Add max_warehouses if it doesn't exist
            if (!Schema::hasColumn('subscription_plans', 'max_warehouses')) {
                $table->integer('max_warehouses')->default(1)->after('max_users');
            }

            // Add monthly_price if it doesn't exist
            if (!Schema::hasColumn('subscription_plans', 'monthly_price')) {
                $table->decimal('monthly_price', 10, 2)->default(0)->after('max_warehouses');
            }

            // Add annual_price if it doesn't exist
            if (!Schema::hasColumn('subscription_plans', 'annual_price')) {
                $table->decimal('annual_price', 10, 2)->default(0)->after('monthly_price');
            }
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('subscription_plans', function (Blueprint $table) {
            $columns = ['max_users', 'max_warehouses', 'monthly_price', 'annual_price'];
            foreach ($columns as $column) {
                if (Schema::hasColumn('subscription_plans', $column)) {
                    $table->dropColumn($column);
                }
            }
        });
    }
}
