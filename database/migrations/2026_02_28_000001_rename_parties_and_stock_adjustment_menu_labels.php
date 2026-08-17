<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up()
    {
        DB::table('translations')
            ->where('group', 'menu')
            ->where('key', 'stock_adjustment')
            ->where('value', 'Stock Adjustment')
            ->update(['value' => 'Inventory']);

        DB::table('translations')
            ->where('group', 'menu')
            ->where('key', 'parties')
            ->where('value', 'Parties')
            ->update(['value' => 'Customers & Suppliers']);
    }

    public function down()
    {
        DB::table('translations')
            ->where('group', 'menu')
            ->where('key', 'stock_adjustment')
            ->where('value', 'Inventory')
            ->update(['value' => 'Stock Adjustment']);

        DB::table('translations')
            ->where('group', 'menu')
            ->where('key', 'parties')
            ->where('value', 'Customers & Suppliers')
            ->update(['value' => 'Parties']);
    }
};
