<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckSuperAdmin
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

        if (auth()->user()->role !== 'superadmin') {
            return response()->json([
                'status' => 'error',
                'message' => 'Access denied. Superadmin role required.'
            ], 403);
        }

        return $next($request);
    }
}
