-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 31, 2025 at 02:57 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `laravel`
--

-- --------------------------------------------------------

--
-- Table structure for table `brands`
--

CREATE TABLE `brands` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `admin_id`, `company_id`, `name`, `slug`, `image`, `parent_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'Any', 'any', 'category_jmnxe98veqhma8wog2u8.png', NULL, '2025-11-11 10:58:30', '2025-11-11 10:58:30');

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

CREATE TABLE `companies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `short_name` varchar(191) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `phone` varchar(191) DEFAULT NULL,
  `website` varchar(191) DEFAULT NULL,
  `light_logo` varchar(191) DEFAULT NULL,
  `dark_logo` varchar(191) DEFAULT NULL,
  `small_dark_logo` varchar(191) DEFAULT NULL,
  `small_light_logo` varchar(191) DEFAULT NULL,
  `address` varchar(1000) DEFAULT NULL,
  `app_layout` varchar(10) NOT NULL DEFAULT 'sidebar',
  `rtl` tinyint(1) NOT NULL DEFAULT 0,
  `mysqldump_command` varchar(191) NOT NULL DEFAULT '/usr/bin/mysqldump',
  `shortcut_menus` varchar(20) NOT NULL DEFAULT 'top_bottom',
  `currency_id` bigint(20) UNSIGNED DEFAULT NULL,
  `lang_id` bigint(20) UNSIGNED DEFAULT NULL,
  `warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `left_sidebar_theme` varchar(20) NOT NULL DEFAULT 'dark',
  `primary_color` varchar(20) NOT NULL DEFAULT '#1890ff',
  `date_format` varchar(20) NOT NULL DEFAULT 'DD-MM-YYYY',
  `time_format` varchar(20) NOT NULL DEFAULT 'hh:mm a',
  `auto_detect_timezone` tinyint(1) NOT NULL DEFAULT 1,
  `timezone` varchar(191) NOT NULL DEFAULT 'Asia/Kolkata',
  `session_driver` varchar(20) NOT NULL DEFAULT 'file',
  `app_debug` tinyint(1) NOT NULL DEFAULT 0,
  `update_app_notification` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `login_image` varchar(191) DEFAULT NULL,
  `stripe_id` varchar(191) DEFAULT NULL,
  `card_brand` varchar(191) DEFAULT NULL,
  `card_last_four` varchar(4) DEFAULT NULL,
  `trial_ends_at` timestamp NULL DEFAULT NULL,
  `subscription_plan_id` bigint(20) UNSIGNED DEFAULT NULL,
  `package_type` enum('monthly','annual') NOT NULL DEFAULT 'monthly',
  `licence_expire_on` date DEFAULT NULL,
  `is_global` tinyint(1) NOT NULL DEFAULT 0,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'active',
  `total_users` int(11) NOT NULL DEFAULT 1,
  `email_verification_code` varchar(191) DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`id`, `name`, `short_name`, `email`, `phone`, `website`, `light_logo`, `dark_logo`, `small_dark_logo`, `small_light_logo`, `address`, `app_layout`, `rtl`, `mysqldump_command`, `shortcut_menus`, `currency_id`, `lang_id`, `warehouse_id`, `left_sidebar_theme`, `primary_color`, `date_format`, `time_format`, `auto_detect_timezone`, `timezone`, `session_driver`, `app_debug`, `update_app_notification`, `created_at`, `updated_at`, `login_image`, `stripe_id`, `card_brand`, `card_last_four`, `trial_ends_at`, `subscription_plan_id`, `package_type`, `licence_expire_on`, `is_global`, `admin_id`, `status`, `total_users`, `email_verification_code`, `verified`) VALUES
(1, 'Growbiz', 'Growbiz', 'company@growbiz.com', '8840200147', NULL, 'company_1tymi8rbn5k98pvsydpw.png', 'company_4edvgnlaj5m7hvlbi4dz.png', 'company_thgighh42j1saeabkszl.png', 'company_zijdj5eiujesilvg8nhj.png', '7 street, city, state, 762782', 'sidebar', 0, '/usr/bin/mysqldump', 'top_bottom', 1, 1, 1, 'dark', '#1890ff', 'DD-MM-YYYY', 'hh:mm a', 1, 'Asia/Kolkata', 'file', 0, 1, NULL, '2025-11-11 10:57:08', 'company_5g5octagoscbhat08egv.png', NULL, NULL, NULL, NULL, NULL, 'monthly', NULL, 0, 1, 'active', 1, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `currencies`
--

CREATE TABLE `currencies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `code` varchar(191) NOT NULL,
  `symbol` varchar(191) NOT NULL,
  `position` varchar(191) NOT NULL,
  `is_deletable` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `currencies`
--

INSERT INTO `currencies` (`id`, `company_id`, `name`, `code`, `symbol`, `position`, `is_deletable`, `created_at`, `updated_at`) VALUES
(1, 1, 'INR', 'ISO 4217', '₹', 'front', 1, '2025-11-11 10:56:00', '2025-11-11 10:56:00');

-- --------------------------------------------------------

--
-- Table structure for table `custom_fields`
--

CREATE TABLE `custom_fields` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `value` varchar(191) DEFAULT NULL,
  `type` varchar(191) NOT NULL DEFAULT 'text',
  `active` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `bill` varchar(191) DEFAULT NULL,
  `expense_category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `amount` double(8,2) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `notes` varchar(1000) DEFAULT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `expense_categories`
--

CREATE TABLE `expense_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(191) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `front_product_cards`
--

CREATE TABLE `front_product_cards` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(191) NOT NULL,
  `subtitle` varchar(191) DEFAULT NULL,
  `products` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `front_website_settings`
--

CREATE TABLE `front_website_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `featured_categories` text NOT NULL,
  `featured_categories_title` varchar(191) DEFAULT 'Featured Categories',
  `featured_categories_subtitle` varchar(191) DEFAULT '',
  `featured_products` text NOT NULL,
  `featured_products_title` varchar(191) DEFAULT 'Featured Products',
  `featured_products_subtitle` varchar(191) DEFAULT '',
  `features_lists` text NOT NULL,
  `facebook_url` varchar(191) DEFAULT '',
  `twitter_url` varchar(191) DEFAULT '',
  `instagram_url` varchar(191) DEFAULT '',
  `linkedin_url` varchar(191) DEFAULT '',
  `youtube_url` varchar(191) DEFAULT '',
  `pages_widget` text NOT NULL,
  `contact_info_widget` text NOT NULL,
  `links_widget` text NOT NULL,
  `footer_company_description` varchar(1000) NOT NULL DEFAULT 'Stockify have many propular products wiht high discount and special offers.',
  `footer_copyright_text` varchar(1000) NOT NULL DEFAULT 'Copyright 2021 @ Stockify, All rights reserved.',
  `top_banners` text NOT NULL,
  `bottom_banners_1` text NOT NULL,
  `bottom_banners_2` text NOT NULL,
  `bottom_banners_3` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `front_website_settings`
--

INSERT INTO `front_website_settings` (`id`, `company_id`, `warehouse_id`, `featured_categories`, `featured_categories_title`, `featured_categories_subtitle`, `featured_products`, `featured_products_title`, `featured_products_subtitle`, `features_lists`, `facebook_url`, `twitter_url`, `instagram_url`, `linkedin_url`, `youtube_url`, `pages_widget`, `contact_info_widget`, `links_widget`, `footer_company_description`, `footer_copyright_text`, `top_banners`, `bottom_banners_1`, `bottom_banners_2`, `bottom_banners_3`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '[]', 'Featured Categories', '', '[]', 'Featured Products', '', '[]', '', '', '', '', '', '[]', '[]', '[]', 'Stockify have many propular products wiht high discount and special offers.', 'Copyright 2021 @ Stockify, All rights reserved.', '[]', '[]', '[]', '[]', '2025-11-11 10:55:19', '2025-11-11 10:55:19'),
(2, 1, 1, '[]', 'Featured Categories', '', '[]', 'Featured Products', '', '[]', '', '', '', '', '', '[]', '[]', '[]', 'Stockify have many propular products wiht high discount and special offers.', 'Copyright 2021 @ Stockify, All rights reserved.', '[]', '[]', '[]', '[]', '2025-11-11 10:55:19', '2025-11-11 10:55:19');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(191) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `langs`
--

CREATE TABLE `langs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `key` varchar(191) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `langs`
--

INSERT INTO `langs` (`id`, `image`, `name`, `key`, `enabled`, `created_at`, `updated_at`) VALUES
(1, NULL, 'English', 'en', 1, '2025-11-11 09:07:59', '2025-11-11 09:07:59');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(41, '2019_08_19_000000_create_failed_jobs_table', 1),
(42, '2021_01_02_193004_create_langs_table', 1),
(43, '2021_01_02_193005_create_translations_table', 1),
(44, '2021_02_01_040700_create_payment_modes_table', 1),
(45, '2021_03_01_040700_create_currencies_table', 1),
(46, '2021_03_02_130932_create_warehouses_table', 1),
(47, '2021_03_03_114417_create_companies_table', 1),
(48, '2021_04_04_000000_create_users_table', 1),
(49, '2021_04_05_190756_entrust_setup_tables', 1),
(50, '2021_05_06_151454_create_brands_table', 1),
(51, '2021_05_06_162224_create_categories_table', 1),
(52, '2021_05_07_033806_create_taxes_table', 1),
(53, '2021_05_07_033823_create_units_table', 1),
(54, '2021_05_08_052842_create_expense_categories_table', 1),
(55, '2021_05_08_052858_create_expenses_table', 1),
(56, '2021_05_08_144116_custom_fields_table', 1),
(57, '2021_05_09_153334_create_products_table', 1),
(58, '2021_05_13_072501_create_orders_table', 1),
(59, '2021_05_13_072518_create_order_items_table', 1),
(60, '2021_05_23_060918_create_payments_table', 1),
(61, '2021_05_23_060919_create_order_payments_table', 1),
(62, '2021_05_28_120405_create_warehouse_stocks_table', 1),
(63, '2021_10_10_100006_create_stock_history_table', 1),
(64, '2022_01_10_115820_create_stock_adjustments_table', 1),
(65, '2022_02_01_094402_create_settings_table', 1),
(66, '2022_02_24_075933_create_notifications_table', 1),
(67, '2022_02_24_122754_create_jobs_table', 1),
(68, '2022_03_07_110707_create_warehouse_history_table', 1),
(69, '2022_04_11_105713_add_login_image_column_in_companies_table', 1),
(70, '2022_04_14_141740_create_order_shipping_address_table', 1),
(71, '2022_04_15_141741_create_user_address_table', 1),
(72, '2022_04_16_054851_create_front_product_cards_table', 1),
(73, '2022_04_17_092949_create_front_website_settings_table', 1),
(74, '2022_04_30_044824_add_rtl_in_companies_warehouses_table', 1),
(75, '2022_05_05_044824_add_setting_records_in_settings_table', 1),
(76, '2022_05_22_004926_add_from_warehouse_id_column_in_orders_table', 1),
(77, '2022_06_24_094848_add_staff_user_id_in_payments_warehouse_history_table', 1),
(78, '2022_10_06_152352_create_company_id_columns_in_all_tables', 1),
(79, '2022_11_22_130234_add_tax_number_in_users_table', 1),
(80, '2022_12_09_065955_add_created_by_column_in_users_table', 1),
(81, '2025_12_30_184801_update_tables_for_multi_user_system', 2);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `type` varchar(191) NOT NULL,
  `notifiable_type` varchar(191) NOT NULL,
  `notifiable_id` bigint(20) UNSIGNED NOT NULL,
  `data` text NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at`) VALUES
('ff448400-522d-43cf-87ca-5a1b179d9739', 'App\\Notifications\\MainNotificaiton', 'App\\Models\\Warehouse', 1, '{\"send_for\":\"stock_adjustment_create\",\"to\":{\"company_id\":1,\"logo\":\"warehouses_9upwilrpnz76f7okqcut.png\",\"dark_logo\":\"warehouses_eqsndekawoys3lgqru4f.png\",\"name\":\"Tanmay\",\"slug\":\"tanmay\",\"email\":\"tanmay@gmail.com\",\"phone\":\"8840200147\",\"show_email_on_invoice\":1,\"show_phone_on_invoice\":1,\"address\":\"Sainagar Mamurdi\",\"terms_condition\":\"1. Goods once sold will not be taken back or exchanged\\n2. All disputes are subject to [ENTER_YOUR_CITY_NAME] jurisdiction only\",\"bank_details\":null,\"signature\":\"warehouses_iozlxdkcf0liot9jdkek.png\",\"online_store_enabled\":1,\"customers_visibility\":\"all\",\"suppliers_visibility\":\"all\",\"products_visibility\":\"all\",\"default_pos_order_status\":\"delivered\",\"created_at\":\"2025-11-11T16:25:19+00:00\",\"updated_at\":\"2025-11-11T16:25:19+00:00\",\"xid\":\"AdWNDqgV\",\"logo_url\":\"http:\\/\\/127.0.0.1:8000\\/uploads\\/warehouses\\/warehouses_9upwilrpnz76f7okqcut.png\",\"dark_logo_url\":\"http:\\/\\/127.0.0.1:8000\\/uploads\\/warehouses\\/warehouses_eqsndekawoys3lgqru4f.png\",\"signature_url\":\"http:\\/\\/127.0.0.1:8000\\/uploads\\/warehouses\\/warehouses_iozlxdkcf0liot9jdkek.png\"},\"mail\":{\"setting\":{\"is_global\":0,\"company_id\":1,\"setting_type\":\"email\",\"name\":\"SMTP\",\"name_key\":\"smtp\",\"credentials\":{\"from_name\":\"\",\"from_email\":\"\",\"host\":\"\",\"port\":\"\",\"encryption\":\"\",\"username\":\"\",\"password\":\"\"},\"other_data\":null,\"status\":0,\"verified\":0,\"xid\":\"7ZWDkbpO\"},\"isAbleToSend\":false,\"content\":\"\",\"title\":\"\"},\"data\":{\"to\":{\"company_id\":1,\"logo\":\"warehouses_9upwilrpnz76f7okqcut.png\",\"dark_logo\":\"warehouses_eqsndekawoys3lgqru4f.png\",\"name\":\"Tanmay\",\"slug\":\"tanmay\",\"email\":\"tanmay@gmail.com\",\"phone\":\"8840200147\",\"show_email_on_invoice\":1,\"show_phone_on_invoice\":1,\"address\":\"Sainagar Mamurdi\",\"terms_condition\":\"1. Goods once sold will not be taken back or exchanged\\n2. All disputes are subject to [ENTER_YOUR_CITY_NAME] jurisdiction only\",\"bank_details\":null,\"signature\":\"warehouses_iozlxdkcf0liot9jdkek.png\",\"online_store_enabled\":1,\"customers_visibility\":\"all\",\"suppliers_visibility\":\"all\",\"products_visibility\":\"all\",\"default_pos_order_status\":\"delivered\",\"created_at\":\"2025-11-11T16:25:19+00:00\",\"updated_at\":\"2025-11-11T16:25:19+00:00\",\"xid\":\"AdWNDqgV\",\"logo_url\":\"http:\\/\\/127.0.0.1:8000\\/uploads\\/warehouses\\/warehouses_9upwilrpnz76f7okqcut.png\",\"dark_logo_url\":\"http:\\/\\/127.0.0.1:8000\\/uploads\\/warehouses\\/warehouses_eqsndekawoys3lgqru4f.png\",\"signature_url\":\"http:\\/\\/127.0.0.1:8000\\/uploads\\/warehouses\\/warehouses_iozlxdkcf0liot9jdkek.png\"},\"product\":{\"company_id\":1,\"warehouse_id\":1,\"name\":\"Growbiz\",\"slug\":\"growbiz\",\"barcode_symbology\":\"CODE128\",\"item_code\":\"ITEM001\",\"image\":\"product_c2duurhxt0isrv5uefyz.png\",\"description\":\"Anything\",\"created_at\":\"2025-11-11T16:29:39+00:00\",\"updated_at\":\"2025-11-11T16:29:39+00:00\",\"xid\":\"AdWNDqgV\",\"x_category_id\":\"AdWNDqgV\",\"x_brand_id\":null,\"x_unit_id\":\"AdWNDqgV\",\"x_user_id\":\"AdWNDqgV\",\"image_url\":\"http:\\/\\/127.0.0.1:8000\\/uploads\\/products\\/product_c2duurhxt0isrv5uefyz.png\"},\"warehouse\":{\"company_id\":1,\"logo\":\"warehouses_9upwilrpnz76f7okqcut.png\",\"dark_logo\":\"warehouses_eqsndekawoys3lgqru4f.png\",\"name\":\"Tanmay\",\"slug\":\"tanmay\",\"email\":\"tanmay@gmail.com\",\"phone\":\"8840200147\",\"show_email_on_invoice\":1,\"show_phone_on_invoice\":1,\"address\":\"Sainagar Mamurdi\",\"terms_condition\":\"1. Goods once sold will not be taken back or exchanged\\n2. All disputes are subject to [ENTER_YOUR_CITY_NAME] jurisdiction only\",\"bank_details\":null,\"signature\":\"warehouses_iozlxdkcf0liot9jdkek.png\",\"online_store_enabled\":1,\"customers_visibility\":\"all\",\"suppliers_visibility\":\"all\",\"products_visibility\":\"all\",\"default_pos_order_status\":\"delivered\",\"created_at\":\"2025-11-11T16:25:19+00:00\",\"updated_at\":\"2025-11-11T16:25:19+00:00\",\"xid\":\"AdWNDqgV\",\"logo_url\":\"http:\\/\\/127.0.0.1:8000\\/uploads\\/warehouses\\/warehouses_9upwilrpnz76f7okqcut.png\",\"dark_logo_url\":\"http:\\/\\/127.0.0.1:8000\\/uploads\\/warehouses\\/warehouses_eqsndekawoys3lgqru4f.png\",\"signature_url\":\"http:\\/\\/127.0.0.1:8000\\/uploads\\/warehouses\\/warehouses_iozlxdkcf0liot9jdkek.png\"},\"stock_adjustment\":{\"quantity\":100,\"notes\":\"neew\",\"adjustment_type\":\"add\",\"company_id\":1,\"updated_at\":\"2025-11-11T16:32:45+00:00\",\"created_at\":\"2025-11-11T16:32:45+00:00\",\"xid\":\"AdWNDqgV\",\"x_warehouse_id\":\"AdWNDqgV\",\"x_product_id\":\"AdWNDqgV\",\"x_created_by\":\"AdWNDqgV\"},\"staff_member\":{\"company_id\":1,\"is_superadmin\":0,\"lang_id\":1,\"user_type\":\"staff_members\",\"is_walkin_customer\":0,\"login_enabled\":1,\"name\":\"Admin\",\"email\":\"admin@example.com\",\"phone\":null,\"profile_image\":null,\"address\":null,\"shipping_address\":null,\"email_verification_code\":null,\"status\":\"enabled\",\"reset_code\":null,\"timezone\":\"Asia\\/Kolkata\",\"date_format\":\"d-m-Y\",\"date_picker_format\":\"dd-mm-yyyy\",\"time_format\":\"h:i a\",\"tax_number\":null,\"created_by\":null,\"created_at\":null,\"updated_at\":\"2025-11-11T16:27:08+00:00\",\"xid\":\"AdWNDqgV\",\"x_role_id\":\"AdWNDqgV\",\"profile_image_url\":\"http:\\/\\/127.0.0.1:8000\\/images\\/user.png\"}}}', NULL, '2025-11-11 11:02:49', '2025-11-11 11:02:49');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `unique_id` varchar(20) NOT NULL,
  `invoice_number` varchar(20) NOT NULL,
  `invoice_type` varchar(20) DEFAULT NULL,
  `order_type` varchar(20) NOT NULL DEFAULT 'sales',
  `order_date` datetime NOT NULL,
  `warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `from_warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `tax_id` bigint(20) UNSIGNED DEFAULT NULL,
  `tax_rate` double(8,2) DEFAULT NULL,
  `tax_amount` double NOT NULL DEFAULT 0,
  `discount` double DEFAULT NULL,
  `shipping` double DEFAULT NULL,
  `subtotal` double NOT NULL,
  `total` double NOT NULL,
  `paid_amount` double NOT NULL DEFAULT 0,
  `due_amount` double NOT NULL DEFAULT 0,
  `order_status` varchar(20) NOT NULL,
  `notes` text DEFAULT NULL,
  `document` varchar(191) DEFAULT NULL,
  `staff_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_status` varchar(20) NOT NULL DEFAULT 'unpaid',
  `total_items` double(8,2) NOT NULL DEFAULT 0.00,
  `total_quantity` double(8,2) NOT NULL DEFAULT 0.00,
  `terms_condition` text DEFAULT NULL,
  `is_deletable` tinyint(1) NOT NULL DEFAULT 1,
  `cancelled` tinyint(1) NOT NULL DEFAULT 0,
  `cancelled_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `admin_id`, `company_id`, `unique_id`, `invoice_number`, `invoice_type`, `order_type`, `order_date`, `warehouse_id`, `from_warehouse_id`, `user_id`, `tax_id`, `tax_rate`, `tax_amount`, `discount`, `shipping`, `subtotal`, `total`, `paid_amount`, `due_amount`, `order_status`, `notes`, `document`, `staff_user_id`, `payment_status`, `total_items`, `total_quantity`, `terms_condition`, `is_deletable`, `cancelled`, `cancelled_by`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'atC32RWzwGBe0hvES1H6', 'SALE-1', 'pos', 'sales', '2025-11-11 16:30:26', 1, NULL, 2, 1, 18.00, 50.4, 0, 0, 280, 330.4, 330.4, 0, 'delivered', NULL, NULL, 1, 'paid', 1.00, 1.00, NULL, 1, 0, NULL, '2025-11-11 11:00:26', '2025-11-11 11:00:27'),
