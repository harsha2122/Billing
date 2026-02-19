<?php

namespace App\Http\Controllers\Api;

use App\Classes\Common;
use App\Http\Controllers\ApiBaseController;
use App\Http\Requests\Api\Auth\LoginRequest;
use App\Http\Requests\Api\Auth\ProfileRequest;
use App\Http\Requests\Api\Auth\RefreshTokenRequest;
use App\Http\Requests\Api\Auth\UploadFileRequest;
use App\Models\Company;
use App\Models\Currency;
use App\Models\Customer;
use App\Models\Expense;
use App\Models\Lang;
use App\Models\LoginOtp;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Payment;
use App\Models\PaymentMode;
use App\Models\Product;
use App\Models\Settings;
use App\Models\Translation;
use App\Models\User;
use App\Models\UserSession;
use App\Models\Warehouse;
use App\Models\AppSettings;
use App\Scopes\CompanyScope;
use Carbon\Carbon;
use Carbon\CarbonPeriod;
use Examyou\RestAPI\ApiResponse;
use Examyou\RestAPI\Exceptions\ApiException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;


class AuthController extends ApiBaseController
{

    public function companySetting()
    {
        $settings = Company::first();

        return ApiResponse::make('Success', [
            'global_setting' => $settings,
        ]);
    }

    public function emailSettingVerified()
    {
        $emailSettingVerified = Settings::where('setting_type', 'email')
            ->where('status', 1)
            ->where('verified', 1)
            ->count();

        return $emailSettingVerified > 0 ? 1 : 0;
    }

    public function app()
    {
        $company = company(true);

        // For SaaS mode, if no company (user not logged in), get first company for login page
        if (!$company && app_type() == 'saas') {
            $company = Company::with(['currency', 'warehouse'])->first();
        }

        $addMenuSetting = $company ? Settings::where('setting_type', 'shortcut_menus')->first() : null;
        $totalPaymentModes = PaymentMode::count();
        $totalCurrencies = Currency::count();
        $totalWarehouses = Warehouse::count();

        // Get global app settings
        $appSettings = AppSettings::first();

        return ApiResponse::make('Success', [
            'app' => $company,
            'app_settings' => $appSettings,
            'shortcut_menus' => $addMenuSetting,
            'email_setting_verified' => $this->emailSettingVerified(),
            'total_currencies' => $totalCurrencies,
            'total_warehouses' => $totalWarehouses,
            'total_payment_modes' => $totalPaymentModes
        ]);
    }

    public function checkSubscriptionModuleVisibility()
    {
        $request = request();
        $itemType = $request->item_type;

        $visible = Common::checkSubscriptionModuleVisibility($itemType);

        return ApiResponse::make('Success', [
            'visible' => $visible,
        ]);
    }

    public function visibleSubscriptionModules()
    {
        $visibleSubscriptionModules = Common::allVisibleSubscriptionModules();

        return ApiResponse::make('Success', $visibleSubscriptionModules);
    }

    public function allEnabledLangs()
    {
        $allLangs = Lang::select('id', 'name', 'key', 'image')->where('enabled', 1)->get();

        return ApiResponse::make('Success', [
            'langs' => $allLangs
        ]);
    }

    public function pdf($uniqueId, $langKey = "en")
    {
        $order = Order::with(['warehouse', 'user', 'items', 'items.product', 'items.unit', 'orderPayments:id,order_id,payment_id,amount', 'orderPayments.payment:id,payment_mode_id', 'orderPayments.payment.paymentMode:id,name', 'posInvoiceTemplate'])
            ->where('unique_id', $uniqueId)
            ->first();

        $lang = Lang::where('key', $langKey)->first();
        if (!$lang) {
            $lang = Lang::where('key', 'en')->first();
        }

        $invoiceTranslation = Translation::where('lang_id', $lang->id)
            ->where('group', 'invoice')
            ->pluck('value', 'key')
            ->toArray();

        $company = Company::with('currency')->first();

        // Determine template slug
        $templateSlug = 'default';
        if ($order->posInvoiceTemplate) {
            $templateSlug = $order->posInvoiceTemplate->slug;
        }

        // Calculate amount in words
        $amountInWords = \App\Helpers\NumberToWords::convert($order->total);

        // Calculate GST breakup if needed
        $gstBreakup = null;
        $sellerStateCode = $order->warehouse ? $order->warehouse->state_code : ($company->state_code ?? '');
        $buyerStateCode = $order->user && $order->user->state_code ? $order->user->state_code : $sellerStateCode;

        if ($order->posInvoiceTemplate && $order->posInvoiceTemplate->show_gst_breakup) {
            $gstBreakup = Common::getGstBreakup($order->tax_amount, $sellerStateCode, $buyerStateCode);
        }

        $pdfData = [
            'order' => $order,
            'company' => $company,
            'dateTimeFormat' => 'd-m-Y',
            'traslations' => $invoiceTranslation,
            'amountInWords' => $amountInWords,
            'gstBreakup' => $gstBreakup,
            'templateSlug' => $templateSlug,
        ];

        // Use template-specific view if it exists
        $viewName = 'invoice-templates.' . $templateSlug;
        if (!view()->exists($viewName)) {
            $viewName = 'pdf';
        }

        $html = view($viewName, $pdfData);

        $pdf = app('dompdf.wrapper');
        if ($templateSlug === 'landscape-theme-1') {
            $pdf->setPaper('a4', 'landscape');
        }
        $pdf->loadHTML($html);
        return $pdf->download();
    }

