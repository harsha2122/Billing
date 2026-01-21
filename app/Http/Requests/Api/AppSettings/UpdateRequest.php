<?php

namespace App\Http\Requests\Api\AppSettings;

use Illuminate\Foundation\Http\FormRequest;

class UpdateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'site_name' => 'nullable|string|max:255',
            'light_logo' => 'nullable|string',
            'dark_logo' => 'nullable|string',
            'small_light_logo' => 'nullable|string',
            'small_dark_logo' => 'nullable|string',
            'loader_logo' => 'nullable|string',
            'favicon' => 'nullable|string',
            'primary_color' => 'nullable|string|max:50',
            'meta_description' => 'nullable|string',
            'meta_keywords' => 'nullable|string',
        ];
    }
}