(2, 1, 1, 'gnzXKeV47TVzHQq4swV5', 'SALE-2', 'pos', 'sales', '2025-11-11 16:35:30', 1, NULL, 2, NULL, 0.00, 0, 100, 20, 280, 200, 200, 0, 'delivered', NULL, NULL, 1, 'paid', 1.00, 1.00, NULL, 1, 0, NULL, '2025-11-11 11:05:30', '2025-11-11 11:05:30');

-- --------------------------------------------------------

--
-- Table structure for table `order_custom_fields`
--

CREATE TABLE `order_custom_fields` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `field_name` varchar(191) NOT NULL,
  `field_value` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `unit_id` bigint(20) UNSIGNED DEFAULT NULL,
  `quantity` double(8,2) NOT NULL,
  `unit_price` double NOT NULL,
  `single_unit_price` double NOT NULL,
  `tax_id` bigint(20) UNSIGNED DEFAULT NULL,
  `tax_rate` double(8,2) NOT NULL DEFAULT 0.00,
  `tax_type` varchar(10) DEFAULT NULL,
  `discount_rate` double(8,2) DEFAULT NULL,
  `total_tax` double DEFAULT NULL,
  `total_discount` double DEFAULT NULL,
  `subtotal` double NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `user_id`, `order_id`, `product_id`, `unit_id`, `quantity`, `unit_price`, `single_unit_price`, `tax_id`, `tax_rate`, `tax_type`, `discount_rate`, `total_tax`, `total_discount`, `subtotal`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 1, 1, 1.00, 280, 237.28813559322, 1, 18.00, 'inclusive', 0.00, 42.71186440678, 0, 280, '2025-11-11 11:00:26', '2025-11-11 11:00:26'),
(2, 2, 2, 1, 1, 1.00, 280, 237.28813559322, 1, 18.00, 'inclusive', 0.00, 42.71186440678, 0, 280, '2025-11-11 11:05:30', '2025-11-11 11:05:30');

-- --------------------------------------------------------

--
-- Table structure for table `order_payments`
--

CREATE TABLE `order_payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED DEFAULT NULL,
  `amount` double NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_payments`
--

INSERT INTO `order_payments` (`id`, `admin_id`, `company_id`, `payment_id`, `order_id`, `amount`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 1, 330.4, '2025-11-11 11:00:27', '2025-11-11 11:00:27'),
(2, 1, 1, 2, 2, 200, '2025-11-11 11:05:30', '2025-11-11 11:05:30');

-- --------------------------------------------------------

--
-- Table structure for table `order_shipping_address`
--

CREATE TABLE `order_shipping_address` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `address` varchar(1000) DEFAULT NULL,
  `shipping_address` varchar(1000) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `zipcode` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_type` varchar(20) NOT NULL DEFAULT 'out',
  `payment_number` varchar(191) DEFAULT NULL,
  `date` date NOT NULL,
  `amount` double NOT NULL DEFAULT 0,
  `unused_amount` double NOT NULL DEFAULT 0,
  `paid_amount` double NOT NULL DEFAULT 0,
  `payment_mode_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_receipt` varchar(191) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `staff_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `admin_id`, `company_id`, `warehouse_id`, `payment_type`, `payment_number`, `date`, `amount`, `unused_amount`, `paid_amount`, `payment_mode_id`, `user_id`, `payment_receipt`, `notes`, `staff_user_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 'in', 'PAY-IN-1', '2025-11-11', 330.4, 0, 330.4, 1, 2, NULL, 'Done', NULL, '2025-11-11 11:00:27', '2025-11-11 11:00:27'),
(2, 1, 1, 1, 'in', 'PAY-IN-2', '2025-11-11', 200, 0, 200, 1, 2, NULL, NULL, NULL, '2025-11-11 11:05:30', '2025-11-11 11:05:30');

-- --------------------------------------------------------

--
-- Table structure for table `payment_modes`
--

CREATE TABLE `payment_modes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `mode_type` varchar(191) DEFAULT 'bank',
  `credentials` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment_modes`
--

INSERT INTO `payment_modes` (`id`, `company_id`, `name`, `mode_type`, `credentials`, `created_at`, `updated_at`) VALUES
(1, 1, 'Cash', 'cash', NULL, '2025-11-11 10:56:13', '2025-11-11 10:56:13');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `display_name` varchar(191) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `module_name` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `display_name`, `description`, `module_name`, `created_at`, `updated_at`) VALUES
(1, 'brands_view', 'Brand View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(2, 'brands_create', 'Brand Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(3, 'brands_edit', 'Brand Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(4, 'brands_delete', 'Brand Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(5, 'categories_view', 'Category View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(6, 'categories_create', 'Category Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(7, 'categories_edit', 'Category Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(8, 'categories_delete', 'Category Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(9, 'products_view', 'Product View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(10, 'products_create', 'Product Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(11, 'products_edit', 'Product Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(12, 'products_delete', 'Product Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(13, 'purchases_view', 'Purchase View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(14, 'purchases_create', 'Purchase Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(15, 'purchases_edit', 'Purchase Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(16, 'purchases_delete', 'Purchase Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(17, 'purchase_returns_view', 'Purchase Return View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(18, 'purchase_returns_create', 'Purchase Return Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(19, 'purchase_returns_edit', 'Purchase Return Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(20, 'purchase_returns_delete', 'Purchase Return Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(21, 'payment_out_view', 'Payment Out View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(22, 'payment_out_create', 'Payment Out Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(23, 'payment_out_edit', 'Payment Out Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(24, 'payment_out_delete', 'Payment Out Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(25, 'payment_in_view', 'Payment In View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(26, 'payment_in_create', 'Payment In Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(27, 'payment_in_edit', 'Payment In Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(28, 'payment_in_delete', 'Payment In Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(29, 'sales_view', 'Sales View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(30, 'sales_create', 'Sales Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(31, 'sales_edit', 'Sales Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(32, 'sales_delete', 'Sales Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(33, 'sales_returns_view', 'Sales Return View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(34, 'sales_returns_create', 'Sales Return Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(35, 'sales_returns_edit', 'Sales Return Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(36, 'sales_returns_delete', 'Sales Return Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(37, 'order_payments_view', 'Order Payments View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(38, 'order_payments_create', 'Order Payments Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(39, 'stock_adjustments_view', 'Stock Adjustment View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(40, 'stock_adjustments_create', 'Stock Adjustment Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(41, 'stock_adjustments_edit', 'Stock Adjustment Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(42, 'stock_adjustments_delete', 'Stock Adjustment Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(43, 'stock_transfers_view', 'Stock Transfer View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(44, 'stock_transfers_create', 'Stock Transfer Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(45, 'stock_transfers_edit', 'Stock Transfer Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(46, 'stock_transfers_delete', 'Stock Transfer Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(47, 'expense_categories_view', 'Expense Category View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(48, 'expense_categories_create', 'Expense Category Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(49, 'expense_categories_edit', 'Expense Category Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(50, 'expense_categories_delete', 'Expense Category Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(51, 'expenses_view', 'Expense View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(52, 'expenses_create', 'Expense Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(53, 'expenses_edit', 'Expense Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(54, 'expenses_delete', 'Expense Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(55, 'units_view', 'Unit View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(56, 'units_create', 'Unit Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(57, 'units_edit', 'Unit Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(58, 'units_delete', 'Unit Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(59, 'custom_fields_view', 'Custom Field View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(60, 'custom_fields_create', 'Custom Field Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(61, 'custom_fields_edit', 'Custom Field Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(62, 'custom_fields_delete', 'Custom Field Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(63, 'payment_modes_view', 'Payment Mode View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(64, 'payment_modes_create', 'Payment Mode Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(65, 'payment_modes_edit', 'Payment Mode Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(66, 'payment_modes_delete', 'Payment Mode Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(67, 'currencies_view', 'Currency View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(68, 'currencies_create', 'Currency Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(69, 'currencies_edit', 'Currency Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(70, 'currencies_delete', 'Currency Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(71, 'taxes_view', 'Tax View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(72, 'taxes_create', 'Tax Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(73, 'taxes_edit', 'Tax Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(74, 'taxes_delete', 'Tax Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(75, 'modules_view', 'Modules View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(76, 'roles_view', 'Role View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(77, 'roles_create', 'Role Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(78, 'roles_edit', 'Role Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(79, 'roles_delete', 'Role Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(80, 'warehouses_view', 'Warehouse View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(81, 'warehouses_create', 'Warehouse Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(82, 'warehouses_edit', 'Warehouse Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(83, 'warehouses_delete', 'Warehouse Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(84, 'companies_edit', 'Company Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(85, 'translations_view', 'Translation View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(86, 'translations_create', 'Translation Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(87, 'translations_edit', 'Translation Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(88, 'translations_delete', 'Translation Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(89, 'users_view', 'Staff Member View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(90, 'users_create', 'Staff Member Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(91, 'users_edit', 'Staff Member Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(92, 'users_delete', 'Staff Member Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(93, 'customers_view', 'Customer View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(94, 'customers_create', 'Customer Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(95, 'customers_edit', 'Customer Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(96, 'customers_delete', 'Customer Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(97, 'suppliers_view', 'Supplier View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(98, 'suppliers_create', 'Supplier Create', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(99, 'suppliers_edit', 'Supplier Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(100, 'suppliers_delete', 'Supplier Delete', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(101, 'storage_edit', 'Storage Settings Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(102, 'email_edit', 'Email Settings Edit', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(103, 'pos_view', 'POS View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(104, 'update_app', 'Update App', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02'),
(105, 'cash_bank_view', 'Cash & Bank View', NULL, NULL, '2025-11-11 09:08:02', '2025-11-11 09:08:02');

-- --------------------------------------------------------

--
-- Table structure for table `permission_role`
--

CREATE TABLE `permission_role` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(1000) NOT NULL,
  `slug` varchar(1000) NOT NULL,
  `barcode_symbology` varchar(10) NOT NULL,
  `item_code` varchar(191) NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `brand_id` bigint(20) UNSIGNED DEFAULT NULL,
  `unit_id` bigint(20) UNSIGNED DEFAULT NULL,
  `description` text DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `admin_id`, `company_id`, `warehouse_id`, `name`, `slug`, `barcode_symbology`, `item_code`, `image`, `category_id`, `brand_id`, `unit_id`, `description`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 'Growbiz', 'growbiz', 'CODE128', 'ITEM001', 'product_c2duurhxt0isrv5uefyz.png', 1, NULL, 1, 'Anything', 1, '2025-11-11 10:59:39', '2025-11-11 10:59:39');

-- --------------------------------------------------------

--
-- Table structure for table `product_custom_fields`
--

CREATE TABLE `product_custom_fields` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `field_name` varchar(191) NOT NULL,
  `field_value` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_details`
