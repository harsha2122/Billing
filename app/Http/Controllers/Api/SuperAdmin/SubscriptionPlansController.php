<?php

namespace App\Http\Controllers\Api\SuperAdmin;

use App\Http\Controllers\ApiBaseController;
use App\Models\SubscriptionPlan;
use Examyou\RestAPI\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SubscriptionPlansController extends ApiBaseController
{
    protected $model = SubscriptionPlan::class;

    public function index()
    {
        $request = request();
        $plans = SubscriptionPlan::query()
            ->when($request->has('search') && $request->search != '', function ($query) use ($request) {
                return $query->where('name', 'like', '%' . $request->search . '%')
                    ->orWhere('description', 'like', '%' . $request->search . '%');
            })
            ->orderBy('created_at', 'desc')
            ->paginate(request('per_page', 10));

        return ApiResponse::make('Success', [
            'data' => $plans->items(),
            'total' => $plans->total(),
            'per_page' => $plans->perPage(),
            'current_page' => $plans->currentPage(),
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'max_products' => 'required|integer|min:0',
            'modules' => 'nullable|array',
            'modules.*' => 'string',
        ]);

        DB::beginTransaction();
        try {
            $plan = new SubscriptionPlan();
            $plan->name = $request->name;
            $plan->description = $request->description;
            $plan->max_products = $request->max_products;
            $plan->modules = $request->modules ?? [];
            $plan->annual_price = $request->annual_price ?? 0;
            $plan->monthly_price = $request->monthly_price ?? 0;
            $plan->max_users = $request->max_users ?? 0;
            $plan->max_warehouses = $request->max_warehouses ?? 1;
            $plan->save();

            DB::commit();

            return ApiResponse::make('Subscription plan created successfully', [
                'plan' => $plan
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return ApiResponse::make('Failed to create subscription plan: ' . $e->getMessage(), [], 500);
        }
    }

    public function show($id)
    {
        $plan = SubscriptionPlan::findOrFail($id);

        // Get count of companies using this plan
        $companiesCount = \App\Models\Company::withoutGlobalScope(\App\Scopes\CompanyScope::class)
            ->where('subscription_plan_id', $id)
            ->count();

        return ApiResponse::make('Success', [
            'plan' => $plan,
            'companies_count' => $companiesCount
        ]);
    }

    public function update(Request $request, $id)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'max_products' => 'required|integer|min:0',
            'modules' => 'nullable|array',
            'modules.*' => 'string',
        ]);

        $plan = SubscriptionPlan::findOrFail($id);

        $plan->name = $request->name;
        $plan->description = $request->description;
        $plan->max_products = $request->max_products;
        $plan->modules = $request->modules ?? [];
        $plan->annual_price = $request->annual_price ?? 0;
        $plan->monthly_price = $request->monthly_price ?? 0;
        $plan->max_users = $request->max_users ?? 0;
        $plan->max_warehouses = $request->max_warehouses ?? 1;
        $plan->save();

        return ApiResponse::make('Subscription plan updated successfully', [
            'plan' => $plan
        ]);
    }

    public function destroy($id)
    {
        $plan = SubscriptionPlan::findOrFail($id);

        // Check if any companies are using this plan
        $companiesCount = \App\Models\Company::withoutGlobalScope(\App\Scopes\CompanyScope::class)
            ->where('subscription_plan_id', $id)
            ->count();

        if ($companiesCount > 0) {
            return ApiResponse::make('Cannot delete subscription plan that is assigned to companies', [], 403);
        }

        $plan->delete();

        return ApiResponse::make('Subscription plan deleted successfully', []);
    }

    public function allPlans()
    {
        $plans = SubscriptionPlan::orderBy('name', 'asc')->get();

        return ApiResponse::make('Success', [
            'plans' => $plans
        ]);
    }
}
