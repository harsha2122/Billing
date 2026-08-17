<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddSmtpFieldsToAppSettingsTable extends Migration
{
    public function up()
    {
        Schema::table('app_settings', function (Blueprint $table) {
            $table->string('smtp_host')->nullable()->after('meta_keywords');
            $table->string('smtp_port')->nullable()->after('smtp_host');
            $table->string('smtp_username')->nullable()->after('smtp_port');
            $table->text('smtp_password')->nullable()->after('smtp_username');
            $table->string('smtp_encryption')->nullable()->after('smtp_password');
            $table->string('smtp_from_name')->nullable()->after('smtp_encryption');
            $table->string('smtp_from_email')->nullable()->after('smtp_from_name');
            $table->boolean('smtp_enabled')->default(false)->after('smtp_from_email');
        });
    }

    public function down()
    {
        Schema::table('app_settings', function (Blueprint $table) {
            $table->dropColumn([
                'smtp_host',
                'smtp_port',
                'smtp_username',
                'smtp_password',
                'smtp_encryption',
                'smtp_from_name',
                'smtp_from_email',
                'smtp_enabled',
            ]);
        });
    }
}
