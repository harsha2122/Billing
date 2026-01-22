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

    // Subscription Plans management
    ApiRoute::resource('subscription-plans', 'SubscriptionPlansController', [
        'as' => 'api.superadmin'
    ]);
    ApiRoute::get('subscription-plans-all', ['as' => 'api.superadmin.subscription-plans-all', 'uses' => 'SubscriptionPlansController@allPlans']);

    // Dashboard stats
    ApiRoute::get('dashboard/stats', ['as' => 'api.superadmin.dashboard.stats', 'uses' => 'DashboardController@stats']);
});