    public function login(LoginRequest $request)
    {
        // Removing all sessions before login
        session()->flush();

        $phone = "";
        $email = "";

        $credentials = [
            'password' =>  $request->password
        ];

        if (is_numeric($request->get('email'))) {
            $credentials['phone'] = $request->email;
            $phone = $request->email;
        } else {
            $credentials['email'] = $request->email;
            $email = $request->email;
        }

        // Attempt authentication without user_type
        if (!$token = auth('api')->attempt($credentials)) {
            throw new ApiException('These credentials do not match our records.');
        }

        // Get authenticated user and check company status
        $authenticatedUser = auth('api')->user();

        if (!$authenticatedUser->is_superadmin) {
            $userCompany = Company::where('id', $authenticatedUser->company_id)->first();

            if ($userCompany && $userCompany->status === 'pending') {
                throw new ApiException('Your company not verified.');
            }

            if ($userCompany && $userCompany->status === 'inactive') {
                throw new ApiException('Company account deactivated.');
            }
        }

        if ($authenticatedUser->status === 'waiting') {
            throw new ApiException('User not verified.');
        }

        if ($authenticatedUser->status === 'disabled') {
            throw new ApiException('Account deactivated.');
        }

        // Check device limit (only for non-superadmin users)
        if (!$authenticatedUser->is_superadmin) {
            $userCompanyForLimit = $userCompany ?? Company::where('id', $authenticatedUser->company_id)->first();
            if ($userCompanyForLimit && $userCompanyForLimit->max_devices > 0) {
                $activeSessions = UserSession::where('company_id', $userCompanyForLimit->id)->count();
                if ($activeSessions >= $userCompanyForLimit->max_devices) {
                    auth('api')->logout();
                    throw new ApiException('Device limit reached (' . $userCompanyForLimit->max_devices . '). Please logout from a previous device to continue.');
                }
            }
        }

        // Check if OTP is enabled (only for non-superadmin users)
        if (!$authenticatedUser->is_superadmin && $this->isOtpEnabled()) {
            // Logout the temporary auth so token is not usable yet
            auth('api')->logout();

            // Generate and send OTP
            $otp = $this->generateAndSendOtp($authenticatedUser);

            if (!$otp) {
                throw new ApiException('Failed to send OTP. Please contact administrator.');
            }

            return ApiResponse::make('OTP sent to your email', [
                'requires_otp' => true,
                'user_uid' => $authenticatedUser->xid,
                'email_hint' => $this->maskEmail($authenticatedUser->email),
            ]);
        }

        // Get company - for superadmin, use first company
        $company = company();
        if (!$company && $authenticatedUser->is_superadmin) {
            $company = Company::with(['currency', 'warehouse'])->first();
        }

        $response = $this->respondWithToken($token);

        // Track device session
        $this->createDeviceSession($authenticatedUser, $token);

        $addMenuSetting = $company ? Settings::where('setting_type', 'shortcut_menus')->first() : null;
        $appSettings = AppSettings::first();
        $response['app'] = $company;
        $response['app_settings'] = $appSettings;
        $response['shortcut_menus'] = $addMenuSetting;
        $response['email_setting_verified'] = $this->emailSettingVerified();
        $response['visible_subscription_modules'] = Common::allVisibleSubscriptionModules();

        return ApiResponse::make('Loggged in successfull', $response);
    }

