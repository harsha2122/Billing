<?php

namespace App\Traits;

use App\Scopes\AdminScope;
use Illuminate\Support\Facades\Auth;

trait HasAdminScope
{
    protected static function bootHasAdminScope()
    {
        static::addGlobalScope(new AdminScope);

        static::creating(function ($model) {
            if (Auth::check()) {
                $user = Auth::user();
                if ($user->role === 'admin') {
                    if ($model->getTable() === 'users') {
                        if (!$model->created_by) {
                            $model->created_by = $user->id;
                        }
                    } else {
                        if (!$model->admin_id) {
                            $model->admin_id = $user->id;
                        }
                    }
                }
            }
        });
    }

    public function admin()
    {
        return $this->belongsTo('App\Models\User', 'admin_id');
    }
}
