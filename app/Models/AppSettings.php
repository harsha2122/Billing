<?php

namespace App\Models;

use App\Casts\Hash;
use App\Classes\Common;
use App\Models\BaseModel;

class AppSettings extends BaseModel
{
    protected $table = 'app_settings';

    protected $default = ['xid'];

    protected $guarded = ['id', 'created_at', 'updated_at'];

    protected $hidden = ['id', 'updated_at'];

    protected $appends = [
        'xid',
        'light_logo_url',
        'dark_logo_url',
        'small_light_logo_url',
        'small_dark_logo_url',
        'loader_logo_url',
        'favicon_url'
    ];

    protected $casts = [
        'xid' => Hash::class,
    ];

    public function getLightLogoUrlAttribute()
    {
        $appSettingsPath = Common::getFolderPath('appSettingsPath');

        return $this->light_logo == null ? asset('images/light.png') : Common::getFileUrl($appSettingsPath, $this->light_logo);
    }

    public function getDarkLogoUrlAttribute()
    {
        $appSettingsPath = Common::getFolderPath('appSettingsPath');

        return $this->dark_logo == null ? asset('images/dark.png') : Common::getFileUrl($appSettingsPath, $this->dark_logo);
    }

    public function getSmallDarkLogoUrlAttribute()
    {
        $appSettingsPath = Common::getFolderPath('appSettingsPath');

        return $this->small_dark_logo == null ? asset('images/small_dark.png') : Common::getFileUrl($appSettingsPath, $this->small_dark_logo);
    }

    public function getSmallLightLogoUrlAttribute()
    {
        $appSettingsPath = Common::getFolderPath('appSettingsPath');

        return $this->small_light_logo == null ? asset('images/small_light.png') : Common::getFileUrl($appSettingsPath, $this->small_light_logo);
    }

    public function getLoaderLogoUrlAttribute()
    {
        $appSettingsPath = Common::getFolderPath('appSettingsPath');

        return $this->loader_logo == null ? asset('images/loader.gif') : Common::getFileUrl($appSettingsPath, $this->loader_logo);
    }

    public function getFaviconUrlAttribute()
    {
        $appSettingsPath = Common::getFolderPath('appSettingsPath');

        return $this->favicon == null ? asset('images/favicon.png') : Common::getFileUrl($appSettingsPath, $this->favicon);
    }
}
