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

        if ($request->has('smtp_enabled')) {
            $appSettings->smtp_enabled = $request->smtp_enabled ? true : false;
        }

        if ($request->has('smtp_host')) {
            $appSettings->smtp_host = $request->smtp_host;
        }

        if ($request->has('smtp_port')) {
            $appSettings->smtp_port = $request->smtp_port;
        }

        if ($request->has('smtp_username')) {
            $appSettings->smtp_username = $request->smtp_username;
        }

        // Only overwrite the stored password when a new one is actually sent
        // so the masked placeholder in the UI never wipes the saved credential.
        if ($request->has('smtp_password') && $request->smtp_password != '') {
            $appSettings->smtp_password = $request->smtp_password;
        }

        if ($request->has('smtp_encryption')) {
            $appSettings->smtp_encryption = $request->smtp_encryption;
        }

        if ($request->has('smtp_from_name')) {
            $appSettings->smtp_from_name = $request->smtp_from_name;
        }

        if ($request->has('smtp_from_email')) {
            $appSettings->smtp_from_email = $request->smtp_from_email;
        }

        $appSettings->save();

        return ApiResponse::make('Global settings updated successfully', [
            'app_settings' => $appSettings,
        ]);
    }

    public function sendTestMail()
    {
        $request = request();
        $user = user();

        if (!$user || !$user->is_superadmin) {
            throw new ApiException('Unauthorized. Only SuperAdmin can access global settings.');
        }

        $request->validate([
            'email' => 'required|email',
        ]);

        $sent = \App\Classes\Common::sendGlobalSmtpMail(
            $request->email,
            'Test Mail',
            '<p>Your SMTP settings are correct. This is a test email sent from your application.</p>'
        );

        if (!$sent) {
            throw new ApiException('Failed to send test mail. Please check your SMTP settings and make sure "Enable SMTP" is turned on.');
        }

        return ApiResponse::make('Test mail sent successfully');
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
