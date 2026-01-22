<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\ApiBaseController;
use App\Models\AppSettings;
use Examyou\RestAPI\ApiResponse;
use Examyou\RestAPI\Exceptions\ApiException;

class AppSettingsController extends ApiBaseController
{
    protected $model = AppSettings::class;

    public function index()
    {
        $user = user();

        // Only superadmin can access global settings
        if (!$user || !$user->is_superadmin) {
            throw new ApiException('Unauthorized. Only SuperAdmin can access global settings.');
        }

        $appSettings = AppSettings::first();

        if (!$appSettings) {
            // Create default settings if not exists
            $appSettings = new AppSettings();
            $appSettings->site_name = 'Billing System';
            $appSettings->primary_color = '#1890ff';
            $appSettings->save();
        }

        return ApiResponse::make('Success', [
            'app_settings' => $appSettings,
        ]);
    }

    public function update()
    {
        $request = request();
        $user = user();

        // Only superadmin can update global settings
        if (!$user || !$user->is_superadmin) {
            throw new ApiException('Unauthorized. Only SuperAdmin can access global settings.');
        }

        $appSettings = AppSettings::first();

        if (!$appSettings) {
            $appSettings = new AppSettings();
        }

        if ($request->has('site_name')) {
            $appSettings->site_name = $request->site_name;
        }

        if ($request->has('primary_color')) {
            $appSettings->primary_color = $request->primary_color;
        }

        if ($request->has('light_logo')) {
            $appSettings->light_logo = $request->light_logo;
        }

        if ($request->has('dark_logo')) {
            $appSettings->dark_logo = $request->dark_logo;
        }

        if ($request->has('small_light_logo')) {
            $appSettings->small_light_logo = $request->small_light_logo;
        }

        if ($request->has('small_dark_logo')) {
            $appSettings->small_dark_logo = $request->small_dark_logo;
        }

        if ($request->has('loader_logo')) {
            $appSettings->loader_logo = $request->loader_logo;
        }

        if ($request->has('favicon')) {
            $appSettings->favicon = $request->favicon;
        }

        if ($request->has('meta_description')) {
            $appSettings->meta_description = $request->meta_description;
        }

        if ($request->has('meta_keywords')) {
            $appSettings->meta_keywords = $request->meta_keywords;
        }

        $appSettings->save();

        return ApiResponse::make('Global settings updated successfully', [
            'app_settings' => $appSettings,
        ]);
    }

    public function getPublicSettings()
    {
        // This endpoint is public for login page
        $appSettings = AppSettings::first();

        if (!$appSettings) {
            $appSettings = new AppSettings();
            $appSettings->site_name = 'Billing System';
            $appSettings->primary_color = '#1890ff';
        }

        return ApiResponse::make('Success', [
            'app_settings' => $appSettings,
        ]);
    }
}