--

CREATE TABLE `product_details` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `current_stock` double(8,2) NOT NULL DEFAULT 0.00,
  `mrp` double DEFAULT NULL,
  `purchase_price` double NOT NULL,
  `sales_price` double NOT NULL,
  `tax_id` bigint(20) UNSIGNED DEFAULT NULL,
  `purchase_tax_type` varchar(10) DEFAULT 'exclusive',
  `sales_tax_type` varchar(10) DEFAULT 'exclusive',
  `stock_quantitiy_alert` int(11) DEFAULT NULL,
  `opening_stock` int(11) DEFAULT NULL,
  `opening_stock_date` date DEFAULT NULL,
  `wholesale_price` double DEFAULT NULL,
  `wholesale_quantity` int(11) DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'in_stock',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_details`
--

INSERT INTO `product_details` (`id`, `product_id`, `warehouse_id`, `current_stock`, `mrp`, `purchase_price`, `sales_price`, `tax_id`, `purchase_tax_type`, `sales_tax_type`, `stock_quantitiy_alert`, `opening_stock`, `opening_stock_date`, `wholesale_price`, `wholesale_quantity`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 198.00, 280, 200, 280, 1, 'exclusive', 'inclusive', 2, 100, '2025-11-03', NULL, NULL, 'in_stock', '2025-11-11 10:59:39', '2025-11-11 11:05:30');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `display_name` varchar(191) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `company_id`, `name`, `display_name`, `description`, `created_at`, `updated_at`) VALUES
(1, 1, 'admin', 'Admin', 'Admin is allowed to manage everything of the app.', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `role_user`
--

CREATE TABLE `role_user` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_user`
--

