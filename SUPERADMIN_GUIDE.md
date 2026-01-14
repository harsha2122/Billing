# SuperAdmin Dashboard Guide

## Overview
The SuperAdmin dashboard provides complete control over all tenant companies in the SaaS billing system.

## Features

### 1. Dashboard (`/superadmin/dashboard`)
- **Statistics Cards**:
  - Total Companies
  - Active Companies
  - Total Users (across all companies)
  - Total Products
  - Total Orders
  - Total Sales Revenue

- **Recent Companies Table**:
  - Lists the 5 most recently created companies
  - Shows company name, email, admin, status, and creation date
  - Quick view link to company details

### 2. Companies Management (`/superadmin/companies`)

#### List View
- Searchable table of all companies
- Columns: Name, Email, Admin, Status, Created Date, Actions
- Pagination support (10 per page)
- Search by company name or email

#### Add New Company
Click "Add Company" button to open modal with:
- **Company Details**:
  - Company Name (required)
  - Short Name (optional)
  - Email (required, unique)
  - Phone (optional)
  - Address (optional)

- **Admin Details**:
  - Admin Name (required)
  - Admin Email (required, unique)
  - Admin Password (required, min 6 characters)

#### Edit Company
- Update company information
- Change company status (active/inactive/license_expired)
- Cannot edit admin details (for security)

#### View Company
Shows detailed information:
- Company details (name, email, phone, address, status)
- Admin information (name, email)
- Warehouse and currency
- **Statistics**:
  - Total users in company
  - Total products
  - Total orders

#### Delete Company
- Confirmation required
- Permanently deletes company and all associated data
- Cannot delete global companies

## Access Control

### Login
1. Navigate to `/admin/login`
2. Enter superadmin email and password
3. Automatically redirected to `/superadmin/dashboard`

### Security
- Only users with `is_superadmin = true` can access SuperAdmin routes
- Regular admins attempting to access SuperAdmin routes are redirected
- SuperAdmins attempting to access regular admin routes are redirected to dashboard
- All API endpoints require superadmin middleware authentication

## API Endpoints

### Dashboard
- `GET /api/superadmin/dashboard/stats` - Get dashboard statistics

### Companies
- `GET /api/superadmin/companies` - List all companies (with pagination & search)
- `POST /api/superadmin/companies` - Create new company
- `GET /api/superadmin/companies/{id}` - View company details
- `PUT /api/superadmin/companies/{id}` - Update company
- `DELETE /api/superadmin/companies/{id}` - Delete company

## Company Statuses
- **active** - Company is operational
- **inactive** - Company is temporarily disabled
- **license_expired** - Company license has expired

## Data Isolation
- Each company's data is completely isolated
- SuperAdmin can view all data across companies
- Regular admins can only access their own company data
- Database queries automatically filter by company_id using Laravel scopes

## Creating Companies

### Via UI
1. Login as SuperAdmin
2. Go to Companies → Add Company
3. Fill in company and admin details
4. Submit

The system automatically:
- Creates the company
- Creates a warehouse for the company
- Adds default currencies (USD, INR)
- Creates admin role
- Creates admin user
- Sets up initial settings
- Creates walk-in customer

### Via CLI
```bash
php artisan admin:create "Company Name" admin@email.com Password123 --name="Admin Name"
```

## Tips
- Use search to quickly find companies
- Monitor active vs inactive companies on dashboard
- Check company stats before deletion
- Set companies to inactive instead of deleting to preserve data
- Use strong passwords for admin accounts
- Regularly review total sales and order metrics

## Troubleshooting

### Cannot access SuperAdmin routes
- Ensure user has `is_superadmin = 1` in database
- Clear browser cache and cookies
- Logout and login again

### Companies not showing
- Check database connection
- Verify migrations ran successfully
- Check browser console for errors

### Cannot create company
- Ensure email addresses are unique
- Check all required fields are filled
- Verify password is at least 6 characters
- Check API endpoint permissions

## Technical Details

### Frontend Structure
```
resources/js/superadmin/
├── router/
│   ├── index.js          # SuperAdmin routes
│   └── admin/index.js    # Subscription routes
└── views/
    ├── dashboard/
    │   └── index.vue     # Dashboard component
    └── companies/
        └── index.vue     # Companies management
```

### Backend Structure
```
app/Http/Controllers/Api/SuperAdmin/
├── CompaniesController.php   # Company CRUD operations
└── DashboardController.php   # Dashboard statistics

app/Http/Requests/Api/SuperAdmin/Company/
├── IndexRequest.php
├── StoreRequest.php
├── UpdateRequest.php
└── DeleteRequest.php
```

### Routes
```
routes/superadmin.php
```

### Middleware
```
app/Http/Middleware/ApiSuperAdminMiddleware.php
```

## Next Steps
- Build subscription plan management
- Add company analytics and reporting
- Implement bulk operations
- Add email notifications
- Create audit logs for SuperAdmin actions
