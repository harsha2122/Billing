<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckAdminOrSuperAdmin
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle(Request $request, Closure $next)
    {
        if (!auth()->check()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Unauthenticated.'
            ], 401);
        }

        $user = auth()->user();

        if (!in_array($user->role, ['admin', 'superadmin'])) {
            return response()->json([
                'status' => 'error',
                'message' => 'Access denied. Admin or Superadmin role required.'
            ], 403);
        }

        return $next($request);
    }
}
