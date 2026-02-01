<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\ApiBaseController;
use App\Models\Warehouse;
use Examyou\RestAPI\ApiResponse;

class SetupController extends ApiBaseController
{
    public function index()
    {
        $company = company();
        $warehouse = $company->warehouse;

        return ApiResponse::make('Setup data', [
            'company' => $company,
            'warehouse' => $warehouse,
            'setup_completed' => $company->setup_completed,
        ]);
    }

    public function complete()
    {
        $request = request();
        $company = company();
        $warehouse = Warehouse::where('company_id', $company->id)->first();

        // Update warehouse details
        if ($warehouse) {
            $warehouse->name = $request->warehouse_name ?? $warehouse->name;
            $warehouse->email = $request->warehouse_email ?? $warehouse->email;
            $warehouse->phone = $request->warehouse_phone ?? $warehouse->phone;
            $warehouse->address = $request->warehouse_address ?? $warehouse->address;
            $warehouse->save();
        }

        // Mark setup as complete
        $company->setup_completed = true;
        $company->save();

        return ApiResponse::make('Setup completed successfully', [
            'company' => $company,
            'warehouse' => $warehouse,
        ]);
    }
}
