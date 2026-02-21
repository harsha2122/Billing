<?php

use App\Models\Lang;
use App\Models\Translation;
use Illuminate\Database\Migrations\Migration;

class AddDownloadInvoiceTranslation extends Migration
{
    public function up()
    {
        $allLangs = Lang::all();

        foreach ($allLangs as $lang) {
            $exists = Translation::where('lang_id', $lang->id)
                ->where('group', 'common')
                ->where('key', 'download_invoice')
                ->exists();

            if (!$exists) {
                Translation::create([
                    'lang_id' => $lang->id,
                    'group'   => 'common',
                    'key'     => 'download_invoice',
                    'value'   => 'Download Invoice',
                ]);
            }
        }
    }

    public function down()
    {
        Translation::where('group', 'common')
            ->where('key', 'download_invoice')
            ->delete();
    }
}
