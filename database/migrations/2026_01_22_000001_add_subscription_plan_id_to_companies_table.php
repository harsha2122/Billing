<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddSubscriptionPlanIdToCompaniesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('companies', function (Blueprint $table) {
            if (!Schema::hasColumn('companies', 'subscription_plan_id')) {
                $table->bigInteger('subscription_plan_id')->unsigned()->nullable()->after('warehouse_id');
                $table->foreign('subscription_plan_id')->references('id')->on('subscription_plans')->onDelete('set null')->onUpdate('cascade');
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
        Schema::table('companies', function (Blueprint $table) {
            if (Schema::hasColumn('companies', 'subscription_plan_id')) {
                $table->dropForeign(['subscription_plan_id']);
                $table->dropColumn('subscription_plan_id');
            }
        });
    }
}
