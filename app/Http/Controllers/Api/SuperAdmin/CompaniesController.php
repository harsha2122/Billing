<?php

namespace App\Http\Controllers\Api\SuperAdmin;

use App\Classes\Common;
use App\Http\Controllers\ApiBaseController;
use App\Http\Requests\Api\SuperAdmin\Company\IndexRequest;
use App\Http\Requests\Api\SuperAdmin\Company\StoreRequest;
use App\Http\Requests\Api\SuperAdmin\Company\UpdateRequest;
use App\Http\Requests\Api\SuperAdmin\Company\DeleteRequest;
use App\Models\Company;
use App\Models\Currency;
use App\Models\Lang;
use App\Models\Permission;
use App\Models\Role;
use App\Models\SubscriptionPlan;
use App\Models\User;
use App\Models\UserSession;
use App\Models\Warehouse;
use App\Scopes\CompanyScope;
use Carbon\Carbon;
use Database\Seeders\PosInvoiceTemplateSeeder;
use Examyou\RestAPI\ApiResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Vinkla\Hashids\Facades\Hashids;

class CompaniesController extends ApiBaseController
{
    protected $model = Company::class;

    protected $indexRequest = IndexRequest::class;
    protected $storeRequest = StoreRequest::class;
    protected $updateRequest = UpdateRequest::class;
    protected $deleteRequest = DeleteRequest::class;

    public function index()
    {
        $request = request();
        $companies = Company::withoutGlobalScope(CompanyScope::class)
            ->with(['admin', 'subscriptionPlan', 'warehouse', 'currency'])
            ->when($request->has('search') && $request->search != '', function ($query) use ($request) {
                return $query->where('name', 'like', '%' . $request->search . '%')
                    ->orWhere('email', 'like', '%' . $request->search . '%');
            })
            ->orderBy('created_at', 'desc')
            ->paginate(request('per_page', 10));

        return ApiResponse::make('Success', [
            'data' => $companies->items(),
            'total' => $companies->total(),
            'per_page' => $companies->perPage(),
            'current_page' => $companies->currentPage(),
        ]);
    }

