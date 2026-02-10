<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\ApiBaseController;
use App\Http\Requests\Api\PosInvoiceTemplate\IndexRequest;
use App\Http\Requests\Api\PosInvoiceTemplate\StoreRequest;
use App\Http\Requests\Api\PosInvoiceTemplate\UpdateRequest;
use App\Http\Requests\Api\PosInvoiceTemplate\DeleteRequest;
use App\Models\PosInvoiceTemplate;

class PosInvoiceTemplateController extends ApiBaseController
{
    protected $model = PosInvoiceTemplate::class;

    protected $indexRequest = IndexRequest::class;
    protected $storeRequest = StoreRequest::class;
    protected $updateRequest = UpdateRequest::class;
    protected $deleteRequest = DeleteRequest::class;
}
