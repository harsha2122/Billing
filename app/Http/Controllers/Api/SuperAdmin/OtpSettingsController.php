<?php

namespace App\Http\Controllers\Api\SuperAdmin;

use App\Http\Controllers\ApiBaseController;
use App\Models\Settings;
use App\Scopes\CompanyScope;
use Examyou\RestAPI\ApiResponse;
use Illuminate\Http\Request;

class OtpSettingsController extends ApiBaseController
{
    public function get()
    {
        $setting = Settings::withoutGlobalScope(CompanyScope::class)
            ->where('setting_type', 'otp_mail')
            ->where('is_global', 1)
            ->first();

        $credentials = $setting ? $setting->credentials : [
            'from_name' => '',
            'from_email' => '',
            'host' => '',
            'port' => '',
            'encryption' => '',
            'username' => '',
            'password' => '',
        ];

        return ApiResponse::make('Success', [
            'otp_settings' => $credentials,
            'otp_enabled' => $setting && $setting->status ? true : false,
            'verified' => $setting ? $setting->verified : 0,
        ]);
    }

    public function update(Request $request)
    {
        $request->validate([
            'from_name' => 'required',
            'from_email' => 'required|email',
            'host' => 'required',
            'port' => 'required',
            'encryption' => 'required',
            'username' => 'required',
            'password' => 'required',
        ]);

        $setting = Settings::withoutGlobalScope(CompanyScope::class)
            ->where('setting_type', 'otp_mail')
            ->where('is_global', 1)
            ->first();

        if (!$setting) {
            $globalCompany = \App\Models\Company::where('is_global', 1)->first();
            $setting = new Settings();
            $setting->company_id = $globalCompany ? $globalCompany->id : null;
            $setting->setting_type = 'otp_mail';
            $setting->name = 'OTP Mail Settings';
            $setting->name_key = 'otp_smtp';
            $setting->is_global = 1;
        }

        $setting->credentials = [
            'from_name' => $request->from_name,
            'from_email' => $request->from_email,
            'host' => $request->host,
            'port' => $request->port,
            'encryption' => $request->encryption,
            'username' => $request->username,
            'password' => $request->password,
        ];
        $setting->status = $request->has('enabled') ? $request->enabled : 1;

        // Verify SMTP connection
        try {
            $transport = new \Swift_SmtpTransport($request->host, $request->port, $request->encryption);
            $transport->setUsername($request->username);
            $transport->setPassword($request->password);
            $mailer = new \Swift_Mailer($transport);
            $mailer->getTransport()->start();
            $setting->verified = 1;
        } catch (\Exception $e) {
            $setting->verified = 0;
            $setting->save();

            return ApiResponse::make('SMTP connection failed: ' . $e->getMessage(), [
                'verified' => 0,
            ], 422);
        }

        $setting->save();

        return ApiResponse::make('OTP mail settings saved successfully', [
            'otp_settings' => $setting->credentials,
            'otp_enabled' => $setting->status ? true : false,
            'verified' => $setting->verified,
        ]);
    }

    public function toggle(Request $request)
    {
        $setting = Settings::withoutGlobalScope(CompanyScope::class)
            ->where('setting_type', 'otp_mail')
            ->where('is_global', 1)
            ->first();

        if (!$setting) {
            return ApiResponse::make('OTP settings not configured yet', [], 422);
        }

        $setting->status = $request->enabled ? 1 : 0;
        $setting->save();

        return ApiResponse::make('OTP ' . ($setting->status ? 'enabled' : 'disabled') . ' successfully', [
            'otp_enabled' => $setting->status ? true : false,
        ]);
    }
}
