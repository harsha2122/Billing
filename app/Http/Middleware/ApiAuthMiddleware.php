<?php

namespace App\Http\Middleware;

use App\Models\UserSession;
use Carbon\Carbon;
use Closure;
use Examyou\RestAPI\Exceptions\ApiException;

class ApiAuthMiddleware
{

	/**
	 * Handle an incoming request.
	 *
	 * @param  \Illuminate\Http\Request  $request
	 * @param  \Closure  $next
	 * @return mixed
	 */
	public function handle($request, Closure $next)
	{
		if (!auth('api')->check()) {
			throw new ApiException('UNAUTHORIZED EXCEPTION', null, 401, 401);
		}

		// Keep session activity timestamp fresh for device-limit tracking
		$token = $request->bearerToken();
		if ($token) {
			UserSession::where('session_token', hash('sha256', $token))
				->update(['last_active_at' => Carbon::now()]);
		}

		return $next($request);
	}
}