INSERT INTO `role_user` (`user_id`, `role_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `is_global` tinyint(1) NOT NULL DEFAULT 0,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `setting_type` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `name_key` varchar(191) NOT NULL,
  `credentials` text DEFAULT NULL,
  `other_data` text DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `is_global`, `company_id`, `setting_type`, `name`, `name_key`, `credentials`, `other_data`, `status`, `verified`, `created_at`, `updated_at`) VALUES
(1, 0, 1, 'storage', 'Local', 'local', '[]', NULL, 1, 0, NULL, NULL),
(2, 0, 1, 'storage', 'AWS', 'aws', '{\"driver\":\"s3\",\"key\":\"\",\"secret\":\"\",\"region\":\"\",\"bucket\":\"\"}', NULL, 0, 0, NULL, NULL),
(3, 0, 1, 'email', 'SMTP', 'smtp', '{\"from_name\":\"\",\"from_email\":\"\",\"host\":\"\",\"port\":\"\",\"encryption\":\"\",\"username\":\"\",\"password\":\"\"}', NULL, 0, 0, NULL, NULL),
(4, 0, 1, 'send_mail_settings', 'Send mail to warehouse', 'warehouse', '[]', NULL, 0, 0, NULL, NULL),
(5, 0, 1, 'shortcut_menus', 'Add Menu', 'shortcut_menus', '[\"staff_member\",\"customer\",\"supplier\",\"brand\",\"category\",\"product\",\"purchase\",\"sales\",\"expense_category\",\"expense\",\"warehouse\",\"currency\",\"unit\",\"language\",\"role\",\"tax\",\"payment_mode\"]', NULL, 1, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `stock_adjustments`
--

CREATE TABLE `stock_adjustments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `warehouse_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` double(8,2) NOT NULL,
  `adjustment_type` varchar(20) NOT NULL DEFAULT 'add',
  `notes` text DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stock_adjustments`
--

INSERT INTO `stock_adjustments` (`id`, `admin_id`, `company_id`, `warehouse_id`, `product_id`, `quantity`, `adjustment_type`, `notes`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 1, 100.00, 'add', 'neew', 1, '2025-11-11 11:02:45', '2025-11-11 11:02:45');

-- --------------------------------------------------------

--
-- Table structure for table `stock_history`
--

CREATE TABLE `stock_history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `warehouse_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` double(8,2) NOT NULL,
  `old_quantity` double(8,2) NOT NULL DEFAULT 0.00,
  `order_type` varchar(20) DEFAULT 'sales',
  `stock_type` varchar(20) NOT NULL DEFAULT 'in',
  `action_type` varchar(20) NOT NULL DEFAULT 'add',
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stock_history`
--

INSERT INTO `stock_history` (`id`, `admin_id`, `company_id`, `warehouse_id`, `product_id`, `quantity`, `old_quantity`, `order_type`, `stock_type`, `action_type`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 1, 1.00, 0.00, 'sales', 'out', 'add', 1, '2025-11-11 11:00:27', '2025-11-11 11:00:27'),
(2, 1, 1, 1, 1, 100.00, 0.00, 'stock_adjustment', 'in', 'add_add', 1, '2025-11-11 11:02:45', '2025-11-11 11:02:45'),
(3, 1, 1, 1, 1, 1.00, 0.00, 'sales', 'out', 'add', 1, '2025-11-11 11:05:30', '2025-11-11 11:05:30');

-- --------------------------------------------------------

--
-- Table structure for table `subscription_plans`
--

CREATE TABLE `subscription_plans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `annual_price` double NOT NULL DEFAULT 0,
  `monthly_price` double NOT NULL DEFAULT 0,
  `max_products` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `modules` text DEFAULT NULL,
  `default` varchar(20) NOT NULL DEFAULT 'no',
  `is_popular` tinyint(1) NOT NULL DEFAULT 0,
  `is_private` tinyint(1) NOT NULL DEFAULT 0,
  `billing_cycle` tinyint(4) DEFAULT NULL,
  `stripe_monthly_plan_id` varchar(191) DEFAULT NULL,
  `stripe_annual_plan_id` varchar(191) DEFAULT NULL,
  `razorpay_monthly_plan_id` varchar(191) DEFAULT NULL,
  `razorpay_annual_plan_id` varchar(191) DEFAULT NULL,
  `paystack_monthly_plan_id` varchar(191) DEFAULT NULL,
  `paystack_annual_plan_id` varchar(191) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `duration` int(11) DEFAULT 30,
  `notify_before` int(11) DEFAULT NULL,
  `position` smallint(6) DEFAULT NULL,
  `features` text DEFAULT NULL,
  `currency_code` varchar(191) DEFAULT 'USD',
  `currency_symbol` varchar(191) DEFAULT '$',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `taxes`
--

CREATE TABLE `taxes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `rate` double(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `taxes`
--

INSERT INTO `taxes` (`id`, `admin_id`, `company_id`, `name`, `rate`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'GST', 18.00, '2025-11-11 10:59:30', '2025-11-11 10:59:30');

-- --------------------------------------------------------

--
-- Table structure for table `translations`
--

CREATE TABLE `translations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `lang_id` bigint(20) UNSIGNED DEFAULT NULL,
  `group` varchar(191) NOT NULL,
  `key` text NOT NULL,
  `value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `translations`
--

INSERT INTO `translations` (`id`, `lang_id`, `group`, `key`, `value`, `created_at`, `updated_at`) VALUES
(1, 1, 'common', 'enabled', 'Enabled', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(2, 1, 'common', 'disabled', 'Disabled', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(3, 1, 'common', 'id', 'Id', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(4, 1, 'common', 'action', 'Action', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(5, 1, 'common', 'placeholder_default_text', 'Please Enter {0}', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(6, 1, 'common', 'placeholder_social_text', 'Please Enter {0} Url', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(7, 1, 'common', 'placeholder_search_text', 'Search By {0}', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(8, 1, 'common', 'select_default_text', 'Select {0}...', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(9, 1, 'common', 'create', 'Create', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(10, 1, 'common', 'edit', 'Edit', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(11, 1, 'common', 'update', 'Update', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(12, 1, 'common', 'cancel', 'Cancel', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(13, 1, 'common', 'delete', 'Delete', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(14, 1, 'common', 'success', 'Success', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(15, 1, 'common', 'error', 'Error', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(16, 1, 'common', 'yes', 'Yes', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(17, 1, 'common', 'no', 'No', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(18, 1, 'common', 'fix_errors', 'Please Fix Below Errors.', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(19, 1, 'common', 'cancelled', 'Cancelled', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(20, 1, 'common', 'pending', 'Pending', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(21, 1, 'common', 'paid', 'Paid', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(22, 1, 'common', 'completed', 'Completed', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(23, 1, 'common', 'save', 'Save', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(24, 1, 'common', 'all', 'All', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(25, 1, 'common', 'name', 'Name', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(26, 1, 'common', 'back', 'Back', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(27, 1, 'common', 'max_amount', 'Max. Amount', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(28, 1, 'common', 'date_time', 'Date Time', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(29, 1, 'common', 'select_time', 'Select Time', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(30, 1, 'common', 'start_date', 'Start Date', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(31, 1, 'common', 'end_date', 'End Date', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(32, 1, 'common', 'search', 'Search', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(33, 1, 'common', 'date', 'Date', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(34, 1, 'common', 'out_of_stock', 'Out Of Stock', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(35, 1, 'common', 'pay', 'Pay', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(36, 1, 'common', 'received', 'Received', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(37, 1, 'common', 'with_tax', 'With Tax', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(38, 1, 'common', 'without_tax', 'Without Tax', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(39, 1, 'common', 'invoice_number', 'Invoice Number', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(40, 1, 'common', 'ordered', 'Ordered', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(41, 1, 'common', 'confirmed', 'Confirmed', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(42, 1, 'common', 'processing', 'Processing', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(43, 1, 'common', 'shipping', 'Shipping', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(44, 1, 'common', 'delivered', 'Delivered', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(45, 1, 'common', 'confirm', 'Confirm', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(46, 1, 'common', 'title', 'Title', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(47, 1, 'common', 'value', 'Value', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(48, 1, 'common', 'add', 'Add', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(49, 1, 'common', 'view', 'View', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(50, 1, 'common', 'download', 'Download', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(51, 1, 'common', 'change_order_status', 'Change Order Status', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(52, 1, 'common', 'total', 'Total', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(53, 1, 'common', 'print_invoice', 'Print Invoice', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(54, 1, 'common', 'email', 'Email', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(55, 1, 'common', 'phone', 'Phone', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(56, 1, 'common', 'item', 'Item', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(57, 1, 'common', 'items', 'Items', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(58, 1, 'common', 'qty', 'Qty', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(59, 1, 'common', 'rate', 'Rate', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(60, 1, 'common', 'purchase_code', 'Purchase Code', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(61, 1, 'common', 'verify_purchase', 'Verify Purchase', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(62, 1, 'common', 'buy_now', 'Buy Now', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(63, 1, 'common', 'install', 'Install', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(64, 1, 'common', 'installing', 'Installing', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(65, 1, 'common', 'updating', 'Updating', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(66, 1, 'common', 'free', 'Free', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(67, 1, 'common', 'domain', 'Domain', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(68, 1, 'common', 'verify', 'Verify', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(69, 1, 'common', 'send', 'Send', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(70, 1, 'common', 'upload', 'Upload', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(71, 1, 'common', 'view_all', 'View All', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(72, 1, 'common', 'unpaid', 'Unpaid', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(73, 1, 'common', 'loading', 'Loading', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(74, 1, 'common', 'update_app', 'Update App', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(75, 1, 'common', 'welcome_back', 'Welcome {0}', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(76, 1, 'common', 'off', 'Off', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(77, 1, 'common', 'on_create', 'On Create', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(78, 1, 'common', 'on_update', 'On Update', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(79, 1, 'common', 'on_delete', 'On Delete', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(80, 1, 'common', 'demo_account_credentials', 'Demo account login credentials', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(81, 1, 'common', 'balance', 'Balance', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(82, 1, 'common', 'party', 'Party', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(83, 1, 'common', 'created_by', 'Created By', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(84, 1, 'common', 'import', 'Import', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(85, 1, 'common', 'file', 'File', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(86, 1, 'common', 'copy_url', 'Copy Url', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(87, 1, 'common', 'print', 'Print', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(88, 1, 'common', 'pdf', 'Pdf', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(89, 1, 'common', 'particulars', 'Particulars', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(90, 1, 'common', 'amount', 'Amount', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(91, 1, 'common', 'profit', 'Profit', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(92, 1, 'common', 'profit_reports_by_orders', 'Profit Reports By Orders', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(93, 1, 'common', 'profit_reports_by_payments', 'Profit Reports By Payments', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(94, 1, 'common', 'status', 'Status', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(95, 1, 'common', 'active', 'Active', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(96, 1, 'common', 'inactive', 'Inactive', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(97, 1, 'common', 'verified', 'Verified', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(98, 1, 'common', 'configure', 'Configure', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(99, 1, 'common', 'logo', 'Logo', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(100, 1, 'common', 'comment', 'Comment', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(101, 1, 'common', 'rating', 'Rating', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(102, 1, 'common', 'page_content', 'Page Content', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(103, 1, 'common', 'slug', 'Slug', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(104, 1, 'common', 'question', 'Question', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(105, 1, 'common', 'answer', 'Answer', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(106, 1, 'common', 'description', 'Description', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(107, 1, 'common', 'image', 'Image', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(108, 1, 'common', 'address', 'Address', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(109, 1, 'common', 'not_allowed', 'Not Allowed', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(110, 1, 'common', 'details', 'Details', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(111, 1, 'common', 'excel', 'Excel', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(112, 1, 'menu', 'dashboard', 'Dashboard', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(113, 1, 'menu', 'stock_management', 'Stock Manager', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(114, 1, 'menu', 'purchase', 'Purchase', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(115, 1, 'menu', 'purchases', 'Purchases', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(116, 1, 'menu', 'purchase_returns', 'Purchase Return / Dr. Note', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(117, 1, 'menu', 'sales', 'Sales', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(118, 1, 'menu', 'sales_returns', 'Sales Return / Cr. Note', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(119, 1, 'menu', 'product_manager', 'Product Manager', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(120, 1, 'menu', 'brands', 'Brands', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(121, 1, 'menu', 'categories', 'Categories', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(122, 1, 'menu', 'products', 'Products', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(123, 1, 'menu', 'expense_manager', 'Expenses', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(124, 1, 'menu', 'expense_categories', 'Expense Categories', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(125, 1, 'menu', 'expenses', 'Expenses', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(126, 1, 'menu', 'users', 'Users', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(127, 1, 'menu', 'parties', 'Parties', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(128, 1, 'menu', 'staff_members', 'Staff Members', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(129, 1, 'menu', 'customers', 'Customers', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(130, 1, 'menu', 'suppliers', 'Suppliers', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(131, 1, 'menu', 'settings', 'Settings', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(132, 1, 'menu', 'company', 'Company Settings', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(133, 1, 'menu', 'profile', 'Profile', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(134, 1, 'menu', 'translations', 'Translations', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(135, 1, 'menu', 'languages', 'Languages', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(136, 1, 'menu', 'warehouses', 'Warehouses', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(137, 1, 'menu', 'roles', 'Role & Permissions', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(138, 1, 'menu', 'taxes', 'Taxes', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(139, 1, 'menu', 'currencies', 'Currencies', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(140, 1, 'menu', 'payment_modes', 'Payment Modes', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(141, 1, 'menu', 'units', 'Units', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(142, 1, 'menu', 'login', 'Login', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(143, 1, 'menu', 'logout', 'Logout', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(144, 1, 'menu', 'reports', 'Reports', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(145, 1, 'menu', 'order_payments', 'Order Payments', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(146, 1, 'menu', 'payments', 'Payments', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(147, 1, 'menu', 'stock_alert', 'Stock Alert', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(148, 1, 'menu', 'users_reports', 'Users Reports', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(149, 1, 'menu', 'warehouses_reports', 'Warehouses Reports', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(150, 1, 'menu', 'pos', 'POS', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(151, 1, 'menu', 'stock_adjustment', 'Stock Adjustment', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(152, 1, 'menu', 'verify_product', 'Verify Product', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(153, 1, 'menu', 'modules', 'Modules', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(154, 1, 'menu', 'storage_settings', 'Storage Settings', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(155, 1, 'menu', 'email_settings', 'Email Settings', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(156, 1, 'menu', 'update_app', 'Update App', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(157, 1, 'menu', 'custom_fields', 'Custom Fields', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(158, 1, 'menu', 'payment_in', 'Payment In', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(159, 1, 'menu', 'payment_out', 'Payment Out', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(160, 1, 'menu', 'cash_bank', 'Cash & Bank', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(161, 1, 'menu', 'sales_summary', 'Sales Summary', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(162, 1, 'menu', 'stock_summary', 'Stock Summary', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(163, 1, 'menu', 'rate_list', 'Rate List', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(164, 1, 'menu', 'product_sales_summary', 'Product Sales Summary', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(165, 1, 'menu', 'homepage', 'Buy online products', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(166, 1, 'menu', 'online_orders', 'Online Orders', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(167, 1, 'menu', 'website_setup', 'Website Setup', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(168, 1, 'menu', 'product_cards', 'Product Cards', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(169, 1, 'menu', 'front_settings', 'Front Settings', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(170, 1, 'menu', 'orders', 'Orders', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(171, 1, 'menu', 'quotations', 'Quotations', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(172, 1, 'menu', 'quotation', 'Quotation', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(173, 1, 'menu', 'quotation_estimate', 'Quotation / Estimate', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(174, 1, 'menu', 'database_backup', 'Database Backup', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(175, 1, 'menu', 'stock_transfer', 'Stock Transfer', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(176, 1, 'menu', 'stock_transfers', 'Stock Transfers', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(177, 1, 'menu', 'profit_loss', 'Profit & Loss', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(178, 1, 'menu', 'companies', 'Companies', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(179, 1, 'menu', 'pos_settings', 'POS Settings', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(180, 1, 'menu', 'setup_company', 'Setup Company', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(181, 1, 'dashboard', 'dashboard', 'Dashboard', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(182, 1, 'dashboard', 'recent_stock_history', 'Recent Stock History', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(183, 1, 'dashboard', 'top_selling_product', 'Top Selling Product', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(184, 1, 'dashboard', 'sales_purchases', 'Sales & Purchases', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(185, 1, 'dashboard', 'total_sales', 'Total Sales', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(186, 1, 'dashboard', 'top_customers', 'Top Customers', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(187, 1, 'dashboard', 'total_expenses', 'Total Expenses', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(188, 1, 'dashboard', 'payment_sent', 'Payment Sent', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(189, 1, 'dashboard', 'payment_received', 'Payment Received', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(190, 1, 'dashboard', 'total_sales_items', 'Total Sales Items', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(191, 1, 'dashboard', 'total_sales_returns_items', 'Total Sales Returns Items', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(192, 1, 'dashboard', 'total_purchases_items', 'Total Purchase Items', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(193, 1, 'dashboard', 'total_purchase_returns_items', 'Total Purchase Returns Items', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(194, 1, 'user', 'email_phone', 'Email or Phone', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(195, 1, 'user', 'user', 'User', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(196, 1, 'user', 'name', 'Name', '2025-11-11 09:07:59', '2025-11-11 09:07:59'),
(197, 1, 'user', 'created_at', 'Created At', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(198, 1, 'user', 'email', 'Email', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(199, 1, 'user', 'password', 'Password', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(200, 1, 'user', 'login_enabled', 'Login Enabled', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(201, 1, 'user', 'profile_image', 'Profile Image', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(202, 1, 'user', 'company_name', 'Company Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(203, 1, 'user', 'phone', 'Phone Number', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(204, 1, 'user', 'address', 'Address', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(205, 1, 'user', 'city', 'City', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(206, 1, 'user', 'state', 'State', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(207, 1, 'user', 'country', 'Country', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(208, 1, 'user', 'zipcode', 'Zipcode', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(209, 1, 'user', 'billing_address', 'Billing Address', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(210, 1, 'user', 'shipping_address', 'Shipping Address', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(211, 1, 'user', 'opening_balance', 'Opening Balance', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(212, 1, 'user', 'credit_period', 'Credit Period', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(213, 1, 'user', 'credit_limit', 'Credit Limit', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(214, 1, 'user', 'to_receive', 'To Collect', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(215, 1, 'user', 'to_pay', 'To Pay', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(216, 1, 'user', 'receive', 'Receive', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(217, 1, 'user', 'pay', 'Pay', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(218, 1, 'user', 'status', 'Status', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(219, 1, 'user', 'role', 'Role', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(220, 1, 'user', 'days', 'Day(s)', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(221, 1, 'user', 'profile_updated', 'Profile Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(222, 1, 'user', 'password_blank', 'Leave blank if you don\'t want to update password.', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(223, 1, 'user', 'total_sales', 'Total Sales', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(224, 1, 'user', 'total_purchases', 'Total Purchases', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(225, 1, 'user', 'walk_in_customer', 'Walk In Customer', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(226, 1, 'user', 'staff_members_details', 'Staff Member Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(227, 1, 'user', 'customers_details', 'Customer Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(228, 1, 'user', 'suppliers_details', 'Supplier Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(229, 1, 'user', 'admin_account_details', 'Admin Account Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(230, 1, 'user', 'tax_number', 'Tax Number', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(231, 1, 'user', 'warehouse_not_changable', 'Warehouse Can Not Be Changed', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(232, 1, 'staff_member', 'add', 'Add New Staff Member', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(233, 1, 'staff_member', 'edit', 'Edit Staff Member', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(234, 1, 'staff_member', 'created', 'Staff Member Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(235, 1, 'staff_member', 'updated', 'Staff Member Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(236, 1, 'staff_member', 'deleted', 'Staff Member Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(237, 1, 'staff_member', 'staff_member_details', 'Staff Member Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(238, 1, 'staff_member', 'staff_member', 'Staff Member', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(239, 1, 'staff_member', 'delete_message', 'Are you sure you want to delete this staff member?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(240, 1, 'staff_member', 'import_staff_members', 'Import Staff Members', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(241, 1, 'customer', 'add', 'Add New Customer', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(242, 1, 'customer', 'edit', 'Edit Customer', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(243, 1, 'customer', 'created', 'Customer Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(244, 1, 'customer', 'updated', 'Customer Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(245, 1, 'customer', 'deleted', 'Customer Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(246, 1, 'customer', 'customer_details', 'Customer Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(247, 1, 'customer', 'delete_message', 'Are you sure you want to delete this customer?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(248, 1, 'customer', 'import_customers', 'Import Customers', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(249, 1, 'supplier', 'add', 'Add New Supplier', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(250, 1, 'supplier', 'edit', 'Edit Supplier', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(251, 1, 'supplier', 'created', 'Supplier Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(252, 1, 'supplier', 'updated', 'Supplier Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(253, 1, 'supplier', 'deleted', 'Supplier Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(254, 1, 'supplier', 'supplier_details', 'Supplier Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(255, 1, 'supplier', 'delete_message', 'Are you sure you want to delete this supplier?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(256, 1, 'supplier', 'import_suppliers', 'Import Suppliers', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(257, 1, 'warehouse', 'add', 'Add New Warehouse', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(258, 1, 'warehouse', 'edit', 'Edit Warehouse', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(259, 1, 'warehouse', 'created', 'Warehouse Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(260, 1, 'warehouse', 'updated', 'Warehouse Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(261, 1, 'warehouse', 'deleted', 'Warehouse Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(262, 1, 'warehouse', 'warehouse_details', 'Warehouse Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(263, 1, 'warehouse', 'warehouse', 'Warehouse', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(264, 1, 'warehouse', 'logo', 'Logo', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(265, 1, 'warehouse', 'dark_logo', 'Dark Logo', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(266, 1, 'warehouse', 'name', 'Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(267, 1, 'warehouse', 'slug', 'Slug', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(268, 1, 'warehouse', 'email', 'Email', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(269, 1, 'warehouse', 'phone', 'Phone', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(270, 1, 'warehouse', 'address', 'Billing Address', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(271, 1, 'warehouse', 'show_email_on_invoice', 'Show email on invoice', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(272, 1, 'warehouse', 'show_phone_on_invoice', 'Show phone on invoice', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(273, 1, 'warehouse', 'terms_condition', 'Terms & Conditions', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(274, 1, 'warehouse', 'bank_details', 'Bank Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(275, 1, 'warehouse', 'signature', 'Signature', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(276, 1, 'warehouse', 'delete_message', 'Are you sure you want to delete this warehouse?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(277, 1, 'warehouse', 'details_will_be_shown_on_invoice', 'Note: Details added below will be shown on your invoices', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(278, 1, 'warehouse', 'online_store', 'Online Store', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(279, 1, 'warehouse', 'online_store_status_updated', 'Online store status updated successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(280, 1, 'warehouse', 'no_online_store_exists', 'No online store exists for this url. Please contact to admin for support.', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(281, 1, 'warehouse', 'view_online_store', 'View Online Store', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(282, 1, 'warehouse', 'default_pos_order_status', 'POS Default Status', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(283, 1, 'warehouse', 'basic_details', 'Basic Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(284, 1, 'warehouse', 'visibility', 'Visibility', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(285, 1, 'warehouse', 'customers_visibility', 'Customers Visibility', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(286, 1, 'warehouse', 'suppliers_visibility', 'Suppliers Visibility', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(287, 1, 'warehouse', 'products_visibility', 'Products Visibility', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(288, 1, 'warehouse', 'view_all_customers', 'View All Customers', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(289, 1, 'warehouse', 'view_warehouse_customers', 'View Only Warehouse Customers', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(290, 1, 'warehouse', 'view_all_suppliers', 'View All Suppliers', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(291, 1, 'warehouse', 'view_warehouse_suppliers', 'View Only Warehouse Suppliers', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(292, 1, 'warehouse', 'view_all_products', 'View All Products', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(293, 1, 'warehouse', 'view_warehouse_products', 'View Only Warehouse Products', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(294, 1, 'front_website', 'home', 'Home', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(295, 1, 'front_website', 'features', 'Features', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(296, 1, 'front_website', 'pricing', 'Pricing', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(297, 1, 'front_website', 'contact', 'Contact', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(298, 1, 'front_website', 'links', 'Links', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(299, 1, 'front_website', 'pages', 'Pages', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(300, 1, 'front_website', 'register', 'Register', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(301, 1, 'front_website', 'company_name', 'Company Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(302, 1, 'front_website', 'email', 'Email', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(303, 1, 'front_website', 'password', 'Password', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(304, 1, 'front_website', 'confirm_password', 'Confirm Password', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(305, 1, 'front_website', 'login', 'Login', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(306, 1, 'front_website', 'first_name', 'First Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(307, 1, 'front_website', 'last_name', 'Last Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(308, 1, 'front_website', 'address', 'Address', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(309, 1, 'front_website', 'phone', 'Phone', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(310, 1, 'front_website', 'send_message', 'Send Message', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(311, 1, 'front_website', 'register_thank_you', 'Thank you for registration. Please login to get started', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(312, 1, 'front_website', 'error_contact_support', 'Some error occurred when inserting the data. Please try again or contact support', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(313, 1, 'front_website', 'contact_us_submit_message', 'Thanks for contacting us. We will catch you soon.', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(314, 1, 'role', 'add', 'Add New Role', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(315, 1, 'role', 'edit', 'Edit Role', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(316, 1, 'role', 'created', 'Role Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(317, 1, 'role', 'updated', 'Role Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(318, 1, 'role', 'deleted', 'Role Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(319, 1, 'role', 'role_details', 'Role Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(320, 1, 'role', 'delete_message', 'Are you sure you want to delete this role?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(321, 1, 'role', 'display_name', 'Display Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(322, 1, 'role', 'role_name', 'Role Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(323, 1, 'role', 'description', 'Description', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(324, 1, 'role', 'user_management', 'User Management', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(325, 1, 'role', 'permissions', 'Permissions', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(326, 1, 'company', 'add', 'Add New Company', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(327, 1, 'company', 'edit', 'Edit Company', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(328, 1, 'company', 'created', 'Company Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(329, 1, 'company', 'updated', 'Company Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(330, 1, 'company', 'deleted', 'Company Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(331, 1, 'company', 'currency_details', 'Company Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(332, 1, 'company', 'delete_message', 'Are you sure you want to delete this company?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(333, 1, 'company', 'name', 'Company Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(334, 1, 'company', 'short_name', 'Company Short Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(335, 1, 'company', 'email', 'Company Email', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(336, 1, 'company', 'phone', 'Company Phone', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(337, 1, 'company', 'address', 'Company Address', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(338, 1, 'company', 'currency', 'Currency', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(339, 1, 'company', 'logo', 'Company Logo', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(340, 1, 'company', 'left_sidebar_theme', 'Left Sidebar Theme', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(341, 1, 'company', 'dark', 'Dark', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(342, 1, 'company', 'light', 'Light', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(343, 1, 'company', 'dark_logo', 'Dark Logo', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(344, 1, 'company', 'light_logo', 'Light Logo', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(345, 1, 'company', 'small_dark_logo', 'Small Dark Logo', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(346, 1, 'company', 'small_light_logo', 'Small Light Logo', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(347, 1, 'company', 'primary_color', 'Primary Color', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(348, 1, 'company', 'default_timezone', 'Default Timezone', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(349, 1, 'company', 'date_format', 'Date Format', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(350, 1, 'company', 'time_format', 'Time Format', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(351, 1, 'company', 'auto_detect_timezone', 'Auto Detect Timezone', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(352, 1, 'company', 'app_debug', 'App Debug', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(353, 1, 'company', 'update_app_notification', 'Update App Notitication', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(354, 1, 'company', 'login_image', 'Login Image', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(355, 1, 'company', 'layout', 'Layout', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(356, 1, 'company', 'rtl', 'RTL', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(357, 1, 'company', 'ltr', 'LTR', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(358, 1, 'company', 'shortcut_menu_Placement', 'Add Menu Placement', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(359, 1, 'company', 'top_and_bottom', 'Top & Bottom', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(360, 1, 'company', 'top_header', 'Top Header', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(361, 1, 'company', 'bottom_corner', 'Bottom Conrer', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(362, 1, 'company', 'shortcut_menu_setting', 'Add Menu Settings', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(363, 1, 'company', 'menu_setting_updated', 'Menu Setting Updated', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(364, 1, 'company', 'basic_details', 'Basic Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(365, 1, 'company', 'details', 'Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(366, 1, 'company', 'register_date', 'Register Date', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(367, 1, 'company', 'total_users', 'Total Users', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(368, 1, 'tax', 'add', 'Add New Tax', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(369, 1, 'tax', 'edit', 'Edit Tax', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(370, 1, 'tax', 'created', 'Tax Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(371, 1, 'tax', 'updated', 'Tax Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(372, 1, 'tax', 'deleted', 'Tax Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(373, 1, 'tax', 'tax_details', 'Tax Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(374, 1, 'tax', 'delete_message', 'Are you sure you want to delete this tax?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(375, 1, 'tax', 'display_name', 'Display Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(376, 1, 'tax', 'name', 'Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(377, 1, 'tax', 'rate', 'Tax Rate', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(378, 1, 'tax', 'no_tax', 'No Tax', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(379, 1, 'currency', 'add', 'Add New Currency', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(380, 1, 'currency', 'edit', 'Edit Currency', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(381, 1, 'currency', 'created', 'Currency Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(382, 1, 'currency', 'updated', 'Currency Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(383, 1, 'currency', 'deleted', 'Currency Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(384, 1, 'currency', 'currency_details', 'Currency Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(385, 1, 'currency', 'delete_message', 'Are you sure you want to delete this currency?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(386, 1, 'currency', 'name', 'Currency Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(387, 1, 'currency', 'symbol', 'Currency Symbol', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(388, 1, 'currency', 'position', 'Currency Position', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(389, 1, 'currency', 'front', 'Front', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(390, 1, 'currency', 'front_position_example', 'Example : $100', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(391, 1, 'currency', 'behind', 'Behind', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(392, 1, 'currency', 'behind_position_example', 'Example : 100$', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(393, 1, 'currency', 'code', 'Currency Code', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(394, 1, 'payment_mode', 'add', 'Add New Payment Mode', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(395, 1, 'payment_mode', 'edit', 'Edit Payment Mode', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(396, 1, 'payment_mode', 'created', 'Payment Mode Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(397, 1, 'payment_mode', 'updated', 'Payment Mode Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(398, 1, 'payment_mode', 'deleted', 'Payment Mode Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(399, 1, 'payment_mode', 'payment_mode_details', 'Payment Mode Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(400, 1, 'payment_mode', 'delete_message', 'Are you sure you want to delete this payment mode?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(401, 1, 'payment_mode', 'name', 'Payment Mode Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(402, 1, 'payment_mode', 'mode_type', 'Mode Type', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(403, 1, 'payment_mode', 'cash', 'Cash', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(404, 1, 'payment_mode', 'bank', 'Bank', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(405, 1, 'unit', 'add', 'Add New Unit', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(406, 1, 'unit', 'edit', 'Edit Unit', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(407, 1, 'unit', 'created', 'Unit Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(408, 1, 'unit', 'updated', 'Unit Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(409, 1, 'unit', 'deleted', 'Unit Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(410, 1, 'unit', 'delete_message', 'Are you sure you want to delete this unit?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(411, 1, 'unit', 'unit_details', 'Unit Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(412, 1, 'unit', 'name', 'Unit Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(413, 1, 'unit', 'short_name', 'Short Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(414, 1, 'unit', 'base_unit', 'Base Unit', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(415, 1, 'unit', 'operator', 'Operator', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(416, 1, 'unit', 'multiply', 'Multiply (*)', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(417, 1, 'unit', 'divide', 'Divide (/)', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(418, 1, 'unit', 'operator_value', 'Operator Value', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(419, 1, 'custom_field', 'add', 'Add New Custom Field', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(420, 1, 'custom_field', 'edit', 'Edit Custom Field', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(421, 1, 'custom_field', 'created', 'Custom Field Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(422, 1, 'custom_field', 'updated', 'Custom Field Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(423, 1, 'custom_field', 'deleted', 'Custom Field Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(424, 1, 'custom_field', 'delete_message', 'Are you sure you want to delete this custom field?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(425, 1, 'custom_field', 'name', 'Field Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(426, 1, 'custom_field', 'value', 'Default Value', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(427, 1, 'custom_field', 'type', 'Field Type', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(428, 1, 'module', 'name', 'Module Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(429, 1, 'module', 'verified', 'Verified', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(430, 1, 'module', 'verify_purchase_code', 'Verify Purchase Code', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(431, 1, 'module', 'current_version', 'Current Version', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(432, 1, 'module', 'latest_version', 'Latest Version', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(433, 1, 'module', 'status', 'Status', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(434, 1, 'module', 'installed_modules', 'Installed Modules', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(435, 1, 'module', 'other_modules', 'Other Modules', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(436, 1, 'module', 'module_status_updated', 'Modules Status Updated', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(437, 1, 'module', 'downloading_completed', 'Download Completed', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(438, 1, 'module', 'extract_zip_file', 'Extract Zip File', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(439, 1, 'module', 'file_extracted', 'Zip File Extracted', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(440, 1, 'update_app', 'app_details', 'App Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(441, 1, 'update_app', 'name', 'Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(442, 1, 'update_app', 'value', 'Value', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(443, 1, 'update_app', 'php_version', 'PHP Version', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(444, 1, 'update_app', 'app_version', 'App Version', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(445, 1, 'update_app', 'laravel_version', 'Laravel Version', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(446, 1, 'update_app', 'mysql_version', 'MySQL Version', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(447, 1, 'update_app', 'vue_version', 'Vue Version', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(448, 1, 'update_app', 'update_app', 'Update App', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(449, 1, 'update_app', 'update_now', 'Update Now', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(450, 1, 'update_app', 'update_available', 'Update Available', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(451, 1, 'update_app', 'verify_again', 'Verify Again', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(452, 1, 'update_app', 'verify_failed', 'Verification Failed', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(453, 1, 'update_app', 'verify_failed_message', 'Your application is not registerd with us. Please verify it', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(454, 1, 'update_app', 'verified_with_other_domain', 'Your purchase code is registerd with other doamin. Please verfiy your purhcase code', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(455, 1, 'expense_category', 'add', 'Add New Expense Category', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(456, 1, 'expense_category', 'edit', 'Edit Expense Category', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(457, 1, 'expense_category', 'created', 'Expense Category Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(458, 1, 'expense_category', 'updated', 'Expense Category Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(459, 1, 'expense_category', 'deleted', 'Expense Category Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(460, 1, 'expense_category', 'delete_message', 'Are you sure you want to delete this expense category?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(461, 1, 'expense_category', 'expense_category_details', 'Expense Category Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(462, 1, 'expense_category', 'name', 'Expense Category Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(463, 1, 'expense_category', 'description', 'Description', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(464, 1, 'expense', 'add', 'Add New Expense', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(465, 1, 'expense', 'edit', 'Edit Expense', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(466, 1, 'expense', 'created', 'Expense Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(467, 1, 'expense', 'updated', 'Expense Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(468, 1, 'expense', 'deleted', 'Expense Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(469, 1, 'expense', 'delete_message', 'Are you sure you want to delete this expense?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(470, 1, 'expense', 'details', 'Expense Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(471, 1, 'expense', 'warehouse', 'Warehouse', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(472, 1, 'expense', 'expense_category', 'Expense Category', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(473, 1, 'expense', 'date', 'Date', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(474, 1, 'expense', 'amount', 'Amount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(475, 1, 'expense', 'bill', 'Expense Bill', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(476, 1, 'expense', 'user', 'User', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(477, 1, 'expense', 'created_by_user', 'User', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(478, 1, 'expense', 'notes', 'Notes', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(479, 1, 'brand', 'add', 'Add New Brand', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(480, 1, 'brand', 'edit', 'Edit Brand', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(481, 1, 'brand', 'created', 'Brand Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(482, 1, 'brand', 'updated', 'Brand Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(483, 1, 'brand', 'deleted', 'Brand Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(484, 1, 'brand', 'delete_message', 'Are you sure you want to delete this brand?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(485, 1, 'brand', 'details', 'Brand Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(486, 1, 'brand', 'name', 'Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(487, 1, 'brand', 'slug', 'Slug', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(488, 1, 'brand', 'logo', 'Brand Logo', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(489, 1, 'brand', 'import_brands', 'Import Brands', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(490, 1, 'category', 'add', 'Add New Category', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(491, 1, 'category', 'edit', 'Edit Category', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(492, 1, 'category', 'created', 'Category Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(493, 1, 'category', 'updated', 'Category Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(494, 1, 'category', 'deleted', 'Category Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(495, 1, 'category', 'delete_message', 'Are you sure you want to delete this category?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(496, 1, 'category', 'details', 'Category Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(497, 1, 'category', 'category', 'Category', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(498, 1, 'category', 'name', 'Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(499, 1, 'category', 'slug', 'Slug', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(500, 1, 'category', 'logo', 'Category Logo', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(501, 1, 'category', 'parent_category', 'Parent Category', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(502, 1, 'category', 'no_parent_category', 'No Parent Category', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(503, 1, 'category', 'import_categories', 'Import Categories', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(504, 1, 'product', 'add', 'Add New Product', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(505, 1, 'product', 'edit', 'Edit Product', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(506, 1, 'product', 'created', 'Product Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(507, 1, 'product', 'updated', 'Product Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(508, 1, 'product', 'deleted', 'Product Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(509, 1, 'product', 'delete_message', 'Are you sure you want to delete this product?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(510, 1, 'product', 'details', 'Product Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(511, 1, 'product', 'name', 'Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(512, 1, 'product', 'slug', 'Slug', '2025-11-11 09:08:00', '2025-11-11 09:08:00');
INSERT INTO `translations` (`id`, `lang_id`, `group`, `key`, `value`, `created_at`, `updated_at`) VALUES
(513, 1, 'product', 'sku', 'SKU', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(514, 1, 'product', 'image', 'Image', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(515, 1, 'product', 'quantitiy_alert', 'Quantity Alert', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(516, 1, 'product', 'brand', 'Brand', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(517, 1, 'product', 'category', 'Category', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(518, 1, 'product', 'price', 'Price', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(519, 1, 'product', 'mrp', 'MRP', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(520, 1, 'product', 'purchase_price', 'Purchase Price', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(521, 1, 'product', 'sales_price', 'Sales Price', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(522, 1, 'product', 'tax_type', 'Tax Type', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(523, 1, 'product', 'description', 'Description', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(524, 1, 'product', 'product', 'Product', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(525, 1, 'product', 'quantity', 'Quantity', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(526, 1, 'product', 'discount', 'Discount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(527, 1, 'product', 'tax', 'Tax', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(528, 1, 'product', 'subtotal', 'SubTotal', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(529, 1, 'product', 'unit', 'Unit', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(530, 1, 'product', 'unit_price', 'Unit Price', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(531, 1, 'product', 'avl_qty', 'Avl. qty:', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(532, 1, 'product', 'order_items', 'Order Items', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(533, 1, 'product', 'inclusive', 'Inclusive', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(534, 1, 'product', 'exclusive', 'Exclusive', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(535, 1, 'product', 'stocks', 'Stocks', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(536, 1, 'product', 'stock_quantity', 'Stock Quantity', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(537, 1, 'product', 'product_orders', 'Product Orders', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(538, 1, 'product', 'stock_history', 'Stock History', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(539, 1, 'product', 'current_stock', 'Current Stock', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(540, 1, 'product', 'item_code', 'Item Code', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(541, 1, 'product', 'barcode_symbology', 'Barcode Symbology', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(542, 1, 'product', 'barcode', 'Barcode', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(543, 1, 'product', 'view_barcode', 'View Barcode', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(544, 1, 'product', 'generate_barcode', 'Generate Barcode', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(545, 1, 'product', 'print_barcode', 'Print Barcode', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(546, 1, 'product', 'price_tax', 'Price & Tax', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(547, 1, 'product', 'custom_fields', 'Custom Fields', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(548, 1, 'product', 'wholesale_rate', 'Wholesale Rate', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(549, 1, 'product', 'wholesale_price', 'Wholesale Price', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(550, 1, 'product', 'wholesale_quantity', 'Wholesale Quantity', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(551, 1, 'product', 'enter_min_quantity', 'Enter Minimum Quantity', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(552, 1, 'product', 'opening_stock', 'Opening Stock', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(553, 1, 'product', 'opening_stock_date', 'Opening Stock Date', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(554, 1, 'product', 'stock_value', 'Stock Value', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(555, 1, 'product', 'by_purchase', 'By Purchase', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(556, 1, 'product', 'by_sales', 'By Sales', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(557, 1, 'product', 'unit_sold', 'Unit Sold', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(558, 1, 'product', 'import_products', 'Import Products', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(559, 1, 'stock', 'order_type', 'Order Type', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(560, 1, 'stock', 'order_date', 'Order Date', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(561, 1, 'stock', 'warehouse', 'Warehouse', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(562, 1, 'stock', 'supplier', 'Supplier', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(563, 1, 'stock', 'customer', 'Customer', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(564, 1, 'stock', 'product', 'Product', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(565, 1, 'stock', 'invoice_number', 'Invoice Number', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(566, 1, 'stock', 'invoie_number_blank', 'Leave it blank to generate automatically', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(567, 1, 'stock', 'notes', 'Notes', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(568, 1, 'stock', 'status', 'Order Status', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(569, 1, 'stock', 'order_tax', 'Order Tax', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(570, 1, 'stock', 'discount', 'Discount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(571, 1, 'stock', 'shipping', 'Shipping', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(572, 1, 'stock', 'grand_total', 'Grand Total', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(573, 1, 'stock', 'remarks', 'Remarks', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(574, 1, 'stock', 'pay_now', 'Pay Now', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(575, 1, 'stock', 'reset', 'Reset', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(576, 1, 'stock', 'total_items', 'Total Items', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(577, 1, 'stock', 'paying_amount', 'Paying Amount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(578, 1, 'stock', 'payable_amount', 'Payable Amount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(579, 1, 'stock', 'change_return', 'Change Return', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(580, 1, 'stock', 'order_details', 'Order Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(581, 1, 'stock', 'order_canceled', 'Order Canceled Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(582, 1, 'stock', 'order_cancel_message', 'Are you sure you want to cancel this order?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(583, 1, 'stock', 'view_order', 'View Order', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(584, 1, 'stock', 'order_id', 'Order Id', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(585, 1, 'stock', 'shipping_address', 'Shipping Address', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(586, 1, 'stock', 'billing_address', 'Billing Address', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(587, 1, 'stock', 'order_taken_by', 'Order Taken By', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(588, 1, 'stock', 'no_product_found', 'No product found for selected resource', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(589, 1, 'stock', 'sold_by', 'Sold By', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(590, 1, 'stock', 'complete_order', 'Complete Order', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(591, 1, 'purchase', 'add', 'Add New Purchase', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(592, 1, 'purchase', 'edit', 'Edit Purchase', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(593, 1, 'purchase', 'details', 'Purchase Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(594, 1, 'purchase', 'created', 'Purchase Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(595, 1, 'purchase', 'updated', 'Purchase Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(596, 1, 'purchase', 'deleted', 'Purchase Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(597, 1, 'purchase', 'delete_message', 'Are you sure you want to delete this purchase?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(598, 1, 'purchase', 'purchase_date', 'Purchase Date', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(599, 1, 'purchase', 'purchase_status', 'Purchase Status', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(600, 1, 'purchase', 'user', 'Supplier', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(601, 1, 'sales', 'add', 'Add New Sales', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(602, 1, 'sales', 'edit', 'Edit Sales', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(603, 1, 'sales', 'details', 'Sales Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(604, 1, 'sales', 'created', 'Sales Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(605, 1, 'sales', 'updated', 'Sales Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(606, 1, 'sales', 'deleted', 'Sales Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(607, 1, 'sales', 'delete_message', 'Are you sure you want to delete this sales?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(608, 1, 'sales', 'sales_date', 'Sales Date', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(609, 1, 'sales', 'sales_status', 'Sales Status', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(610, 1, 'sales', 'user', 'Customer', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(611, 1, 'sales', 'tax_invoice', 'TAX INVOICE', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(612, 1, 'sales', 'invoice', 'Invoice', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(613, 1, 'purchase_returns', 'add', 'Add New Purchase Return', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(614, 1, 'purchase_returns', 'edit', 'Edit Purchase Return', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(615, 1, 'purchase_returns', 'details', 'Purchase Return Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(616, 1, 'purchase_returns', 'created', 'Purchase Return Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(617, 1, 'purchase_returns', 'updated', 'Purchase Return Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(618, 1, 'purchase_returns', 'deleted', 'Purchase Return Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(619, 1, 'purchase_returns', 'delete_message', 'Are you sure you want to delete this purchase return?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(620, 1, 'purchase_returns', 'purchase_returns_date', 'Return Date', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(621, 1, 'purchase_returns', 'purchase_returns_status', 'Return Status', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(622, 1, 'purchase_returns', 'user', 'Supplier', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(623, 1, 'sales_returns', 'add', 'Add New Sales Return', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(624, 1, 'sales_returns', 'edit', 'Edit Sales Return', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(625, 1, 'sales_returns', 'details', 'Sales Return Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(626, 1, 'sales_returns', 'created', 'Sales Return Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(627, 1, 'sales_returns', 'updated', 'Sales Return Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(628, 1, 'sales_returns', 'deleted', 'Sales Return Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(629, 1, 'sales_returns', 'delete_message', 'Are you sure you want to delete this sales return?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(630, 1, 'sales_returns', 'sales_returns_date', 'Return Date', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(631, 1, 'sales_returns', 'sales_returns_status', 'Return Status', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(632, 1, 'sales_returns', 'user', 'Customer', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(633, 1, 'quotation', 'add', 'Add New Quotation', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(634, 1, 'quotation', 'edit', 'Edit Quotation', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(635, 1, 'quotation', 'details', 'Quotation Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(636, 1, 'quotation', 'created', 'Quotation Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(637, 1, 'quotation', 'updated', 'Quotation Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(638, 1, 'quotation', 'deleted', 'Quotation Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(639, 1, 'quotation', 'delete_message', 'Are you sure you want to delete this quotation/estimate?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(640, 1, 'quotation', 'quotation_date', 'Quotation Date', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(641, 1, 'quotation', 'quotation_status', 'Quotation Status', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(642, 1, 'quotation', 'user', 'Customer', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(643, 1, 'quotation', 'tax_invoice', 'TAX INVOICE', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(644, 1, 'quotation', 'invoice', 'Invoice', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(645, 1, 'quotation', 'convert_to_sale', 'Convert to sale', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(646, 1, 'quotation', 'convert_message', 'Are you really want to convert this quotation to sales?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(647, 1, 'quotation', 'quotation_converted_to_sales', 'Quotation converted to sales successfully.', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(648, 1, 'payments', 'add', 'Add New Payment', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(649, 1, 'payments', 'edit', 'Edit Payment', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(650, 1, 'payments', 'details', 'Payment Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(651, 1, 'payments', 'created', 'Payment Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(652, 1, 'payments', 'updated', 'Payment Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(653, 1, 'payments', 'deleted', 'Payment Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(654, 1, 'payments', 'delete_message', 'Are you sure you want to delete this payment?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(655, 1, 'payments', 'user', 'User', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(656, 1, 'payments', 'amount', 'Amount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(657, 1, 'payments', 'invoice_amount', 'Invoice Amount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(658, 1, 'payments', 'payment_number', 'Reference Number', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(659, 1, 'payments', 'payments', 'Payments', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(660, 1, 'payments', 'date', 'Payment Date', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(661, 1, 'payments', 'due_amount', 'Due Amount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(662, 1, 'payments', 'paid_amount', 'Paid Amount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(663, 1, 'payments', 'total_amount', 'Total Amount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(664, 1, 'payments', 'unused_amount', 'Unused Amount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(665, 1, 'payments', 'settled_amount', 'Settled Amount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(666, 1, 'payments', 'payment_mode', 'Payment Mode', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(667, 1, 'payments', 'paid_total_amount', 'Paid/Total Amount', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(668, 1, 'payments', 'notes', 'Notes', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(669, 1, 'payments', 'payment_status', 'Payment Status', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(670, 1, 'payments', 'unpaid', 'Unpaid', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(671, 1, 'payments', 'paid', 'Paid', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(672, 1, 'payments', 'transactions', 'Transactions', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(673, 1, 'payments', 'transaction_number', 'Txns No.', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(674, 1, 'payments', 'partially_paid', 'Partially Paid', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(675, 1, 'payments', 'order_payment', 'Order Payment', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(676, 1, 'payments', 'settle_invoice_using_payment', 'Settle below invoices using this payment', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(677, 1, 'payments', 'payment_type', 'Payment Type', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(678, 1, 'payments', 'you_will_pay', 'You Will Pay', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(679, 1, 'payments', 'you_will_receive', 'You Will Receive', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(680, 1, 'payments', 'cash', 'Cash', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(681, 1, 'payments', 'bank', 'Bank', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(682, 1, 'langs', 'add', 'Add New Language', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(683, 1, 'langs', 'edit', 'Edit Language', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(684, 1, 'langs', 'details', 'Language Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(685, 1, 'langs', 'created', 'Language Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(686, 1, 'langs', 'updated', 'Language Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(687, 1, 'langs', 'deleted', 'Language Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(688, 1, 'langs', 'delete_message', 'Are you sure you want to delete this language?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(689, 1, 'langs', 'view_all_langs', 'View All Languages', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(690, 1, 'langs', 'status_updated', 'Langugage status updated', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(691, 1, 'langs', 'name', 'Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(692, 1, 'langs', 'key', 'Key', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(693, 1, 'langs', 'flag', 'Flag', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(694, 1, 'langs', 'enabled', 'Enabled', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(695, 1, 'translations', 'fetch_new_translations', 'Fetch New Translations', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(696, 1, 'translations', 'reload_translations', 'Reload Translations', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(697, 1, 'translations', 'reload_successfully', 'Translations Reload Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(698, 1, 'translations', 'fetched_successfully', 'Translations Fetch Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(699, 1, 'translations', 'import_translations', 'Import Translations', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(700, 1, 'storage_settings', 'updated', 'Storage Settings Updated', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(701, 1, 'storage_settings', 'storage', 'Storage', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(702, 1, 'storage_settings', 'local', 'Local', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(703, 1, 'storage_settings', 'aws', 'AWS S3 Storage', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(704, 1, 'storage_settings', 'aws_key', 'AWS Key', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(705, 1, 'storage_settings', 'aws_secret', 'AWS Secret', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(706, 1, 'storage_settings', 'aws_region', 'AWS Region', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(707, 1, 'storage_settings', 'aws_bucket', 'AWS Bucket', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(708, 1, 'mail_settings', 'updated', 'Mail Settings Updated', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(709, 1, 'mail_settings', 'mail_driver', 'Mail Driver', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(710, 1, 'mail_settings', 'none', 'None', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(711, 1, 'mail_settings', 'mail', 'Mail', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(712, 1, 'mail_settings', 'smtp', 'SMTP', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(713, 1, 'mail_settings', 'from_name', 'Mail From Name', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(714, 1, 'mail_settings', 'from_email', 'Mail From Email', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(715, 1, 'mail_settings', 'host', 'Host', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(716, 1, 'mail_settings', 'port', 'Port', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(717, 1, 'mail_settings', 'encryption', 'Encryption', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(718, 1, 'mail_settings', 'username', 'Username', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(719, 1, 'mail_settings', 'password', 'Password', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(720, 1, 'mail_settings', 'send_test_mail', 'Send Test Mail', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(721, 1, 'mail_settings', 'send_mail_setting_saved', 'Send mail setting saved', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(722, 1, 'mail_settings', 'enable_mail_queue', 'Enable Mail Queue', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(723, 1, 'mail_settings', 'send_mail_for', 'Send Mail For', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(724, 1, 'mail_settings', 'email', 'Email address for which you want to send test mail', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(725, 1, 'mail_settings', 'test_mail_sent_successfully', 'Test mail sent successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(726, 1, 'mail_settings', 'stock_adjustment_create', 'Stock Adjustment Create', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(727, 1, 'mail_settings', 'notificaiton_will_be_sent_to_warehouse', 'Notification will be sent to warehouse email', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(728, 1, 'online_orders', 'order_summary', 'Order Summary', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(729, 1, 'online_orders', 'cancel_order', 'Cancel Order', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(730, 1, 'online_orders', 'order_cancelled', 'Order cancelled successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(731, 1, 'online_orders', 'order_cancelled_message', 'This order has been cancelled.', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(732, 1, 'online_orders', 'cancel_message', 'Are you sure you want to cancel this online order', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(733, 1, 'online_orders', 'deliver_message', 'Are you sure you want to this order as delivered', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(734, 1, 'online_orders', 'order_confirmed', 'Order confirmed successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(735, 1, 'online_orders', 'order_status_changed', 'Order status changed successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(736, 1, 'online_orders', 'online_orders_date', 'Order Date', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(737, 1, 'online_orders', 'online_orders_status', 'Order Status', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(738, 1, 'online_orders', 'update_orders_status', 'Update Order Status', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(739, 1, 'online_orders', 'confirm_delivery', 'Confirm Delivery', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(740, 1, 'online_orders', 'order_delivered', 'Order delivered successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(741, 1, 'online_orders', 'user', 'Customer', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(742, 1, 'online_orders', 'online_store_url', 'Online Store Url', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(743, 1, 'product_card', 'add', 'Add New Product Card', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(744, 1, 'product_card', 'edit', 'Edit Product Card', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(745, 1, 'product_card', 'details', 'Product Card Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(746, 1, 'product_card', 'created', 'Product Card Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(747, 1, 'product_card', 'updated', 'Product Card Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(748, 1, 'product_card', 'deleted', 'Product Card Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(749, 1, 'product_card', 'delete_message', 'Are you sure you want to delete this product card?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(750, 1, 'product_card', 'title', 'Title', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(751, 1, 'product_card', 'subtitle', 'Subtitle', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(752, 1, 'product_card', 'products', 'Products', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(753, 1, 'front_setting', 'products', 'Products', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(754, 1, 'front_setting', 'featured_categories', 'Featured Categories', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(755, 1, 'front_setting', 'featured_categories_title', 'Featured Categories Title', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(756, 1, 'front_setting', 'featured_categories_subtitle', 'Featured Categories Subtitle', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(757, 1, 'front_setting', 'featured_products', 'Featured Products', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(758, 1, 'front_setting', 'featured_products_title', 'Featured Products Title', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(759, 1, 'front_setting', 'featured_products_subtitle', 'Featured Products Subtitle', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(760, 1, 'front_setting', 'social_links', 'Social Links', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(761, 1, 'front_setting', 'facebook', 'Facebook', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(762, 1, 'front_setting', 'twitter', 'Twitter', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(763, 1, 'front_setting', 'instagram', 'Instagram', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(764, 1, 'front_setting', 'linkedin', 'Linkedin', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(765, 1, 'front_setting', 'youtube', 'Youttube', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(766, 1, 'front_setting', 'footer', 'Footer', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(767, 1, 'front_setting', 'banners', 'Banners', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(768, 1, 'front_setting', 'placeholder_social_text', 'Please Enter {0} Url', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(769, 1, 'front_setting', 'footers', 'Footers', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(770, 1, 'front_setting', 'copyright_text', 'Copyright Text', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(771, 1, 'front_setting', 'addLink', 'Add Link', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(772, 1, 'front_setting', 'addContactLink', 'Add Contact Link', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(773, 1, 'front_setting', 'addPageDetails', 'Add Pages Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(774, 1, 'front_setting', 'required_text', '{0} Required', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(775, 1, 'front_setting', 'footer_page_widget', 'Footer Page Widget', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(776, 1, 'front_setting', 'footer_contact_widget', 'Footer Contact Widget', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(777, 1, 'front_setting', 'footer_links_widget', 'Footer Links Widget', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(778, 1, 'front_setting', 'bottom_banners', 'Bottom Banners', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(779, 1, 'front_setting', 'top_banners_1', 'Top Banner 1', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(780, 1, 'front_setting', 'top_banners_2', 'Top Banner 2', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(781, 1, 'front_setting', 'top_banners_3', 'Top Banner 3', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(782, 1, 'front_setting', 'add_to_cart', 'Add To Cart', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(783, 1, 'front_setting', 'footer_company_description', 'Footer Company Description', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(784, 1, 'front_setting', 'useful_links', 'Useful Links', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(785, 1, 'front_setting', 'pages', 'Pages', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(786, 1, 'front_setting', 'contact', 'Contact', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(787, 1, 'front_setting', 'all_categories', 'All Categories', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(788, 1, 'front_setting', 'no_results', 'No Results', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(789, 1, 'front_setting', 'seo_keywords', 'SEO Keywords', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(790, 1, 'front_setting', 'seo_description', 'SEO Description', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(791, 1, 'stock_adjustment', 'add', 'Add New Adjustment', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(792, 1, 'stock_adjustment', 'edit', 'Edit Adjustment', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(793, 1, 'stock_adjustment', 'details', 'Adjustment Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(794, 1, 'stock_adjustment', 'created', 'Adjustment Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(795, 1, 'stock_adjustment', 'updated', 'Adjustment Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(796, 1, 'stock_adjustment', 'deleted', 'Adjustment Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(797, 1, 'stock_adjustment', 'delete_message', 'Are you sure you want to delete this stock adjustment?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(798, 1, 'stock_adjustment', 'notes', 'Notes', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(799, 1, 'stock_adjustment', 'current_stock', 'Current Stock', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(800, 1, 'stock_adjustment', 'quantity', 'Quantity', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(801, 1, 'stock_adjustment', 'adjustment_type', 'Adjustment Type', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(802, 1, 'stock_adjustment', 'adjustment_add', 'Add', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(803, 1, 'stock_adjustment', 'adjustment_subtract', 'Subtract', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(804, 1, 'stock_transfer', 'add', 'Add New Transfer', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(805, 1, 'stock_transfer', 'edit', 'Edit Transfer', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(806, 1, 'stock_transfer', 'details', 'Transfer Details', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(807, 1, 'stock_transfer', 'created', 'Transfer Created Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(808, 1, 'stock_transfer', 'updated', 'Transfer Updated Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(809, 1, 'stock_transfer', 'deleted', 'Transfer Deleted Successfully', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(810, 1, 'stock_transfer', 'delete_message', 'Are you sure you want to delete this stock adjustment?', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(811, 1, 'stock_transfer', 'stock_transfer_date', 'Stock Transfer Date', '2025-11-11 09:08:00', '2025-11-11 09:08:00'),
(812, 1, 'stock_transfer', 'stock_transfer_status', 'Stock Transfer Status', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(813, 1, 'stock_transfer', 'from_warehouse', 'From Warehouse', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(814, 1, 'stock_transfer', 'to_warehouse', 'To Warehouse', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(815, 1, 'stock_transfer', 'warehouse', 'Warehouse', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(816, 1, 'stock_transfer', 'products', 'Products', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(817, 1, 'stock_transfer', 'notes', 'Notes', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(818, 1, 'stock_transfer', 'quantity', 'Quantity', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(819, 1, 'stock_transfer', 'created_by', 'Created By', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(820, 1, 'stock_transfer', 'received', 'Received', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(821, 1, 'stock_transfer', 'transfered', 'Transfered', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(822, 1, 'database_backup', 'file', 'File', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(823, 1, 'database_backup', 'file_size', 'File Size', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(824, 1, 'database_backup', 'generate_backup', 'Generate Backup', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(825, 1, 'database_backup', 'delete_backup', 'Delete Backup', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(826, 1, 'database_backup', 'backup_generated_successfully', 'Backup Generated Successfully', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(827, 1, 'database_backup', 'are_you_sure_generate_backup', 'Are you sure you want to generate database backup?', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(828, 1, 'database_backup', 'are_you_sure_delete_backup', 'Are you sure you want to delete this database backup?', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(829, 1, 'database_backup', 'backup_locaion_is', 'All generated database file will be stored in storage/app/public/backup folder. ', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(830, 1, 'database_backup', 'settings', 'Command Settings', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(831, 1, 'database_backup', 'backup_command_setting', 'Backup Command Settings', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(832, 1, 'database_backup', 'mysqldump_command_path', 'mysqldump command path', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(833, 1, 'database_backup', 'command_updated', 'Command updated successfully', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(834, 1, 'database_backup', 'window_command_path', 'If you use XAMPP then it will be => C:\\xampp\\mysql\\bin\\mysqldump.exe', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(835, 1, 'database_backup', 'laragon_command_path', 'If you use Laragon then it will be => C:\\laragon\\bin\\mysql\\mysql-5.7.24-winx64\\bin\\mysqldump.exe', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(836, 1, 'database_backup', 'linux_command_path', 'If you are on ubuntu or mac then run following command and enter output here => which mysqldump', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(837, 1, 'database_backup', 'put_dump_path_command_on_env_file', 'Find your MySQL dump path from below and then add it to the DUMP_PATH inside .env file', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(838, 1, 'messages', 'product_out_of_stock', 'Product is out of stock. Current Stock is {0} while required stock is {1}.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(839, 1, 'messages', 'leave_blank_to_create_parent_category', 'Leave it blank to create parent category', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(840, 1, 'messages', 'somehing_went_wrong', 'Something went wrong. Please contact to administrator.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(841, 1, 'messages', 'verify_success', 'Successfully verified. Redirect to app...', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(842, 1, 'messages', 'login_success', 'Successfully login. Redirect to app...', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(843, 1, 'messages', 'login_success_dashboard', 'Successfully logged into app.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(844, 1, 'messages', 'click_here_to_find_purchase_code', 'Click here to find your purchase code', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(845, 1, 'messages', 'verification_successfull', 'Verification successfully', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(846, 1, 'messages', 'other_domain_linked', 'Other domain linked', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(847, 1, 'messages', 'other_domain_linked_with_purchase_code', 'Other domain is already linked with your purchase code. Please enter your purchase code for more details...', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(848, 1, 'messages', 'first_verify_module_message', 'To enable please \\n verify this module', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(849, 1, 'messages', 'are_you_sure_install_message', 'Are you sure you want to install?', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(850, 1, 'messages', 'downloading_started_message', 'Downloading started. Please wait ...', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(851, 1, 'messages', 'file_extracting_message', 'File extracteding. Please wait ...', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(852, 1, 'messages', 'installation_success', 'Installation successfully. Click here to reload page...', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(853, 1, 'messages', 'are_you_sure_update_message', 'Are you sure you want to update? Please take backup before update.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(854, 1, 'messages', 'stmp_success_message', 'Your SMTP settings are correct..', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(855, 1, 'messages', 'stmp_error_message', 'Your SMTP settings are incorrect. Please update it to send mails', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(856, 1, 'messages', 'uploading_failed', 'Uploading failed', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(857, 1, 'messages', 'loading_app_message', 'Please wait... we are preparing something amazing for you', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(858, 1, 'messages', 'fetching_product_details', 'We are fetching product details. Please wait...', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(859, 1, 'messages', 'product_is_upto_date', 'You are on the latest version of app.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(860, 1, 'messages', 'new_app_version_avaialbe', 'New app version {0} is available. Please update to get latest version.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(861, 1, 'messages', 'not_able_to_edit_order', 'Only order status editable, other fields can not be editable becuase this order linked to some payments. Delete those payment(s) and try again.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(862, 1, 'messages', 'click_here_to_download_sample_file', 'Click here to download sample csv file', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(863, 1, 'messages', 'imported_successfully', 'Imported Successfully', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(864, 1, 'messages', 'company_admin_password_message', 'Admin will login using this password. (Leave blank to keep current password)', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(865, 1, 'messages', 'email_setting_not_configured', 'Email setting not configured', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(866, 1, 'messages', 'please_configure_email_settings', 'Please configure your email settings to send emails. Click Here to configure email settings.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(867, 1, 'popover', 'quantitiy_alert', 'After this stock quanity it will enable low stock warning.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(868, 1, 'popover', 'auto_detect_timezone', 'Allow auto detect timezone from browser for currently logged in user.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(869, 1, 'popover', 'click_here_to_copy_credentials', 'Click here to copy {0} credentials', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(870, 1, 'invoice', 'purchase_invoice', 'Purchase Invoice', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(871, 1, 'invoice', 'purchase_return_invoice', 'Purchase Return Invoice', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(872, 1, 'invoice', 'sales_invoice', 'Sales Invoice', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(873, 1, 'invoice', 'sales_return_invoice', 'Sales Return Invoice', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(874, 1, 'invoice', 'invoice', 'Invoice', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(875, 1, 'invoice', 'order_date', 'Date', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(876, 1, 'invoice', 'order_status', 'Status', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(877, 1, 'invoice', 'payment_status', 'Payment Status', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(878, 1, 'invoice', 'bill_to', 'Bill To', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(879, 1, 'invoice', 'product', 'Product', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(880, 1, 'invoice', 'unit_price', 'Unit Price', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(881, 1, 'invoice', 'quantity', 'Quantity', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(882, 1, 'invoice', 'total', 'Total', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(883, 1, 'invoice', 'notes', 'Notes', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(884, 1, 'invoice', 'subtotal', 'Subtotal', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(885, 1, 'invoice', 'tax', 'Tax', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(886, 1, 'invoice', 'discount', 'Discount', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(887, 1, 'invoice', 'shipping', 'Shipping', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(888, 1, 'invoice', 'total_items', 'Total Items', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(889, 1, 'invoice', 'qty', 'Qty', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(890, 1, 'invoice', 'paid_amount', 'Paid Amount', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(891, 1, 'invoice', 'due_amount', 'Due Amount', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(892, 1, 'invoice', 'payment_mode', 'Payment Mode', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(893, 1, 'invoice', 'thanks_message', 'Thank You For Shopping With Us. Please Come Again', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(894, 1, 'front', 'home', 'Home', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(895, 1, 'front', 'profile', 'Profile', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(896, 1, 'front', 'dashboard', 'Dashboard', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(897, 1, 'front', 'my_orders', 'My Orders', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(898, 1, 'front', 'my_profile', 'My Profile', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(899, 1, 'front', 'logout', 'Logout', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(900, 1, 'front', 'total_orders', 'Total Orders', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(901, 1, 'front', 'pending_orders', 'Pending Orders', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(902, 1, 'front', 'processing_orders', 'Processing Orders', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(903, 1, 'front', 'completed_orders', 'Completed Orders', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(904, 1, 'front', 'recent_orders', 'Recent Orders', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(905, 1, 'front', 'order_history', 'Order History', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(906, 1, 'front', 'profile_settings', 'Profile Settings', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(907, 1, 'front', 'select_shipping_address', 'Select Shipping Address', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(908, 1, 'front', 'checkout_page', 'Checkout Page', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(909, 1, 'front', 'address_details', 'Address Details', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(910, 1, 'front', 'payment_details', 'Payment Details', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(911, 1, 'front', 'add_new_address', 'Add New Address', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(912, 1, 'front', 'cash_on_delivery', 'Cash On Delivery', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(913, 1, 'front', 'continue_shopping', 'Continue Shopping', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(914, 1, 'front', 'confirm_order', 'Confirm Order', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(915, 1, 'front', 'confirm_order_message', 'Are you sure you want to confirm this order?', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(916, 1, 'front', 'order_placed', 'Order placeded.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(917, 1, 'front', 'order_placed_message', 'Order placed successfully.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(918, 1, 'front', 'all_orders', 'All Orders', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(919, 1, 'front', 'follow_us', 'Follow Us', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(920, 1, 'front', 'categories', 'Categories', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(921, 1, 'front', 'pages', 'Pages', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(922, 1, 'front', 'address_deleted', 'Address Deleted', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(923, 1, 'front', 'address_saved', 'Address Saved', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(924, 1, 'front', 'address_delete_message', 'Are you sure you want to delete this address?', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(925, 1, 'front', 'setting_updated_successfully', 'Setting updated successfully', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(926, 1, 'front', 'login', 'Login', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(927, 1, 'front', 'login_using_email_password', 'Login using email and password', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(928, 1, 'front', 'logged_in_successfully', 'Logged in successfully', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(929, 1, 'front', 'dont_have_account', 'Don\'t have account?', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(930, 1, 'front', 'signup', 'Signup', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(931, 1, 'front', 'signup_using_email_password', 'Signup using email & password', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(932, 1, 'front', 'already_have_account', 'Already have account', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(933, 1, 'front', 'register_successfully', 'Registered successfully', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(934, 1, 'front', 'click_here_to_login', 'Click here to login', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(935, 1, 'topbar_add_button', 'add_staff_member', 'Add Staff Member', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(936, 1, 'topbar_add_button', 'add_customer', 'Add Customer', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(937, 1, 'topbar_add_button', 'add_supplier', 'Add Supplier', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(938, 1, 'topbar_add_button', 'add_brand', 'Add Brand', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(939, 1, 'topbar_add_button', 'add_category', 'Add Category', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(940, 1, 'topbar_add_button', 'add_product', 'Add Product', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(941, 1, 'topbar_add_button', 'add_sales', 'Add Sales', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(942, 1, 'topbar_add_button', 'add_purchase', 'Add Purchase', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(943, 1, 'topbar_add_button', 'add_expense_cateogory', 'Add Expense Category', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(944, 1, 'topbar_add_button', 'add_expense', 'Add Expense', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(945, 1, 'topbar_add_button', 'add_currency', 'Add Currency', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(946, 1, 'topbar_add_button', 'add_warehouse', 'Add Warehouse', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(947, 1, 'topbar_add_button', 'add_unit', 'Add Unit', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(948, 1, 'topbar_add_button', 'add_language', 'Add Language', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(949, 1, 'topbar_add_button', 'add_role', 'Add Role', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(950, 1, 'topbar_add_button', 'add_tax', 'Add Tax', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(951, 1, 'topbar_add_button', 'add_payment_mode', 'Add Payment Mode', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(952, 1, 'setup_company', 'setup_not_completed', 'Setup Not Completed', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(953, 1, 'setup_company', 'setup_not_completed_description', 'Your company default settings not completed. Follow below setups to complete your company basic settings...', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(954, 1, 'setup_company', 'warehouse', 'Warehouse', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(955, 1, 'setup_company', 'add_first_warehouse', 'Add First Warehouse', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(956, 1, 'setup_company', 'currency', 'Currency', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(957, 1, 'setup_company', 'add_first_currency', 'Add First Currency', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(958, 1, 'setup_company', 'payment_mode', 'Payment Mode', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(959, 1, 'setup_company', 'add_payment_mode', 'Add First Payment Mode', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(960, 1, 'setup_company', 'company_settings', 'Company Settings', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(961, 1, 'setup_company', 'set_company_basic_settings', 'Setup Company Basic Settings', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(962, 1, 'setup_company', 'previous_step', 'Previous Step', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(963, 1, 'setup_company', 'next_step', 'Next Step', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(964, 1, 'setup_company', 'basic_settings', 'Basic Settings', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(965, 1, 'setup_company', 'theme_settings', 'Theme Settings', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(966, 1, 'setup_company', 'logo_settings', 'Logo Settings', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(967, 1, 'setup_company', 'save_finish_setup', 'Save & Finish Setup', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(968, 1, 'setup_company', 'go_to_dashboard', 'Go To Dashboard', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(969, 1, 'setup_company', 'setup_running_message', 'Please wait... we are setting up inital company settings.', '2025-11-11 09:08:01', '2025-11-11 09:08:01'),
(970, 1, 'setup_company', 'setup_complete_message', 'Setup completed... Click on below link to view your app...', '2025-11-11 09:08:01', '2025-11-11 09:08:01');

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE `units` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `short_name` varchar(191) NOT NULL,
  `base_unit` varchar(191) DEFAULT NULL,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL,
  `operator` varchar(191) NOT NULL,
  `operator_value` varchar(191) NOT NULL,
  `is_deletable` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `units`
--

INSERT INTO `units` (`id`, `admin_id`, `company_id`, `name`, `short_name`, `base_unit`, `parent_id`, `operator`, `operator_value`, `is_deletable`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '20', 'Tw', NULL, NULL, 'multiply', '1', 1, '2025-11-11 10:58:08', '2025-11-11 10:58:08');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role` enum('superadmin','admin') NOT NULL DEFAULT 'admin',
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_superadmin` tinyint(1) NOT NULL DEFAULT 0,
  `warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `role_id` bigint(20) UNSIGNED DEFAULT NULL,
  `lang_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_type` varchar(191) NOT NULL DEFAULT 'customers',
  `is_walkin_customer` tinyint(1) NOT NULL DEFAULT 0,
  `login_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) DEFAULT NULL,
  `password` varchar(191) DEFAULT NULL,
  `phone` varchar(191) DEFAULT NULL,
  `profile_image` varchar(191) DEFAULT NULL,
  `address` varchar(1000) DEFAULT NULL,
  `shipping_address` varchar(1000) DEFAULT NULL,
  `email_verification_code` varchar(50) DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'enabled',
  `reset_code` varchar(191) DEFAULT NULL,
  `timezone` varchar(50) NOT NULL DEFAULT 'Asia/Kolkata',
  `date_format` varchar(20) NOT NULL DEFAULT 'd-m-Y',
  `date_picker_format` varchar(20) NOT NULL DEFAULT 'dd-mm-yyyy',
  `time_format` varchar(20) NOT NULL DEFAULT 'h:i a',
  `tax_number` varchar(191) DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role`, `company_id`, `is_superadmin`, `warehouse_id`, `role_id`, `lang_id`, `user_type`, `is_walkin_customer`, `login_enabled`, `name`, `email`, `password`, `phone`, `profile_image`, `address`, `shipping_address`, `email_verification_code`, `status`, `reset_code`, `timezone`, `date_format`, `date_picker_format`, `time_format`, `tax_number`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'superadmin', 1, 0, 1, 1, 1, 'staff_members', 0, 1, 'Super Admin', 'superadmin@billing.com', '$2y$10$GsQUCAtHRa3S9P9dbQv3DOtkAFqIU7fXHqA2I1a1cKtSv588aMbeW', NULL, NULL, NULL, NULL, NULL, 'enabled', NULL, 'Asia/Kolkata', 'd-m-Y', 'dd-mm-yyyy', 'h:i a', NULL, NULL, NULL, '2025-12-30 13:57:56'),
