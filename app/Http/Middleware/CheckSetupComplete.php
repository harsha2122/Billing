<?php

namespace App\Http\Middleware;

use Closure;
use Examyou\RestAPI\Exceptions\ApiException;

class CheckSetupComplete
{
    public function handle($request, Closure $next)
    {
        if (auth('api')->check()) {
            $user = auth('api')->user();

            // Skip for superadmin
            if ($user->is_superadmin) {
                return $next($request);
            }

            $company = company();

            // If company exists and setup not completed, only allow setup routes
            if ($company && !$company->setup_completed) {
                $routeName = $request->route()->getName();

                // Allow setup routes and basic auth routes
                $allowedRoutes = [
                    'api.setup.index',
                    'api.setup.complete',
                    'api.extra.user',
                    'api.extra.profile',
                    'api.auth.logout',
                ];

                if (!in_array($routeName, $allowedRoutes)) {
                    throw new ApiException('Please complete initial setup first', null, 403, 403, 2001);
                }
            }
        }

        return $next($request);
    }
}
