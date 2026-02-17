<?php

use Examyou\RestAPI\Facades\ApiRoute;

ApiRoute::group(['namespace' => 'App\Http\Controllers\Api'], function () {
    ApiRoute::get('global-setting', ['as' => 'api.extra.global-setting', 'uses' => 'AuthController@companySetting']);
    ApiRoute::get('app', ['as' => 'api.extra.app', 'uses' => 'AuthController@app']);

    // Public app settings endpoint (for login page)
    ApiRoute::get('app-settings/public', ['as' => 'api.app-settings.public', 'uses' => 'AppSettingsController@getPublicSettings']);

    // Authentication routes
    ApiRoute::group(['prefix' => 'auth'], function () {
        ApiRoute::post('login', ['as' => 'api.extra.login', 'uses' => 'AuthController@login']);
        ApiRoute::post('verify-otp', ['as' => 'api.extra.verify-otp', 'uses' => 'AuthController@verifyOtp']);
        ApiRoute::post('refresh-token', ['as' => 'api.extra.refresh-token', 'uses' => 'AuthController@refreshToken']);
        ApiRoute::post('logout', ['as' => 'api.extra.logout', 'uses' => 'AuthController@logout']);
    });
});