(2, 'admin', 1, 0, NULL, NULL, 1, 'customers', 1, 0, 'Walk In Customer', 'walkin@email.com', NULL, '+911111111111', NULL, 'address', 'shipping address', NULL, 'enabled', NULL, 'Asia/Kolkata', 'd-m-Y', 'dd-mm-yyyy', 'h:i a', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_address`
--

CREATE TABLE `user_address` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `address` varchar(1000) DEFAULT NULL,
  `shipping_address` varchar(1000) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `zipcode` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_details`
--

CREATE TABLE `user_details` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `opening_balance` double NOT NULL DEFAULT 0,
  `opening_balance_type` varchar(20) NOT NULL DEFAULT 'receive',
  `credit_period` int(11) NOT NULL DEFAULT 0,
  `credit_limit` double NOT NULL DEFAULT 0,
  `purchase_order_count` int(11) NOT NULL DEFAULT 0,
  `purchase_return_count` int(11) NOT NULL DEFAULT 0,
  `sales_order_count` int(11) NOT NULL DEFAULT 0,
  `sales_return_count` int(11) NOT NULL DEFAULT 0,
  `total_amount` double NOT NULL DEFAULT 0,
  `paid_amount` double NOT NULL DEFAULT 0,
  `due_amount` double NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_details`
--

INSERT INTO `user_details` (`id`, `warehouse_id`, `user_id`, `opening_balance`, `opening_balance_type`, `credit_period`, `credit_limit`, `purchase_order_count`, `purchase_return_count`, `sales_order_count`, `sales_return_count`, `total_amount`, `paid_amount`, `due_amount`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 0, 'receive', 30, 0, 0, 0, 2, 0, 530.4, 530.4, 0, '2025-11-11 10:55:19', '2025-11-11 11:05:30');

-- --------------------------------------------------------

--
-- Table structure for table `warehouses`
--

CREATE TABLE `warehouses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `logo` varchar(191) DEFAULT NULL,
  `dark_logo` varchar(191) DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) DEFAULT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `show_email_on_invoice` tinyint(1) NOT NULL DEFAULT 0,
  `show_phone_on_invoice` tinyint(1) NOT NULL DEFAULT 0,
  `address` varchar(191) DEFAULT NULL,
  `terms_condition` text DEFAULT NULL,
  `bank_details` text DEFAULT NULL,
  `signature` varchar(191) DEFAULT NULL,
  `online_store_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `customers_visibility` varchar(20) NOT NULL DEFAULT 'all',
  `suppliers_visibility` varchar(20) NOT NULL DEFAULT 'all',
  `products_visibility` varchar(20) NOT NULL DEFAULT 'all',
  `default_pos_order_status` varchar(20) NOT NULL DEFAULT 'delivered',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `warehouses`
--

INSERT INTO `warehouses` (`id`, `admin_id`, `company_id`, `logo`, `dark_logo`, `name`, `slug`, `email`, `phone`, `show_email_on_invoice`, `show_phone_on_invoice`, `address`, `terms_condition`, `bank_details`, `signature`, `online_store_enabled`, `customers_visibility`, `suppliers_visibility`, `products_visibility`, `default_pos_order_status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'warehouses_9upwilrpnz76f7okqcut.png', 'warehouses_eqsndekawoys3lgqru4f.png', 'Tanmay', 'tanmay', 'tanmay@gmail.com', '8840200147', 1, 1, 'Sainagar Mamurdi', '1. Goods once sold will not be taken back or exchanged\n2. All disputes are subject to [ENTER_YOUR_CITY_NAME] jurisdiction only', NULL, 'warehouses_iozlxdkcf0liot9jdkek.png', 1, 'all', 'all', 'all', 'delivered', '2025-11-11 10:55:19', '2025-11-11 10:55:19');

