<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAppSettingsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('app_settings', function (Blueprint $table) {
            $table->id();
            $table->string('site_name')->nullable();
            $table->string('light_logo')->nullable();
            $table->string('dark_logo')->nullable();
            $table->string('small_light_logo')->nullable();
            $table->string('small_dark_logo')->nullable();
            $table->string('loader_logo')->nullable();
            $table->string('favicon')->nullable();
            $table->string('primary_color', 50)->nullable();
            $table->text('meta_description')->nullable();
            $table->text('meta_keywords')->nullable();
            $table->timestamps();
        });

        // Insert default settings
        DB::table('app_settings')->insert([
            'site_name' => 'Billing System',
            'primary_color' => '#1890ff',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('app_settings');
    }
}
