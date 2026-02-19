<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up()
    {
        Schema::table('companies', function (Blueprint $table) {
            $table->unsignedInteger('max_devices')->default(1)->after('business_type');
        });

        // Set existing companies to max_devices = 1
        DB::table('companies')->update(['max_devices' => 1]);

        Schema::create('user_sessions', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('company_id');
            $table->string('session_token', 64)->unique();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->timestamp('last_active_at')->nullable();
            $table->timestamps();

            $table->index(['user_id']);
            $table->index(['company_id']);
        });
    }

    public function down()
    {
        Schema::dropIfExists('user_sessions');

        Schema::table('companies', function (Blueprint $table) {
            $table->dropColumn('max_devices');
        });
    }
};
