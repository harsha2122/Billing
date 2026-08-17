<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePasswordResetOtpsTable extends Migration
{
    public function up()
    {
        Schema::create('password_reset_otps', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->string('otp', 6);
            $table->dateTime('expires_at');
            $table->boolean('used')->default(false);
            $table->timestamps();

            $table->index('user_id');
        });
    }

    public function down()
    {
        Schema::dropIfExists('password_reset_otps');
    }
}