-- --------------------------------------------------------

--
-- Table structure for table `warehouse_history`
--

CREATE TABLE `warehouse_history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `date` date NOT NULL,
  `warehouse_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `order_id` bigint(20) UNSIGNED DEFAULT NULL,
  `order_item_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `expense_id` bigint(20) UNSIGNED DEFAULT NULL,
  `amount` double NOT NULL DEFAULT 0,
  `quantity` double(8,2) NOT NULL DEFAULT 0.00,
  `status` varchar(191) DEFAULT NULL,
  `type` varchar(191) DEFAULT NULL,
  `transaction_number` varchar(191) DEFAULT NULL,
  `staff_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `warehouse_stocks`
--

CREATE TABLE `warehouse_stocks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company_id` bigint(20) UNSIGNED DEFAULT NULL,
  `warehouse_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `stock_quantity` double(8,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`),
  ADD KEY `brands_company_id_foreign` (`company_id`),
  ADD KEY `brands_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categories_parent_id_foreign` (`parent_id`),
  ADD KEY `categories_company_id_foreign` (`company_id`),
  ADD KEY `categories_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `companies`
--
ALTER TABLE `companies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `companies_currency_id_foreign` (`currency_id`),
  ADD KEY `companies_lang_id_foreign` (`lang_id`),
  ADD KEY `companies_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `companies_subscription_plan_id_foreign` (`subscription_plan_id`),
  ADD KEY `companies_stripe_id_index` (`stripe_id`);

--
-- Indexes for table `currencies`
--
ALTER TABLE `currencies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `currencies_company_id_foreign` (`company_id`);

