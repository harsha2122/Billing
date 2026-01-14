<?php

namespace App\Http\Requests\Api\SuperAdmin\Company;

use Illuminate\Foundation\Http\FormRequest;

class UpdateRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        $companyId = $this->route('id');

        return [
            'name' => 'required|string|max:255',
            'short_name' => 'nullable|string|max:100',
            'email' => 'required|email|unique:companies,email,' . $companyId,
            'phone' => 'nullable|string|max:20',
            'address' => 'nullable|string|max:1000',
            'status' => 'required|in:active,inactive,license_expired',
        ];
    }
}
