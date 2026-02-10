<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class WidenStateCodeColumn extends Migration
{
    public function up()
    {
        Schema::table('warehouses', function (Blueprint $table) {
            $table->string('state_code', 10)->nullable()->default(null)->change();
        });

        Schema::table('companies', function (Blueprint $table) {
            $table->string('state_code', 10)->nullable()->default(null)->change();
        });
    }

    public function down()
    {
        Schema::table('warehouses', function (Blueprint $table) {
            $table->string('state_code', 5)->nullable()->default(null)->change();
        });

        Schema::table('companies', function (Blueprint $table) {
            $table->string('state_code', 5)->nullable()->default(null)->change();
        });
    }
}