--
-- Indexes for table `custom_fields`
--
ALTER TABLE `custom_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `custom_fields_company_id_foreign` (`company_id`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expenses_expense_category_id_foreign` (`expense_category_id`),
  ADD KEY `expenses_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `expenses_user_id_foreign` (`user_id`),
  ADD KEY `expenses_company_id_foreign` (`company_id`),
  ADD KEY `expenses_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `expense_categories`
--
ALTER TABLE `expense_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expense_categories_company_id_foreign` (`company_id`),
  ADD KEY `expense_categories_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `front_product_cards`
--
ALTER TABLE `front_product_cards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `front_product_cards_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `front_product_cards_company_id_foreign` (`company_id`);

--
-- Indexes for table `front_website_settings`
--
ALTER TABLE `front_website_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `front_website_settings_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `front_website_settings_company_id_foreign` (`company_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `langs`
--
ALTER TABLE `langs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `orders_user_id_foreign` (`user_id`),
  ADD KEY `orders_tax_id_foreign` (`tax_id`),
  ADD KEY `orders_staff_user_id_foreign` (`staff_user_id`),
  ADD KEY `orders_cancelled_by_foreign` (`cancelled_by`),
  ADD KEY `orders_from_warehouse_id_foreign` (`from_warehouse_id`),
  ADD KEY `orders_company_id_foreign` (`company_id`),
  ADD KEY `orders_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `order_custom_fields`
