<?php

use App\Models\Lang;
use App\Models\Translation;
use Illuminate\Database\Migrations\Migration;

class AddPlanInfoDashboardTranslations extends Migration
{
    private array $keys = [
        'plan_days_remaining' => 'Plan Validity',
        'days'                => 'Days Remaining',
        'expires_on'          => 'Expires On',
        'plan'                => 'Plan',
        'products_limit'      => 'Products Limit',
        'products_remaining'  => 'Products Remaining',
    ];

    public function up()
    {
        $allLangs = Lang::all();

        foreach ($allLangs as $lang) {
            foreach ($this->keys as $key => $value) {
                $exists = Translation::where('lang_id', $lang->id)
                    ->where('group', 'dashboard')
                    ->where('key', $key)
                    ->exists();

                if (!$exists) {
                    Translation::create([
                        'lang_id' => $lang->id,
                        'group'   => 'dashboard',
                        'key'     => $key,
                        'value'   => $value,
                    ]);
                }
            }
        }
    }

    public function down()
    {
        Translation::where('group', 'dashboard')
            ->whereIn('key', array_keys($this->keys))
            ->delete();
    }
}