    public function verifyOtp(Request $request)
    {
        $request->validate([
            'user_uid' => 'required',
            'otp' => 'required|string|size:6',
            'email' => 'required',
            'password' => 'required',
        ]);

        // Find user by xid
        $userId = Common::getIdFromHash($request->user_uid);
        $user = User::find($userId);

        if (!$user) {
            throw new ApiException('Invalid request.');
        }

        // Verify OTP
        $otpRecord = LoginOtp::where('user_id', $user->id)
            ->where('otp', $request->otp)
            ->where('used', false)
            ->where('expires_at', '>', Carbon::now())
            ->latest()
            ->first();

        if (!$otpRecord) {
            throw new ApiException('Invalid or expired OTP.');
        }

        // Mark OTP as used
        $otpRecord->used = true;
        $otpRecord->save();

        // Re-authenticate user with credentials
        $credentials = ['password' => $request->password];
        if (is_numeric($request->email)) {
            $credentials['phone'] = $request->email;
        } else {
            $credentials['email'] = $request->email;
        }

        if (!$token = auth('api')->attempt($credentials)) {
            throw new ApiException('Authentication failed.');
        }

        $authenticatedUser = auth('api')->user();

        // Check device limit
        if (!$authenticatedUser->is_superadmin) {
            $userCompany = Company::where('id', $authenticatedUser->company_id)->first();
            if ($userCompany && $userCompany->max_devices > 0) {
                $activeSessions = UserSession::where('company_id', $userCompany->id)->count();
                if ($activeSessions >= $userCompany->max_devices) {
                    auth('api')->logout();
                    throw new ApiException('Device limit reached (' . $userCompany->max_devices . '). Please logout from a previous device to continue.');
                }
            }
        }

        // Get company
        $company = company();
        if (!$company && $authenticatedUser->is_superadmin) {
            $company = Company::with(['currency', 'warehouse'])->first();
        }

        $response = $this->respondWithToken($token);

        // Track device session
        $this->createDeviceSession($authenticatedUser, $token);

        $addMenuSetting = $company ? Settings::where('setting_type', 'shortcut_menus')->first() : null;
        $appSettings = AppSettings::first();
        $response['app'] = $company;
        $response['app_settings'] = $appSettings;
        $response['shortcut_menus'] = $addMenuSetting;
        $response['email_setting_verified'] = $this->emailSettingVerified();
        $response['visible_subscription_modules'] = Common::allVisibleSubscriptionModules();

        return ApiResponse::make('Loggged in successfull', $response);
    }

    protected function isOtpEnabled()
    {
        // Check the company's email settings for require_otp_signin flag
        $emailSetting = Settings::where('setting_type', 'email')
            ->where('status', 1)
            ->where('verified', 1)
            ->first();

        if ($emailSetting && $emailSetting->other_data) {
            $otherData = $emailSetting->other_data;
            if (isset($otherData['require_otp_signin']) && $otherData['require_otp_signin']) {
                return true;
            }
        }

        // Fallback: check legacy global otp_mail setting
        $setting = Settings::withoutGlobalScope(CompanyScope::class)
            ->where('setting_type', 'otp_mail')
            ->where('is_global', 1)
            ->where('status', 1)
            ->where('verified', 1)
            ->first();

        return $setting ? true : false;
    }

    protected function generateAndSendOtp($user)
    {
        // Invalidate old OTPs
        LoginOtp::where('user_id', $user->id)->where('used', false)->update(['used' => true]);

        // Generate 6-digit OTP
        $otpCode = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);

        $otpRecord = LoginOtp::create([
            'user_id' => $user->id,
            'otp' => $otpCode,
            'expires_at' => Carbon::now()->addMinutes(5),
        ]);

        // First try company email SMTP settings (admin-configured)
        $creds = null;
        $emailSetting = Settings::where('setting_type', 'email')
            ->where('status', 1)
            ->where('verified', 1)
            ->first();

        if ($emailSetting && $emailSetting->name_key == 'smtp' && $emailSetting->credentials) {
            $creds = $emailSetting->credentials;
        }

        // Fallback: legacy global otp_mail setting
        if (!$creds) {
            $setting = Settings::withoutGlobalScope(CompanyScope::class)
                ->where('setting_type', 'otp_mail')
                ->where('is_global', 1)
                ->where('status', 1)
                ->first();

            if ($setting && $setting->credentials) {
                $creds = $setting->credentials;
            }
        }

        if (!$creds) {
            return false;
        }

