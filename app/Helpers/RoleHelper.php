<?php

if (!function_exists('isSuperAdmin')) {
    /**
     * Check if the authenticated user is a superadmin
     *
     * @return bool
     */
    function isSuperAdmin()
    {
        return auth()->check() && auth()->user()->role === 'superadmin';
    }
}

if (!function_exists('isAdmin')) {
    /**
     * Check if the authenticated user is an admin
     *
     * @return bool
     */
    function isAdmin()
    {
        return auth()->check() && auth()->user()->role === 'admin';
    }
}

if (!function_exists('canManageUsers')) {
    /**
     * Check if the authenticated user can manage other users
     *
     * @return bool
     */
    function canManageUsers()
    {
        return isSuperAdmin();
    }
}

if (!function_exists('canViewAllData')) {
    /**
     * Check if the authenticated user can view all data
     *
     * @return bool
     */
    function canViewAllData()
    {
        return isSuperAdmin();
    }
}

if (!function_exists('getUserRole')) {
    /**
     * Get the role of the authenticated user
     *
     * @return string|null
     */
    function getUserRole()
    {
        return auth()->check() ? auth()->user()->role : null;
    }
}

if (!function_exists('canAccessRoute')) {
    /**
     * Check if user can access a specific route based on role
     *
     * @param string $routeName
     * @return bool
     */
    function canAccessRoute($routeName)
    {
        $superadminOnlyRoutes = [
            'users.index',
            'users.create',
            'users.store',
            'users.edit',
            'users.update',
            'users.destroy',
            'users.reassign',
        ];

        if (in_array($routeName, $superadminOnlyRoutes)) {
            return isSuperAdmin();
        }

        return auth()->check();
    }
}
