<?php

namespace App\Http\Controllers\Api\SuperAdmin;

use App\Http\Controllers\ApiBaseController;
use App\Models\Company;
use App\Models\User;
use App\Scopes\CompanyScope;
use Examyou\RestAPI\ApiResponse;
use Illuminate\Support\Facades\DB;

class DashboardController extends ApiBaseController
{
    public function stats()
    {
        $stats = [
            'total_companies' => Company::withoutGlobalScope(CompanyScope::class)
                ->where('is_global', 0)
                ->count(),
            'active_companies' => Company::withoutGlobalScope(CompanyScope::class)
                ->where('is_global', 0)
                ->where('status', 'active')
                ->count(),
            'total_users' => User::withoutGlobalScope(CompanyScope::class)
                ->where('is_superadmin', 0)
                ->count(),
            'total_products' => DB::table('products')->count(),
            'total_orders' => DB::table('orders')->count(),
            'total_sales' => DB::table('orders')
                ->where('order_type', 'sales')
                ->sum('total'),
        ];

        // Recent companies
        $recentCompanies = Company::withoutGlobalScope(CompanyScope::class)
            ->with(['admin', 'warehouse'])
            ->where('is_global', 0)
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();

        return ApiResponse::make('Success', [
            'stats' => $stats,
            'recent_companies' => $recentCompanies,
        ]);
    }
}
