<?php

use Examyou\RestAPI\Facades\ApiRoute;

// SuperAdmin routes - only accessible by users with is_superadmin = true
ApiRoute::group([
    'namespace' => 'App\Http\Controllers\Api\SuperAdmin',
    'prefix' => 'superadmin',
    'middleware' => ['api.superadmin.check']
], function () {

    // Companies management
    ApiRoute::resource('companies', 'CompaniesController', [
        'as' => 'api.superadmin'
    ]);

    // Dashboard stats
    ApiRoute::get('dashboard/stats', ['as' => 'api.superadmin.dashboard.stats', 'uses' => 'DashboardController@stats']);
});
