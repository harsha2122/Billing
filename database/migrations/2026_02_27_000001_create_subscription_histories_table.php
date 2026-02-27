<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateSubscriptionHistoriesTable extends Migration
{
    public function up()
    {
        if (!Schema::hasTable('subscription_histories')) {
            Schema::create('subscription_histories', function (Blueprint $table) {
                $table->id();
                $table->bigInteger('company_id')->unsigned();
                $table->bigInteger('subscription_plan_id')->unsigned()->nullable();
                $table->enum('action', ['assigned', 'renewed', 'upgraded', 'downgraded', 'expired']);
                $table->bigInteger('previous_plan_id')->unsigned()->nullable();
                $table->date('previous_expiry')->nullable();
                $table->date('new_expiry')->nullable();
                $table->unsignedInteger('carried_over_days')->default(0);
                $table->timestamps();

                $table->foreign('company_id')->references('id')->on('companies')->onDelete('cascade');
                $table->foreign('subscription_plan_id')->references('id')->on('subscription_plans')->onDelete('set null');
            });
        }
    }

    public function down()
    {
        Schema::dropIfExists('subscription_histories');
    }
}
