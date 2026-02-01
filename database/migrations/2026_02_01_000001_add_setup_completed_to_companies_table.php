<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddSetupCompletedToCompaniesTable extends Migration
{
    public function up()
    {
        Schema::table('companies', function (Blueprint $table) {
            $table->boolean('setup_completed')->default(false)->after('status');
        });

        // Mark existing companies as setup completed
        DB::table('companies')->update(['setup_completed' => true]);
    }

    public function down()
    {
        Schema::table('companies', function (Blueprint $table) {
            $table->dropColumn('setup_completed');
        });
    }
}
