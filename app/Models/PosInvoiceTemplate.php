<?php

namespace App\Models;

use App\Casts\Hash;
use App\Models\BaseModel;
use App\Scopes\CompanyScope;

class PosInvoiceTemplate extends BaseModel
{
    protected $table = 'pos_invoice_templates';

    protected $default = ['xid', 'name', 'slug'];

    protected $guarded = ['id', 'created_at', 'updated_at'];

    protected $hidden = ['id', 'company_id'];

    protected $appends = ['xid'];

    protected $filterable = ['id', 'name', 'slug', 'template_type'];

    protected $casts = [
        'show_hsn' => 'integer',
        'show_gst_breakup' => 'integer',
        'show_eway_bill' => 'integer',
        'show_irn' => 'integer',
        'show_qr_code' => 'integer',
        'show_amount_in_words' => 'integer',
        'show_authorized_signatory' => 'integer',
        'show_terms_conditions' => 'integer',
        'is_default' => 'integer',
    ];

    protected static function boot()
    {
        parent::boot();

        static::addGlobalScope(new CompanyScope);
    }
}
