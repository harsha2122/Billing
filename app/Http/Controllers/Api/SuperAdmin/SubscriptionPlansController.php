<?php

namespace App\Http\Controllers\Api\SuperAdmin;

use App\Http\Controllers\ApiBaseController;
use App\Models\SubscriptionPlan;
use Examyou\RestAPI\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Vinkla\Hashids\Facades\Hashids;

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

    public function store(...$args)
    {
        $request = $args[0] ?? request();

        try {
            $request->validate([
                'name' => 'required|string|max:255',
                'description' => 'nullable|string',
                'max_products' => 'required|integer|min:0',
                'modules' => 'nullable|array',
                'modules.*' => 'string',
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return ApiResponse::make('Validation failed', ['errors' => $e->errors()], 422);
        }

        DB::beginTransaction();
        try {
            $plan = new SubscriptionPlan();
            $plan->name = $request->name;
            $plan->description = $request->description ?? '';
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
        } catch (\Illuminate\Database\QueryException $e) {
            DB::rollBack();
            // Check for specific SQL errors
            $errorCode = $e->errorInfo[1] ?? 0;
            if ($errorCode == 1062) {
                return ApiResponse::make('A subscription plan with this name already exists', [], 400);
            } elseif ($errorCode == 1054) {
                return ApiResponse::make('Database column error. Please contact administrator.', [], 500);
            }
            return ApiResponse::make('Database error: ' . $e->getMessage(), [], 500);
        } catch (\Exception $e) {
            DB::rollBack();
            return ApiResponse::make('Failed to create subscription plan: ' . $e->getMessage(), [], 500);
        }
    }

    public function show(...$args)
    {
        $xid = $args[0] ?? null;

        // Decode hashed ID
        $id = Hashids::decode($xid);
        $id = $id[0] ?? null;

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

    public function update(...$args)
    {
        $request = $args[0] ?? request();
        $xid = $args[1] ?? null;

        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'max_products' => 'required|integer|min:0',
            'modules' => 'nullable|array',
            'modules.*' => 'string',
        ]);

        // Decode hashed ID
        $id = Hashids::decode($xid);
        $id = $id[0] ?? null;

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

    public function destroy(...$args)
    {
        $xid = $args[0] ?? null;

        // Decode hashed ID
        $id = Hashids::decode($xid);
        $id = $id[0] ?? null;

        if (!$id) {
            return ApiResponse::make('Invalid plan ID', [], 400);
        }

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
