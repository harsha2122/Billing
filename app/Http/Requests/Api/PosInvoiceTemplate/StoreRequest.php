<?php

namespace App\Http\Requests\Api\PosInvoiceTemplate;

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
            'name' => 'required',
            'slug' => 'required',
            'template_type' => 'required|in:a4,thermal,landscape',
        ];
    }
}
