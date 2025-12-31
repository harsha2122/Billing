<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class UpdateTablesForMultiUserSystem extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        // Update users table to include role enum
        if (!Schema::hasColumn('users', 'role')) {
            Schema::table('users', function (Blueprint $table) {
                $table->enum('role', ['superadmin', 'admin'])->default('admin')->after('id');
            });
        }

        // Set the first user as superadmin
        $firstUser = DB::table('users')->orderBy('id', 'asc')->first();
        if ($firstUser) {
            DB::table('users')->where('id', $firstUser->id)->update(['role' => 'superadmin']);
        }

        $tables = [
            'brands',
            'categories',
            'taxes',
            'units',
            'products',
            'orders',
            'expenses',
            'expense_categories',
            'warehouses',
            'warehouse_stocks',
            'stock_history',
            'stock_adjustments',
            'payments',
            'order_payments'
        ];

        foreach ($tables as $tableName) {
            if (Schema::hasTable($tableName)) {
                Schema::table($tableName, function (Blueprint $table) use ($tableName) {
                    if (!Schema::hasColumn($tableName, 'admin_id')) {
                        $table->bigInteger('admin_id')->unsigned()->nullable()->after('id');
                        $table->foreign('admin_id')->references('id')->on('users')->onDelete('cascade');
                    }
                });

                // Assign existing data to the first superadmin
                if ($firstUser) {
                    DB::table($tableName)->whereNull('admin_id')->update(['admin_id' => $firstUser->id]);
                }
            }
        }
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        $tables = [
            'brands',
            'categories',
            'taxes',
            'units',
            'products',
            'orders',
            'expenses',
            'expense_categories',
            'warehouses',
            'warehouse_stocks',
            'stock_history',
            'stock_adjustments',
            'payments',
            'order_payments'
        ];

        foreach ($tables as $tableName) {
            if (Schema::hasTable($tableName)) {
                Schema::table($tableName, function (Blueprint $table) use ($tableName) {
                    if (Schema::hasColumn($tableName, 'admin_id')) {
                        $table->dropForeign(['admin_id']);
                        $table->dropColumn('admin_id');
                    }
                });
            }
        }

        if (Schema::hasColumn('users', 'role')) {
            Schema::table('users', function (Blueprint $table) {
                $table->dropColumn('role');
            });
        }
    }
}
