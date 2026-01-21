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
use App\Models\Role;
use App\Models\User;
use App\Models\Warehouse;
use App\Scopes\CompanyScope;
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
            // Create Company
            $company = new Company();
            $company->name = $request->name;
            $company->short_name = $request->short_name ?? $request->name;
            $company->email = trim($request->email);
            $company->phone = $request->phone;
            $company->address = $request->address;
            $company->is_global = 0;
            $company->status = 'active';
            $company->verified = true;
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

            // Update company warehouse
            $company->warehouse_id = $warehouse->id;
            $company->save();

            // Create Admin Role
            $adminRole = new Role();
            $adminRole->company_id = $company->id;
            $adminRole->name = 'admin';
            $adminRole->display_name = 'Admin';
            $adminRole->description = 'Admin role for ' . $request->name;
            $adminRole->save();

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
        $id = $args[1] ?? null;

        $company = Company::withoutGlobalScope(CompanyScope::class)->findOrFail($id);

        $company->name = $request->name;
        $company->short_name = $request->short_name ?? $request->name;
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
        $id = $args[0] ?? null;

        $company = Company::withoutGlobalScope(CompanyScope::class)->findOrFail($id);

        if ($company->is_global) {
            return ApiResponse::make('Cannot delete global company', [], 403);
        }

        $company->delete();

        return ApiResponse::make('Company deleted successfully', []);
    }

    public function show(...$args)
    {
        $id = $args[0] ?? null;

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
}
