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

    // Subscription Plans - custom routes must come before resource routes
    ApiRoute::get('subscription-plans-all', ['as' => 'api.superadmin.subscription-plans-all', 'uses' => 'SubscriptionPlansController@allPlans']);

    // Subscription Plans management
    ApiRoute::resource('subscription-plans', 'SubscriptionPlansController', [
        'as' => 'api.superadmin'
    ]);

    // Company session management
    ApiRoute::delete('companies/{id}/sessions', ['as' => 'api.superadmin.companies.clear-sessions', 'uses' => 'CompaniesController@clearSessions']);
    ApiRoute::post('companies/{id}/change-admin-password', ['as' => 'api.superadmin.companies.change-admin-password', 'uses' => 'CompaniesController@changeAdminPassword']);

    // Dashboard stats
    ApiRoute::get('dashboard/stats', ['as' => 'api.superadmin.dashboard.stats', 'uses' => 'DashboardController@stats']);

    // OTP Mail Settings (SuperAdmin only)
    ApiRoute::get('otp-settings', ['as' => 'api.superadmin.otp-settings.get', 'uses' => 'OtpSettingsController@get']);
    ApiRoute::post('otp-settings', ['as' => 'api.superadmin.otp-settings.update', 'uses' => 'OtpSettingsController@update']);
    ApiRoute::post('otp-settings/toggle', ['as' => 'api.superadmin.otp-settings.toggle', 'uses' => 'OtpSettingsController@toggle']);
});
