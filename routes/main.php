<?php

use App\Classes\Common;
use App\Models\Company;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Route;

Route::get('{path}', function () {
    if (file_exists(storage_path('installed'))) {

        $appName = "Stockifly";
        $appVersion = File::get(public_path() . '/version.txt');
        $modulesData = Common::moduleInformations();
        $themeMode = session()->has('theme_mode') ? session('theme_mode') : 'light';
        $company = Company::first();
        $appVersion = File::get('version.txt');
        $appVersion = preg_replace("/\r|\n/", "", $appVersion);

        // Handle null company for superadmin routes
        if (!$company) {
            $company = (object) [
                'short_name' => $appName,
                'small_light_logo_url' => asset('images/small_light.png'),
            ];
        }

        return view('welcome', [
            'appName' => $appName,
            'appVersion' => preg_replace("/\r|\n/", "", $appVersion),
            'installedModules' => $modulesData['installed_modules'],
            'enabledModules' => $modulesData['enabled_modules'],
            'themeMode' => $themeMode,
            'company' => $company,
            'appVersion' => $appVersion,
            'appEnv' => env('APP_ENV'),
            'appType' => app_type()
        ]);
    } else {
        return redirect('/install');
    }
})->where('path', '^(?!api.*$).*')->name('main');
