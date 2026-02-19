<?php

namespace App\Http\Requests\Api\SuperAdmin\Company;

use Illuminate\Foundation\Http\FormRequest;

class StoreRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'name' => 'required|string|max:255',
            'short_name' => 'nullable|string|max:100',
            'business_type' => 'required|in:wholesaler,distributor,retailer,manufacturer',
            'max_devices' => 'nullable|integer|min:1|max:100',
            'email' => 'required|email|unique:companies,email',
            'phone' => 'nullable|string|max:20',
            'address' => 'nullable|string|max:1000',
            'admin_name' => 'required|string|max:255',
            'admin_email' => 'required|email|unique:users,email',
            'admin_password' => 'required|string|min:6',
        ];
    }
}