--
ALTER TABLE `order_custom_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_custom_fields_order_id_foreign` (`order_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_user_id_foreign` (`user_id`),
  ADD KEY `order_items_order_id_foreign` (`order_id`),
  ADD KEY `order_items_product_id_foreign` (`product_id`),
  ADD KEY `order_items_unit_id_foreign` (`unit_id`),
  ADD KEY `order_items_tax_id_foreign` (`tax_id`);

--
-- Indexes for table `order_payments`
--
ALTER TABLE `order_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_payments_payment_id_foreign` (`payment_id`),
  ADD KEY `order_payments_order_id_foreign` (`order_id`),
  ADD KEY `order_payments_company_id_foreign` (`company_id`),
  ADD KEY `order_payments_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `order_shipping_address`
--
ALTER TABLE `order_shipping_address`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_shipping_address_order_id_foreign` (`order_id`),
  ADD KEY `order_shipping_address_company_id_foreign` (`company_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `payments_payment_mode_id_foreign` (`payment_mode_id`),
  ADD KEY `payments_user_id_foreign` (`user_id`),
  ADD KEY `payments_staff_user_id_foreign` (`staff_user_id`),
  ADD KEY `payments_company_id_foreign` (`company_id`),
  ADD KEY `payments_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `payment_modes`
--
ALTER TABLE `payment_modes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payment_modes_company_id_foreign` (`company_id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `permission_role_role_id_foreign` (`role_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `products_category_id_foreign` (`category_id`),
  ADD KEY `products_brand_id_foreign` (`brand_id`),
  ADD KEY `products_unit_id_foreign` (`unit_id`),
  ADD KEY `products_user_id_foreign` (`user_id`),
  ADD KEY `products_company_id_foreign` (`company_id`),
  ADD KEY `products_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `products_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `product_custom_fields`
--
ALTER TABLE `product_custom_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_custom_fields_product_id_foreign` (`product_id`),
  ADD KEY `product_custom_fields_warehouse_id_foreign` (`warehouse_id`);

--
-- Indexes for table `product_details`
--
ALTER TABLE `product_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_details_product_id_foreign` (`product_id`),
  ADD KEY `product_details_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `product_details_tax_id_foreign` (`tax_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `roles_company_id_foreign` (`company_id`);

--
-- Indexes for table `role_user`
--
ALTER TABLE `role_user`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `role_user_role_id_foreign` (`role_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `settings_company_id_foreign` (`company_id`);

--
-- Indexes for table `stock_adjustments`
--
ALTER TABLE `stock_adjustments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stock_adjustments_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `stock_adjustments_product_id_foreign` (`product_id`),
  ADD KEY `stock_adjustments_created_by_foreign` (`created_by`),
  ADD KEY `stock_adjustments_company_id_foreign` (`company_id`),
  ADD KEY `stock_adjustments_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `stock_history`
--
ALTER TABLE `stock_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stock_history_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `stock_history_product_id_foreign` (`product_id`),
  ADD KEY `stock_history_created_by_foreign` (`created_by`),
  ADD KEY `stock_history_company_id_foreign` (`company_id`),
  ADD KEY `stock_history_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `taxes`
--
ALTER TABLE `taxes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `taxes_company_id_foreign` (`company_id`),
  ADD KEY `taxes_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `translations`
--
ALTER TABLE `translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `translations_lang_id_foreign` (`lang_id`);

--
-- Indexes for table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`id`),
  ADD KEY `units_parent_id_foreign` (`parent_id`),
  ADD KEY `units_company_id_foreign` (`company_id`),
  ADD KEY `units_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `users_company_id_foreign` (`company_id`),
  ADD KEY `users_created_by_foreign` (`created_by`),
  ADD KEY `users_lang_id_foreign` (`lang_id`);

--
-- Indexes for table `user_address`
--
ALTER TABLE `user_address`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_address_user_id_foreign` (`user_id`),
  ADD KEY `user_address_company_id_foreign` (`company_id`);

--
-- Indexes for table `user_details`
--
ALTER TABLE `user_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_details_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `user_details_user_id_foreign` (`user_id`);

--
-- Indexes for table `warehouses`
--
ALTER TABLE `warehouses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `warehouses_company_id_foreign` (`company_id`),
  ADD KEY `warehouses_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `warehouse_history`
--
ALTER TABLE `warehouse_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `warehouse_history_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `warehouse_history_user_id_foreign` (`user_id`),
  ADD KEY `warehouse_history_order_id_foreign` (`order_id`),
  ADD KEY `warehouse_history_order_item_id_foreign` (`order_item_id`),
  ADD KEY `warehouse_history_product_id_foreign` (`product_id`),
  ADD KEY `warehouse_history_payment_id_foreign` (`payment_id`),
  ADD KEY `warehouse_history_expense_id_foreign` (`expense_id`),
  ADD KEY `warehouse_history_staff_user_id_foreign` (`staff_user_id`),
  ADD KEY `warehouse_history_company_id_foreign` (`company_id`);

--
-- Indexes for table `warehouse_stocks`
--
ALTER TABLE `warehouse_stocks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `warehouse_stocks_warehouse_id_foreign` (`warehouse_id`),
  ADD KEY `warehouse_stocks_product_id_foreign` (`product_id`),
  ADD KEY `warehouse_stocks_company_id_foreign` (`company_id`),
  ADD KEY `warehouse_stocks_admin_id_foreign` (`admin_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `brands`
--
ALTER TABLE `brands`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `companies`
--
ALTER TABLE `companies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `currencies`
--
ALTER TABLE `currencies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `custom_fields`
--
ALTER TABLE `custom_fields`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `expense_categories`
--
ALTER TABLE `expense_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `front_product_cards`
--
ALTER TABLE `front_product_cards`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `front_website_settings`
--
ALTER TABLE `front_website_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `langs`
--
ALTER TABLE `langs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `order_custom_fields`
--
ALTER TABLE `order_custom_fields`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `order_payments`
--
ALTER TABLE `order_payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `order_shipping_address`
--
ALTER TABLE `order_shipping_address`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `payment_modes`
--
ALTER TABLE `payment_modes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `product_custom_fields`
--
ALTER TABLE `product_custom_fields`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_details`
--
ALTER TABLE `product_details`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `stock_adjustments`
--
ALTER TABLE `stock_adjustments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `stock_history`
--
ALTER TABLE `stock_history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `taxes`
--
ALTER TABLE `taxes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `translations`
--
ALTER TABLE `translations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=971;

--
-- AUTO_INCREMENT for table `units`
--
ALTER TABLE `units`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user_address`
--
ALTER TABLE `user_address`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_details`
--
ALTER TABLE `user_details`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `warehouses`
--
ALTER TABLE `warehouses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `warehouse_history`
--
ALTER TABLE `warehouse_history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `warehouse_stocks`
--
ALTER TABLE `warehouse_stocks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `brands`
--
ALTER TABLE `brands`
  ADD CONSTRAINT `brands_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `brands_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `categories_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `categories_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `companies`
--
ALTER TABLE `companies`
  ADD CONSTRAINT `companies_currency_id_foreign` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `companies_lang_id_foreign` FOREIGN KEY (`lang_id`) REFERENCES `langs` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `companies_subscription_plan_id_foreign` FOREIGN KEY (`subscription_plan_id`) REFERENCES `subscription_plans` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `companies_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `currencies`
--
ALTER TABLE `currencies`
  ADD CONSTRAINT `currencies_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `custom_fields`
--
ALTER TABLE `custom_fields`
  ADD CONSTRAINT `custom_fields_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `expenses`
--
ALTER TABLE `expenses`
  ADD CONSTRAINT `expenses_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `expenses_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `expenses_expense_category_id_foreign` FOREIGN KEY (`expense_category_id`) REFERENCES `expense_categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `expenses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `expenses_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `expense_categories`
--
ALTER TABLE `expense_categories`
  ADD CONSTRAINT `expense_categories_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `expense_categories_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `front_product_cards`
--
ALTER TABLE `front_product_cards`
  ADD CONSTRAINT `front_product_cards_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `front_product_cards_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `front_website_settings`
--
ALTER TABLE `front_website_settings`
  ADD CONSTRAINT `front_website_settings_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `front_website_settings_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_cancelled_by_foreign` FOREIGN KEY (`cancelled_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_from_warehouse_id_foreign` FOREIGN KEY (`from_warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_staff_user_id_foreign` FOREIGN KEY (`staff_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_tax_id_foreign` FOREIGN KEY (`tax_id`) REFERENCES `taxes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `order_custom_fields`
--
ALTER TABLE `order_custom_fields`
  ADD CONSTRAINT `order_custom_fields_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_items_tax_id_foreign` FOREIGN KEY (`tax_id`) REFERENCES `taxes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `order_items_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `order_items_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `order_payments`
--
ALTER TABLE `order_payments`
  ADD CONSTRAINT `order_payments_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_payments_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_payments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_payments_payment_id_foreign` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `order_shipping_address`
--
ALTER TABLE `order_shipping_address`
  ADD CONSTRAINT `order_shipping_address_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_shipping_address_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `payments_payment_mode_id_foreign` FOREIGN KEY (`payment_mode_id`) REFERENCES `payment_modes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `payments_staff_user_id_foreign` FOREIGN KEY (`staff_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `payments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `payments_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payment_modes`
--
ALTER TABLE `payment_modes`
  ADD CONSTRAINT `payment_modes_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD CONSTRAINT `permission_role_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permission_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `products_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `products_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `products_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `products_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `products_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `products` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `product_custom_fields`
--
ALTER TABLE `product_custom_fields`
  ADD CONSTRAINT `product_custom_fields_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `product_custom_fields_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `product_details`
--
ALTER TABLE `product_details`
  ADD CONSTRAINT `product_details_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `product_details_tax_id_foreign` FOREIGN KEY (`tax_id`) REFERENCES `taxes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `product_details_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `roles`
--
ALTER TABLE `roles`
  ADD CONSTRAINT `roles_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `role_user`
--
ALTER TABLE `role_user`
  ADD CONSTRAINT `role_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `role_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `settings`
--
ALTER TABLE `settings`
  ADD CONSTRAINT `settings_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `stock_adjustments`
--
ALTER TABLE `stock_adjustments`
  ADD CONSTRAINT `stock_adjustments_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `stock_adjustments_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_adjustments_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_adjustments_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_adjustments_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `stock_history`
--
ALTER TABLE `stock_history`
  ADD CONSTRAINT `stock_history_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `stock_history_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_history_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_history_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_history_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `taxes`
--
ALTER TABLE `taxes`
  ADD CONSTRAINT `taxes_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `taxes_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `translations`
--
ALTER TABLE `translations`
  ADD CONSTRAINT `translations_lang_id_foreign` FOREIGN KEY (`lang_id`) REFERENCES `langs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `units`
--
ALTER TABLE `units`
  ADD CONSTRAINT `units_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `units_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `units_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `users_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `users_lang_id_foreign` FOREIGN KEY (`lang_id`) REFERENCES `langs` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `users_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_address`
--
ALTER TABLE `user_address`
  ADD CONSTRAINT `user_address_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_address_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_details`
--
ALTER TABLE `user_details`
  ADD CONSTRAINT `user_details_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_details_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `warehouses`
--
ALTER TABLE `warehouses`
  ADD CONSTRAINT `warehouses_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `warehouses_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `warehouse_history`
--
ALTER TABLE `warehouse_history`
  ADD CONSTRAINT `warehouse_history_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `warehouse_history_expense_id_foreign` FOREIGN KEY (`expense_id`) REFERENCES `expenses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `warehouse_history_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `warehouse_history_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `warehouse_history_payment_id_foreign` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `warehouse_history_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `warehouse_history_staff_user_id_foreign` FOREIGN KEY (`staff_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `warehouse_history_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `warehouse_history_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `warehouse_stocks`
--
ALTER TABLE `warehouse_stocks`
  ADD CONSTRAINT `warehouse_stocks_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `warehouse_stocks_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `warehouse_stocks_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `warehouse_stocks_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
