<?php

namespace App\Scopes;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Scope;
use Illuminate\Support\Facades\Auth;

class AdminScope implements Scope
{
    /**
     * Apply the scope to a given Eloquent query builder.
     *
     * @param  \Illuminate\Database\Eloquent\Builder  $builder
     * @param  \Illuminate\Database\Eloquent\Model  $model
     * @return void
     */
    public function apply(Builder $builder, Model $model)
    {
        if (Auth::check()) {
            $user = Auth::user();

            // Superadmins can see everything
            // Admins can only see their own data
            if ($user->role === 'admin') {
                $table = $model->getTable();
                if ($table === 'users') {
                    // For users table, we show the admin themselves AND users they created
                    $builder->where(function ($query) use ($user) {
                        $query->where('users.id', $user->id)
                            ->orWhere('users.created_by', $user->id);
                    });
                } else {
                    $builder->where($table . '.admin_id', $user->id);
                }
            }
        }
    }
}