    public function store(...$args)
    {
        $request = $args[0] ?? request();

        DB::beginTransaction();
        try {
            // Get the first company (global or superadmin's company) to copy default settings from
            $sourceCompany = Company::withoutGlobalScope(CompanyScope::class)
                ->where('is_global', 1)
                ->first();

            // If no global company, get the first company
            if (!$sourceCompany) {
                $sourceCompany = Company::withoutGlobalScope(CompanyScope::class)->first();
            }

            // Create Company
            $company = new Company();
            $company->name = $request->name;
            $company->short_name = $request->short_name ?? $request->name;
            $company->business_type = $request->business_type;
            $company->max_devices = $request->max_devices ?? 1;
            $company->email = trim($request->email);
            $company->phone = $request->phone;
            $company->address = $request->address;
            $company->is_global = 0;
            $company->status = 'active';
            $company->verified = true;
            $company->setup_completed = false;

            // Copy logos from source company if available
            if ($sourceCompany) {
                $company->light_logo = $sourceCompany->light_logo;
                $company->dark_logo = $sourceCompany->dark_logo;
                $company->small_light_logo = $sourceCompany->small_light_logo;
                $company->small_dark_logo = $sourceCompany->small_dark_logo;
                $company->login_image = $sourceCompany->login_image;
            }

            $company->save();

            // Create Warehouse
            $warehouse = new Warehouse();
            $warehouse->company_id = $company->id;
            $warehouse->name = $request->name . ' Warehouse';
            $warehouse->slug = strtolower(str_replace(' ', '-', $request->name)) . '-' . time();
            $warehouse->email = trim($request->email);
            $warehouse->phone = $request->phone ?? '1234567890';
            $warehouse->address = $request->address ?? 'Address';
            $warehouse->save();

            // Add Currencies
            Common::addCurrencies($company);

            // Update company warehouse and subscription plan
            $company->warehouse_id = $warehouse->id;

            // Assign subscription plan if provided
            if ($request->has('subscription_plan_id') && $request->subscription_plan_id) {
                $subscriptionPlanId = Hashids::decode($request->subscription_plan_id);
                $company->subscription_plan_id = $subscriptionPlanId[0] ?? null;
            }

            $company->save();

            // Create Admin Role
            $adminRole = new Role();
            $adminRole->company_id = $company->id;
            $adminRole->name = 'admin';
            $adminRole->display_name = 'Admin';
            $adminRole->description = 'Admin role for ' . $request->name;
            $adminRole->save();

            // Attach all permissions to admin role
            $allPermissionIds = Permission::pluck('id');
            $adminRole->savePermissions($allPermissionIds);

            // Create Admin User
            $admin = new User();
            $admin->company_id = $company->id;
            $admin->warehouse_id = $warehouse->id;
            $admin->role_id = $adminRole->id;
            $admin->name = $request->admin_name;
            $admin->email = strtolower(trim($request->admin_email));
            $admin->password = $request->admin_password;
            $admin->user_type = 'staff_members';
            $admin->is_superadmin = false;
            $admin->status = 'enabled';
            $admin->login_enabled = true;
            $admin->save();

            // Update company admin_id
            $company->admin_id = $admin->id;
            $company->save();

            // Insert init settings
            Common::insertInitSettings($company);

            // Create walk-in customer
            Common::createCompanyWalkInCustomer($company);

            // Insert default payment modes (Cash, Bank Transfer, UPI)
            Common::insertDefaultPaymentModes($company);

            // Seed default invoice templates for the new company
            PosInvoiceTemplateSeeder::seedForCompany($company->id);

            DB::commit();

            return ApiResponse::make('Company created successfully', [
                'company' => $company->load(['admin', 'warehouse', 'currency'])
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return ApiResponse::make('Failed to create company: ' . $e->getMessage(), [], 500);
        }
    }

    public function update(...$args)
    {
        $request = $args[0] ?? request();
        $xid = $args[1] ?? null;

        // Decode hashed ID
        $id = Hashids::decode($xid);
        $id = $id[0] ?? null;

        $company = Company::withoutGlobalScope(CompanyScope::class)->findOrFail($id);

        $company->name = $request->name;
        $company->short_name = $request->short_name ?? $request->name;
        $company->business_type = $request->business_type;
        $company->max_devices = $request->max_devices ?? $company->max_devices;
        $company->email = $request->email;
        $company->phone = $request->phone;
        $company->address = $request->address;
        $company->status = $request->status;
        $company->save();

        return ApiResponse::make('Company updated successfully', [
            'company' => $company->load(['admin', 'warehouse', 'currency'])
        ]);
    }

    public function destroy(...$args)
    {
        $xid = $args[0] ?? null;

        // Decode hashed ID
        $id = Hashids::decode($xid);
        $id = $id[0] ?? null;

        if (!$id) {
            return ApiResponse::make('Invalid company ID', [], 400);
        }

        $company = Company::withoutGlobalScope(CompanyScope::class)->findOrFail($id);

        if ($company->is_global) {
            return ApiResponse::make('Cannot delete global company', [], 403);
        }

        $company->delete();

        return ApiResponse::make('Company deleted successfully', []);
    }

    public function show(...$args)
    {
        $xid = $args[0] ?? null;

        // Decode hashed ID
        $id = Hashids::decode($xid);
        $id = $id[0] ?? null;

        $company = Company::withoutGlobalScope(CompanyScope::class)
            ->with(['admin', 'warehouse', 'currency', 'subscriptionPlan'])
            ->findOrFail($id);

        // Get company stats
        $stats = [
            'total_users' => User::withoutGlobalScope(CompanyScope::class)
                ->where('company_id', $company->id)
                ->count(),
            'total_products' => DB::table('products')
                ->where('company_id', $company->id)
                ->count(),
            'total_orders' => DB::table('orders')
                ->where('company_id', $company->id)
                ->count(),
        ];

        return ApiResponse::make('Success', [
            'company' => $company,
            'stats' => $stats
        ]);
    }

    public function clearSessions(...$args)
    {
        $xid = $args[0] ?? null;
        $id = Hashids::decode($xid);
        $id = $id[0] ?? null;

        if (!$id) {
            return ApiResponse::make('Invalid company ID', [], 400);
        }

        Company::withoutGlobalScope(CompanyScope::class)->findOrFail($id);

        $count = UserSession::where('company_id', $id)->delete();

        return ApiResponse::make("Logged out {$count} active session(s) successfully", [
            'count' => $count
        ]);
    }

    public function changeAdminPassword(...$args)
    {
        $request = $args[0] ?? request();
        $xid = $args[1] ?? null;

        $id = Hashids::decode($xid);
        $id = $id[0] ?? null;

        if (!$id) {
            return ApiResponse::make('Invalid company ID', [], 400);
        }

        $company = Company::withoutGlobalScope(CompanyScope::class)->findOrFail($id);

        $request->validate([
            'password' => 'required|min:8',
        ]);

        $admin = User::withoutGlobalScope(CompanyScope::class)
            ->where('id', $company->admin_id)
            ->first();

        if (!$admin) {
            return ApiResponse::make('Admin user not found', [], 404);
        }

        $admin->password = $request->password;
        $admin->save();

        return ApiResponse::make('Admin password updated successfully', []);
    }

    /**
     * Renew an expired (or active) subscription for a company/vendor.
     * Extends licence_expire_on by the plan's duration from today (if expired)
     * or from the current expiry date (if still active).
     */
    public function renewSubscription(...$args)
    {
        $xid = $args[0] ?? null;

        $id = Hashids::decode($xid);
        $id = $id[0] ?? null;

        if (!$id) {
            return ApiResponse::make('Invalid company ID', [], 400);
        }

        $company = Company::withoutGlobalScope(CompanyScope::class)->findOrFail($id);

        if (!$company->subscription_plan_id) {
            return ApiResponse::make('No subscription plan assigned to this company. Please assign a plan first.', [], 422);
        }

        $plan = SubscriptionPlan::find($company->subscription_plan_id);

        if (!$plan) {
            return ApiResponse::make('Assigned subscription plan not found.', [], 404);
        }

        $duration = $plan->duration ?? 30;
        $now = Carbon::now();

        // If plan is already expired or no expiry set, renew from today.
        // If plan is still active, extend from the current expiry date.
        if ($company->licence_expire_on && $company->licence_expire_on->greaterThan($now)) {
            $newExpiry = $company->licence_expire_on->copy()->addDays($duration);
        } else {
            $newExpiry = $now->copy()->addDays($duration);
        }

        $company->licence_expire_on = $newExpiry->format('Y-m-d');
        $company->status = 'active';
        $company->save();

        return ApiResponse::make('Subscription renewed successfully', [
            'company_id'        => $company->xid,
            'plan'              => $plan->name,
            'duration_days'     => $duration,
            'licence_expire_on' => $newExpiry->format('d M Y'),
        ]);
    }

    /**
     * Upgrade (or downgrade) a company's subscription plan mid-cycle.
     * Remaining days on the current plan are carried over to the new plan.
     */
    public function upgradeSubscription(...$args)
    {
        $request = $args[0] ?? request();
        $xid     = $args[1] ?? null;

        $id = Hashids::decode($xid);
        $id = $id[0] ?? null;

        if (!$id) {
            return ApiResponse::make('Invalid company ID', [], 400);
        }

        $request->validate([
            'subscription_plan_id' => 'required|string',
        ]);

        // Decode new plan's hashed ID
        $newPlanId = Hashids::decode($request->subscription_plan_id);
        $newPlanId = $newPlanId[0] ?? null;

        if (!$newPlanId) {
            return ApiResponse::make('Invalid subscription plan ID', [], 400);
        }

        $newPlan = SubscriptionPlan::find($newPlanId);

        if (!$newPlan) {
            return ApiResponse::make('Subscription plan not found', [], 404);
        }

        $company = Company::withoutGlobalScope(CompanyScope::class)->findOrFail($id);

        $now = Carbon::now();
        $newDuration = $newPlan->duration ?? 30;

        // Calculate remaining days on current plan and carry them over
        $remainingDays = 0;
        if ($company->licence_expire_on && $company->licence_expire_on->greaterThan($now)) {
            $remainingDays = (int) $now->diffInDays($company->licence_expire_on, false);
        }

        $newExpiry = $now->copy()->addDays($newDuration + $remainingDays);

        $company->subscription_plan_id = $newPlanId;
        $company->licence_expire_on    = $newExpiry->format('Y-m-d');
        $company->status               = 'active';
        $company->save();

        return ApiResponse::make('Subscription upgraded successfully', [
            'company_id'        => $company->xid,
            'new_plan'          => $newPlan->name,
            'carried_over_days' => $remainingDays,
            'new_duration_days' => $newDuration,
            'licence_expire_on' => $newExpiry->format('d M Y'),
        ]);
    }
}
