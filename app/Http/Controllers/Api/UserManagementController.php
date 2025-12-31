<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\ApiBaseController;
use App\Models\User;
use Examyou\RestAPI\ApiResponse;
use Examyou\RestAPI\Exceptions\ApiException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class UserManagementController extends ApiBaseController
{
    public function __construct()
    {
        // Only superadmin can access these routes
        $this->middleware('check.superadmin');
    }

    /**
     * Display a listing of all users (superadmin only)
     */
    public function index(Request $request)
    {
        $users = User::with(['role', 'warehouse'])
            ->when($request->has('role'), function ($query) use ($request) {
                return $query->where('role', $request->role);
            })
            ->when($request->has('search'), function ($query) use ($request) {
                return $query->where(function ($q) use ($request) {
                    $q->where('name', 'like', '%' . $request->search . '%')
                        ->orWhere('email', 'like', '%' . $request->search . '%');
                });
            })
            ->orderBy('created_at', 'desc')
            ->paginate(20);

        return ApiResponse::make('Users fetched successfully', [
            'users' => $users
        ]);
    }

    /**
     * Store a newly created user
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:8',
            'phone' => 'nullable|string',
            'role' => 'required|in:superadmin,admin',
            'warehouse_id' => 'nullable|exists:warehouses,id',
            'user_type' => 'nullable|string',
            'status' => 'nullable|in:enabled,disabled',
        ]);

        $validated['user_type'] = 'staff_members';
        $validated['status'] = $validated['status'] ?? 'enabled';
        $validated['company_id'] = auth()->user()->company_id;

        $user = User::create($validated);

        return ApiResponse::make('User created successfully', [
            'user' => $user->load(['role', 'warehouse'])
        ], 201);
    }

    /**
     * Display the specified user
     */
    public function show($id)
    {
        $userId = $this->getIdFromHash($id);
        $user = User::with(['role', 'warehouse', 'details'])->findOrFail($userId);

        return ApiResponse::make('User fetched successfully', [
            'user' => $user
        ]);
    }

    /**
     * Update the specified user
     */
    public function update(Request $request, $id)
    {
        $userId = $this->getIdFromHash($id);
        $user = User::findOrFail($userId);

        // Prevent editing your own role
        if ($user->id === auth()->id() && $request->has('role')) {
            throw new ApiException('Cannot change your own role');
        }

        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|email|unique:users,email,' . $userId,
            'password' => 'nullable|min:8',
            'phone' => 'nullable|string',
            'role' => 'sometimes|in:superadmin,admin',
            'warehouse_id' => 'nullable|exists:warehouses,id',
            'status' => 'sometimes|in:enabled,disabled',
        ]);

        // Remove password if empty
        if (isset($validated['password']) && empty($validated['password'])) {
            unset($validated['password']);
        }

        $user->update($validated);

        return ApiResponse::make('User updated successfully', [
            'user' => $user->load(['role', 'warehouse'])
        ]);
    }

    /**
     * Remove the specified user
     */
    public function destroy($id)
    {
        $userId = $this->getIdFromHash($id);
        $user = User::findOrFail($userId);

        // Prevent deleting yourself
        if ($user->id === auth()->id()) {
            throw new ApiException('Cannot delete your own account');
        }

        // Check if user has associated data
        $hasOrders = $user->orders()->exists();
        $hasProducts = $user->products()->exists();

        if ($hasOrders || $hasProducts) {
            throw new ApiException('Cannot delete user with associated data. Please reassign their data first.');
        }

        $user->delete();

        return ApiResponse::make('User deleted successfully');
    }

    /**
     * Update user role (superadmin only)
     */
    public function updateRole(Request $request, $id)
    {
        $userId = $this->getIdFromHash($id);
        $user = User::findOrFail($userId);

        // Prevent changing your own role
        if ($user->id === auth()->id()) {
            throw new ApiException('Cannot change your own role');
        }

        $validated = $request->validate([
            'role' => 'required|in:superadmin,admin',
        ]);

        $user->update(['role' => $validated['role']]);

        return ApiResponse::make('User role updated successfully', [
            'user' => $user
        ]);
    }

    /**
     * Get statistics about users
     */
    public function stats()
    {
        $stats = [
            'total_users' => User::count(),
            'superadmins' => User::where('role', 'superadmin')->count(),
            'admins' => User::where('role', 'admin')->count(),
            'active_users' => User::where('status', 'enabled')->count(),
            'inactive_users' => User::where('status', 'disabled')->count(),
        ];

        return ApiResponse::make('Stats fetched successfully', $stats);
    }

    /**
     * Reassign data from one admin to another
     */
    public function reassignData(Request $request)
    {
        $validated = $request->validate([
            'from_user_id' => 'required|exists:users,id',
            'to_user_id' => 'required|exists:users,id',
        ]);

        $fromUserId = $this->getIdFromHash($validated['from_user_id']);
        $toUserId = $this->getIdFromHash($validated['to_user_id']);

        $fromUser = User::findOrFail($fromUserId);
        $toUser = User::findOrFail($toUserId);

        // Only allow reassigning from admin users
        if ($fromUser->role !== 'admin') {
            throw new ApiException('Can only reassign data from admin users');
        }

        // Reassign all data
        \DB::transaction(function () use ($fromUserId, $toUserId) {
            \DB::table('products')->where('admin_id', $fromUserId)->update(['admin_id' => $toUserId]);
            \DB::table('orders')->where('admin_id', $fromUserId)->update(['admin_id' => $toUserId]);
            \DB::table('expenses')->where('admin_id', $fromUserId)->update(['admin_id' => $toUserId]);
            \DB::table('brands')->where('admin_id', $fromUserId)->update(['admin_id' => $toUserId]);
            \DB::table('categories')->where('admin_id', $fromUserId)->update(['admin_id' => $toUserId]);
            \DB::table('warehouses')->where('admin_id', $fromUserId)->update(['admin_id' => $toUserId]);
            \DB::table('payments')->where('admin_id', $fromUserId)->update(['admin_id' => $toUserId]);
            \DB::table('users')->where('created_by', $fromUserId)->update(['created_by' => $toUserId]);
        });

        return ApiResponse::make('Data reassigned successfully');
    }
}