        try {
            $transport = new \Swift_SmtpTransport($creds['host'], $creds['port'], $creds['encryption']);
            $transport->setUsername($creds['username']);
            $transport->setPassword($creds['password']);

            $mailer = new \Swift_Mailer($transport);

            $message = (new \Swift_Message('Login OTP Verification'))
                ->setFrom([$creds['from_email'] => $creds['from_name']])
                ->setTo([$user->email])
                ->setBody(
                    '<div style="font-family:Arial,sans-serif;max-width:500px;margin:0 auto;padding:20px;">' .
                    '<h2 style="color:#5254cf;">Login Verification</h2>' .
                    '<p>Hello ' . e($user->name) . ',</p>' .
                    '<p>Your One-Time Password (OTP) for login is:</p>' .
                    '<div style="background:#f0efff;padding:15px;text-align:center;border-radius:8px;margin:20px 0;">' .
                    '<span style="font-size:32px;font-weight:bold;letter-spacing:8px;color:#5254cf;">' . $otpCode . '</span>' .
                    '</div>' .
                    '<p>This OTP is valid for <strong>5 minutes</strong>.</p>' .
                    '<p>If you did not request this, please ignore this email.</p>' .
                    '</div>',
                    'text/html'
                );

            $mailer->send($message);
            return true;
        } catch (\Exception $e) {
            \Log::error('OTP Mail Error: ' . $e->getMessage());
            return false;
        }
    }

    protected function maskEmail($email)
    {
        if (!$email) return '';
        $parts = explode('@', $email);
        $name = $parts[0];
        $domain = $parts[1] ?? '';
        $masked = substr($name, 0, 2) . str_repeat('*', max(strlen($name) - 2, 2));
        return $masked . '@' . $domain;
    }

    protected function respondWithToken($token)
    {
        $user = user();

        return [
            'token' => $token,
            'token_type' => 'bearer',
            'expires_in' => Carbon::now()->addDays(180),
            'user' => $user
        ];
    }

    public function logout()
    {
        $request = request();

        if (auth('api')->user() && $request->bearerToken() != '') {
            // Remove device session
            $sessionToken = hash('sha256', $request->bearerToken());
            UserSession::where('session_token', $sessionToken)->delete();

            auth('api')->logout();
        }

        session()->flush();

        return ApiResponse::make(__('Session closed successfully'));
    }

    protected function createDeviceSession($user, $token)
    {
        $request = request();
        $sessionToken = hash('sha256', $token);

        UserSession::create([
            'user_id' => $user->id,
            'company_id' => $user->company_id,
            'session_token' => $sessionToken,
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
            'last_active_at' => Carbon::now(),
        ]);
    }

    public function user()
    {
        $user = auth('api')->user();

        // Load role without CompanyScope to ensure tenant admin role is loaded
        $role = \App\Models\Role::withoutGlobalScope(\App\Scopes\CompanyScope::class)
            ->with('perms')
            ->find($user->role_id);

        $user->load('warehouse');
        $user->setRelation('role', $role);

        session(['user' => $user]);

        return ApiResponse::make('Data successfull', [
            'user' => $user
        ]);
    }

    public function refreshToken(RefreshTokenRequest $request)
    {
        $newToken = auth('api')->refresh();

        $response = $this->respondWithToken($newToken);

        return ApiResponse::make('Token fetched successfully', $response);
    }

    public function uploadFile(UploadFileRequest $request)
    {
        $result = Common::uploadFile($request);

        return ApiResponse::make('File Uploaded', $result);
    }

    public function profile(ProfileRequest $request)
    {
        $user = auth('api')->user();

        // In Demo Mode
        if (env('APP_ENV') == 'production') {
            $request = request();

            if ($request->email == 'admin@example.com' && $request->has('password') && $request->password != '') {
                throw new ApiException('Not Allowed In Demo Mode');
            }
        }

        $user->name = $request->name;
        if ($request->has('profile_image')) {
            $user->profile_image = $request->profile_image;
        }
        if ($request->password != '') {
            $user->password = $request->password;
        }
        $user->phone = $request->phone;
        $user->address = $request->address;
        $user->save();

        return ApiResponse::make('Profile updated successfull', [
            'user' => $user->load('role', 'role.perms')
        ]);
    }

    public function langTrans()
    {
        $langs = Lang::with('translations')->get();

        return ApiResponse::make('Langs fetched', [
            'data' => $langs
        ]);
    }

    public function dashboard(Request $request)
    {
        $data = [
            'topSellingProducts' => $this->getTopProducts(),
            'purchaseSales' => $this->getPurchaseSales(),
            'stockAlerts' => $this->getStockAlerts(5),
            'topCustomers' => $this->getSalesTopCustomers(),
            'stockHistoryStatsData' => $this->getStockHistoryStatsData(),
            'stateData' => $this->getStatsData(),
            'paymentChartData' => $this->getPaymentChartData(),
        ];

        return ApiResponse::make('Data fetched', $data);
    }

    public function stockAlerts()
    {
        $data = [
            'stockAlerts' => $this->getStockAlerts(),
        ];

        return ApiResponse::make('Data fetched', $data);
    }

    public function getStockAlerts($limit = null)
    {
        $request = request();
        $warehouseId = $this->getWarehouseId();

        $warehouseStocks = Product::select('products.id as product_id', 'products.name as product_name', 'product_details.current_stock', 'product_details.stock_quantitiy_alert', 'units.short_name')
            ->join('product_details', 'product_details.product_id', '=', 'products.id')
            ->join('units', 'units.id', '=', 'products.unit_id')
            ->whereNotNull('product_details.stock_quantitiy_alert')
            ->whereRaw('product_details.current_stock <= product_details.stock_quantitiy_alert');

        // If user not have admin role
        // then he can only view reords
        // of warehouse assigned to him
        $warehouseStocks = $warehouseStocks->where('product_details.warehouse_id', '=', $warehouseId);

        if ($request->has('product_id') && $request->product_id != null) {
            $productId = $this->getIdFromHash($request->product_id);
            $warehouseStocks = $warehouseStocks->where('product_details.product_id', '=', $productId);
        }
        if ($limit != null) {
            $warehouseStocks = $warehouseStocks->take($limit);
        }
        $warehouseStocks = $warehouseStocks->get();

        return $warehouseStocks;
    }

    public function getStatsData()
    {
        $request = request();
        $warehouseId = $this->getWarehouseId();

        // Total Sales
        $totalSalesAmount = Order::where('order_type', 'sales');
        // Total Expenses
        $totalExpenses = Expense::select('amount');
        // Payment Sent
        $paymentSent = Payment::where('payments.payment_type', 'out');
        // Payment Received
        $paymentReceived = Payment::where('payments.payment_type', 'in');

        // Warehouse Filter
        if ($warehouseId && $warehouseId != null) {
            $totalSalesAmount = $totalSalesAmount->where('orders.warehouse_id', $warehouseId);
            $totalExpenses = $totalExpenses->where('warehouse_id', $warehouseId);
        }

        // Dates Filters
        if ($request->has('dates') && $request->dates != null && count($request->dates) > 0) {
            $dates = $request->dates;
            $startDate = $dates[0];
            $endDate = $dates[1];

            $totalSalesAmount = $totalSalesAmount->whereRaw('DATE(orders.order_date) >= ?', [$startDate])
                ->whereRaw('DATE(orders.order_date) <= ?', [$endDate]);
            $totalExpenses = $totalExpenses->whereRaw('DATE(expenses.date) >= ?', [$startDate])
                ->whereRaw('DATE(expenses.date) <= ?', [$endDate]);
            $paymentSent = $paymentSent->whereRaw('DATE(payments.date) >= ?', [$startDate])
                ->whereRaw('DATE(payments.date) <= ?', [$endDate]);
            $paymentReceived = $paymentReceived->whereRaw('DATE(payments.date) >= ?', [$startDate])
                ->whereRaw('DATE(payments.date) <= ?', [$endDate]);
        }

        $totalSalesAmount = $totalSalesAmount->sum('total');
        $totalExpenses = $totalExpenses->sum('amount');
        $paymentSent = $paymentSent->sum('payments.amount');
        $paymentReceived = $paymentReceived->sum('payments.amount');

        return [
            'totalSales' => $totalSalesAmount,
            'totalExpenses' => $totalExpenses,
            'paymentSent' => $paymentSent,
            'paymentReceived' => $paymentReceived,
        ];
    }

    public function getPaymentChartData()
    {
        $request = request();
        $warehouseId = $this->getWarehouseId();
        if ($request->has('dates') && $request->dates != null && count($request->dates) > 0) {
            $dates = $request->dates;
            $startDate = $dates[0];
            $endDate = $dates[1];
        } else {
            $startDate =  Carbon::now()->subDays(30)->format("Y-m-d");
            $endDate =  Carbon::now()->format("Y-m-d");
        }

        // Sent Payments
        $allSentPayments = Payment::select(DB::raw('date(payments.date) as date, sum(payments.amount) as total_amount'))
            ->where('payments.payment_type', 'out')
            ->whereRaw('DATE(payments.date) >= ?', [$startDate])
            ->whereRaw('DATE(payments.date) <= ?', [$endDate]);

        // Received Payments
        $allReceivedPayments = Payment::select(DB::raw('date(payments.date) as date, sum(payments.amount) as total_amount'))
            ->where('payments.payment_type', 'in')
            ->whereRaw('DATE(payments.date) >= ?', [$startDate])
            ->whereRaw('DATE(payments.date) <= ?', [$endDate]);



        // Sent Payments
        $allSentPayments = $allSentPayments->groupByRaw('date(payments.date)')
            ->orderByRaw("date(payments.date) asc")
            ->pluck('total_amount', 'date');

        // Received Payments
        $allReceivedPayments = $allReceivedPayments->groupByRaw('date(payments.date)')
            ->orderByRaw("date(payments.date) asc")
            ->pluck('total_amount', 'date');

        $periodDates = CarbonPeriod::create($startDate, $endDate);
        $datesArray = [];
        $sentPaymentsArray = [];
        $receivedPaymentsArray = [];

        // Iterate over the period
        foreach ($periodDates as $periodDate) {
            $currentDate =  $periodDate->format('Y-m-d');

            if (isset($allSentPayments[$currentDate]) || isset($allReceivedPayments[$currentDate])) {
                $datesArray[] = $currentDate;
                $sentPaymentsArray[] = isset($allSentPayments[$currentDate]) ? $allSentPayments[$currentDate] : 0;
                $receivedPaymentsArray[] = isset($allReceivedPayments[$currentDate]) ? $allReceivedPayments[$currentDate] : 0;
            }
        }

        return [
            'dates' => $datesArray,
            'sent' => $sentPaymentsArray,
            'received' => $receivedPaymentsArray,
        ];
    }

    public function getStockHistoryStatsData()
    {
        $request = request();
        $warehouseId = $this->getWarehouseId();

        // Total Sales
        $totalSales = OrderItem::join('orders', 'orders.id', '=', 'order_items.order_id')->where('order_type', 'sales');
        // Sales Returns
        $totalSalesReturns = OrderItem::join('orders', 'orders.id', '=', 'order_items.order_id')->where('order_type', 'sales-returns');
        // Purchases
        $totalPurchases = OrderItem::join('orders', 'orders.id', '=', 'order_items.order_id')->where('order_type', 'purchases');
        // Purchase Returns
        $totalPurchaseReturns = OrderItem::join('orders', 'orders.id', '=', 'order_items.order_id')->where('order_type', 'purchase-returns');

        // Warehouse Filter
        if ($warehouseId && $warehouseId != null) {
            $totalSales = $totalSales->where('orders.warehouse_id', $warehouseId);
            $totalSalesReturns = $totalSalesReturns->where('warehouse_id', $warehouseId);
            $totalPurchases = $totalPurchases->where('orders.warehouse_id', $warehouseId);
            $totalPurchaseReturns = $totalPurchaseReturns->where('orders.warehouse_id', $warehouseId);
        }

        // Dates Filters
        if ($request->has('dates') && $request->dates != null && count($request->dates) > 0) {
            $dates = $request->dates;
            $startDate = $dates[0];
            $endDate = $dates[1];

            $totalSales = $totalSales->whereRaw('DATE(orders.order_date) >= ?', [$startDate])
                ->whereRaw('DATE(orders.order_date) <= ?', [$endDate]);
            $totalSalesReturns = $totalSalesReturns->whereRaw('DATE(orders.order_date) >= ?', [$startDate])
                ->whereRaw('DATE(orders.order_date) <= ?', [$endDate]);
            $totalPurchases = $totalPurchases->whereRaw('DATE(orders.order_date) >= ?', [$startDate])
                ->whereRaw('DATE(orders.order_date) <= ?', [$endDate]);
            $totalPurchaseReturns = $totalPurchaseReturns->whereRaw('DATE(orders.order_date) >= ?', [$startDate])
                ->whereRaw('DATE(orders.order_date) <= ?', [$endDate]);
        }

        $totalSales = $totalSales->sum('order_items.quantity');
        $totalPurchases = $totalPurchases->sum('order_items.quantity');
        $totalSalesReturns = $totalSalesReturns->sum('order_items.quantity');
        $totalPurchaseReturns = $totalPurchaseReturns->sum('order_items.quantity');

        return [
            'totalSales' => $totalSales,
            'totalPurchases' => $totalPurchases,
            'totalSalesReturn' => $totalPurchaseReturns,
            'totalPurchaseReturn' => $totalPurchaseReturns,
        ];
    }

    public function getTopProducts()
    {
        $request = request();
        $warehouse = warehouse();
        // For superadmins without assigned warehouse, set warehouseId to null
        $warehouseId = $warehouse ? $warehouse->id : null;

        $colors = ["#20C997", "#5F63F2", "#ffa040", "#FFCD56", "#ff6385"];

        $maxSellingProducts = OrderItem::select('order_items.product_id', DB::raw('sum(order_items.subtotal) as total_amount'))
            ->join('orders', 'orders.id', '=', 'order_items.order_id')
            ->where('orders.order_type', 'sales');

        if ($warehouseId && $warehouseId != null) {
            $maxSellingProducts = $maxSellingProducts->where('orders.warehouse_id', $warehouseId);
        }

        if ($request->has('dates') && $request->dates != null && count($request->dates) > 0) {
            $dates = $request->dates;
            $startDate = $dates[0];
            $endDate = $dates[1];

            $maxSellingProducts = $maxSellingProducts->whereRaw('DATE(orders.order_date) >= ?', [$startDate])
                ->whereRaw('DATE(orders.order_date) <= ?', [$endDate]);
        }

        $maxSellingProducts = $maxSellingProducts->groupBy('order_items.product_id')
            ->orderByRaw("sum(order_items.subtotal) desc")
            ->take(5)
            ->get();

        $topSellingProductsNames = [];
        $topSellingProductsValues = [];
        $topSellingProductsColors = [];
        $counter = 0;
        foreach ($maxSellingProducts as $maxSellingProduct) {
            $product = Product::select('name')->find($maxSellingProduct->product_id);

            $topSellingProductsNames[] = $product->name;
            $topSellingProductsValues[] = $maxSellingProduct->total_amount;
            $topSellingProductsColors[] = $colors[$counter];
            $counter++;
        }

        return [
            'labels' => $topSellingProductsNames,
            'values' => $topSellingProductsValues,
            'colors' => $topSellingProductsColors,
        ];
    }

    public function getWarehouseId()
    {
        $warehouse = warehouse();

        // For superadmins without assigned warehouse, return null
        if (!$warehouse) {
            return null;
        }

        $warehouseId = $warehouse->id;

        return $warehouseId;
    }

    public function getSalesTopCustomers()
    {
        $request = request();
        $warehouseId = $this->getWarehouseId();

        $topCustomers = Order::select(DB::raw('sum(orders.total) as total_amount, user_id, count(user_id) as total_sales'))
            ->join('users', 'users.id', '=', 'orders.user_id')
            ->where('orders.order_type', '=', 'sales');

        if ($warehouseId && $warehouseId != null) {
            $topCustomers = $topCustomers->where('orders.warehouse_id', $warehouseId);
        }

        if ($request->has('dates') && $request->dates != null && count($request->dates) > 0) {
            $dates = $request->dates;
            $startDate = $dates[0];
            $endDate = $dates[1];

            $topCustomers = $topCustomers->whereRaw('DATE(orders.order_date) >= ?', [$startDate])
                ->whereRaw('DATE(orders.order_date) <= ?', [$endDate]);
        }

        $topCustomers = $topCustomers->groupByRaw('user_id')
            ->orderByRaw('sum(orders.total) desc')
            ->take(5)
            ->get();

        $results = [];

        foreach ($topCustomers as $topCustomer) {
            $customer = Customer::select('id', 'name', 'profile_image')->find($topCustomer->user_id);

            $results[] = [
                'customer_id' => $customer->xid,
                'customer' => $customer,
                'total_amount' => $topCustomer->total_amount,
                'total_sales' => $topCustomer->total_sales,
            ];
        }

        return $results;
    }

    public function getPurchaseSales()
    {
        $request = request();
        $warehouseId = $this->getWarehouseId();
        if ($request->has('dates') && $request->dates != null && count($request->dates) > 0) {
            $dates = $request->dates;
            $startDate = $dates[0];
            $endDate = $dates[1];
        } else {
            $startDate =  Carbon::now()->subDays(30)->format("Y-m-d");
            $endDate =  Carbon::now()->format("Y-m-d");
        }

        $allPurchases = Order::select(DB::raw('date(orders.order_date) as date, sum(orders.total) as total_amount'))
            ->where('orders.order_type', 'purchases')
            ->whereRaw('DATE(orders.order_date) >= ?', [$startDate])
            ->whereRaw('DATE(orders.order_date) <= ?', [$endDate]);
        if ($warehouseId && $warehouseId != null) {
            $allPurchases = $allPurchases->where('orders.warehouse_id', $warehouseId);
        }
        $allPurchases = $allPurchases->groupByRaw('date(orders.order_date)')
            ->orderByRaw("date(orders.order_date) asc")
            ->take(5)
            ->pluck('total_amount', 'date');

        $sales = Order::select(DB::raw('date(orders.order_date) as date, sum(orders.total) as total_amount'))
            ->where('orders.order_type', 'sales')
            ->whereRaw('DATE(orders.order_date) >= ?', [$startDate])
            ->whereRaw('DATE(orders.order_date) <= ?', [$endDate]);

        if ($warehouseId && $warehouseId != null) {
            $sales = $sales->where('orders.warehouse_id', $warehouseId);
        }
        $sales = $sales->groupByRaw('date(orders.order_date)')
            ->orderByRaw("date(orders.order_date) asc")
            ->take(5)
            ->pluck('total_amount', 'date');

        $periodDates = CarbonPeriod::create($startDate, $endDate);
        $datesArray = [];
        $purchasesArray = [];
        $salesArray = [];

        // Iterate over the period
        foreach ($periodDates as $periodDate) {
            $currentDate =  $periodDate->format('Y-m-d');

            if (isset($allPurchases[$currentDate]) || isset($sales[$currentDate])) {
                $datesArray[] = $currentDate;
                $purchasesArray[] = isset($allPurchases[$currentDate]) ? $allPurchases[$currentDate] : 0;
                $salesArray[] = isset($sales[$currentDate]) ? $sales[$currentDate] : 0;
            }
        }

        return [
            'dates' => $datesArray,
            'purchases' => $purchasesArray,
            'sales' => $salesArray,
        ];
    }

    public function changeThemeMode(Request $request)
    {
        $mode = $request->has('theme_mode') ? $request->theme_mode : 'light';

        session(['theme_mode' => $mode]);

        if ($mode == 'dark') {
            $company = company();
            if ($company) {
                $company->left_sidebar_theme = 'dark';
                $company->save();

                $updatedCompany = company(true);
            }
        }

        return ApiResponse::make('Success', [
            'status' => "success",
            'themeMode' => $mode,
            'themeModee' => session()->all(),
        ]);
    }

    public function changeAdminWarehouse(Request $request)
    {
        $user = user();

        $warehouse = $user->hasRole('admin') && $request->has('warehouse_id') && $request->warehouse_id
            ? Warehouse::find(Common::getIdFromHash($request->warehouse_id))
            : $user->warehouse;

        session(['warehouse' => $warehouse]);

        return ApiResponse::make('Success', [
            'status' => "success",
            'warehouse' => $warehouse
        ]);
    }

    public function getAllTimezones()
    {
        $timezones = \DateTimeZone::listIdentifiers(\DateTimeZone::ALL);

        return ApiResponse::make('Success', [
            'timezones' => $timezones,
            'date_formates' => [
                'd-m-Y' => 'DD-MM-YYYY',
                'm-d-Y' => 'MM-DD-YYYY',
                'Y-m-d' => 'YYYY-MM-DD',
                'd.m.Y' => 'DD.MM.YYYY',
                'm.d.Y' => 'MM.DD.YYYY',
                'Y.m.d' => 'YYYY.MM.DD',
                'd/m/Y' => 'DD/MM/YYYY',
                'm/d/Y' => 'MM/DD/YYYY',
                'Y/m/d' => 'YYYY/MM/DD',
                'd/M/Y' => 'DD/MMM/YYYY',
                'd.M.Y' => 'DD.MMM.YYYY',
                'd-M-Y' => 'DD-MMM-YYYY',
                'd M Y' => 'DD MMM YYYY',
                'd F, Y' => 'DD MMMM, YYYY',
                'D/M/Y' => 'ddd/MMM/YYYY',
                'D.M.Y' => 'ddd.MMM.YYYY',
                'D-M-Y' => 'ddd-MMM-YYYY',
                'D M Y' => 'ddd MMM YYYY',
                'd D M Y' => 'DD ddd MMM YYYY',
                'D d M Y' => 'ddd DD MMM YYYY',
                'dS M Y' => 'Do MMM YYYY',
            ],
            'time_formates' => [
                "hh:mm A" => '12 Hours hh:mm A',
                'hh:mm a' => '12 Hours hh:mm a',
                'hh:mm:ss A' => '12 Hours hh:mm:ss A',
                'hh:mm:ss a' => '12 Hours hh:mm:ss a',
                'HH:mm ' => '24 Hours HH:mm:ss',
                'HH:mm:ss' => '24 Hours hh:mm:ss',
            ]
        ]);
    }

    public function getDefaultWalkinCustomer()
    {
        $walkinCustomer = Customer::select('id', 'name')
            ->withoutGlobalScope(CompanyScope::class)
            ->where('is_walkin_customer', '=', 1)
            ->first();

        return ApiResponse::make('Data fetched', [
            'customer' => $walkinCustomer
        ]);
    }
}
