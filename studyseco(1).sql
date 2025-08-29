-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 29, 2025 at 03:01 PM
-- Server version: 8.0.30
-- PHP Version: 8.3.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `studyseco`
--

-- --------------------------------------------------------

--
-- Table structure for table `access_durations`
--

CREATE TABLE `access_durations` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `days` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `achievements`
--

CREATE TABLE `achievements` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `level` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `points` int NOT NULL DEFAULT '0',
  `criteria_met` json DEFAULT NULL,
  `badge_icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `badge_color` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#3B82F6',
  `achieved_date` date NOT NULL,
  `awarded_by` bigint UNSIGNED NOT NULL,
  `awarding_notes` text COLLATE utf8mb4_unicode_ci,
  `is_public` tinyint(1) NOT NULL DEFAULT '1',
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `display_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `chat_groups`
--

CREATE TABLE `chat_groups` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'subject',
  `subject_id` bigint UNSIGNED DEFAULT NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `max_members` int NOT NULL DEFAULT '50',
  `allowed_topics` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_moderated` tinyint(1) NOT NULL DEFAULT '1',
  `moderator_settings` json DEFAULT NULL,
  `last_activity_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `chat_group_user`
--

CREATE TABLE `chat_group_user` (
  `id` bigint UNSIGNED NOT NULL,
  `chat_group_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'member',
  `joined_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_read_at` timestamp NULL DEFAULT NULL,
  `is_muted` tinyint(1) NOT NULL DEFAULT '0',
  `notification_settings` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `chat_messages`
--

CREATE TABLE `chat_messages` (
  `id` bigint UNSIGNED NOT NULL,
  `chat_group_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text',
  `attachments` json DEFAULT NULL,
  `reply_to` bigint UNSIGNED DEFAULT NULL,
  `is_edited` tinyint(1) NOT NULL DEFAULT '0',
  `edited_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `reactions` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `id` bigint UNSIGNED NOT NULL,
  `enrollment_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verification_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_verification_code` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_verified_at` timestamp NULL DEFAULT NULL,
  `verification_expires_at` timestamp NULL DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT '0',
  `address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MWK',
  `price_per_subject` decimal(10,2) DEFAULT NULL,
  `subject_count` int NOT NULL DEFAULT '0',
  `selected_subjects` json NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_reference` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_proof_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `is_trial` tinyint(1) NOT NULL DEFAULT '0',
  `trial_started_at` timestamp NULL DEFAULT NULL,
  `trial_expires_at` timestamp NULL DEFAULT NULL,
  `access_expires_at` timestamp NULL DEFAULT NULL,
  `admin_notes` text COLLATE utf8mb4_unicode_ci,
  `approved_at` timestamp NULL DEFAULT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`id`, `enrollment_number`, `name`, `email`, `email_verification_token`, `email_verified_at`, `phone`, `phone_verification_code`, `phone_verified_at`, `verification_expires_at`, `is_verified`, `address`, `country`, `region`, `currency`, `price_per_subject`, `subject_count`, `selected_subjects`, `total_amount`, `payment_method`, `payment_reference`, `payment_proof_path`, `status`, `is_trial`, `trial_started_at`, `trial_expires_at`, `access_expires_at`, `admin_notes`, `approved_at`, `user_id`, `created_at`, `updated_at`, `approved_by`) VALUES
(1, 'ENR2025000001', 'Emmanuel Phiri', 'xtreamcoder2013@gmail.com', NULL, NULL, '+27686518342', NULL, NULL, NULL, 0, 'Durban, South Africa', 'South Africa', 'south_africa', 'ZAR', NULL, 0, '[1]', 0.00, 'trial', 'TRIAL_68B17D52A9CF2', NULL, 'approved', 1, '2025-08-29 09:13:38', '2025-09-05 09:13:38', '2025-09-05 09:13:38', NULL, NULL, NULL, '2025-08-29 09:13:38', '2025-08-29 09:13:38', NULL),
(2, 'ENR2025000002', 'Manzy', 'phirimsa@gmail.com', NULL, NULL, '+27686518367', NULL, NULL, NULL, 0, 'Durban, South Africa', 'South Africa', 'south_africa', 'ZAR', NULL, 0, '[1, 2, 6, 3]', 0.00, 'trial', 'TRIAL_68B19EE66167D', NULL, 'approved', 1, '2025-08-29 11:36:54', '2025-09-05 11:36:54', '2025-09-05 11:36:54', NULL, NULL, NULL, '2025-08-29 11:36:54', '2025-08-29 11:36:54', NULL),
(3, 'ENR2025000003', 'Emmanuel Phiri', 'james@gmail.com', 'ptmfNkt5l1NdAck5GDgh5HImLCFsxHCIGdGVOMSx5u5RtqF7A3UUIcDrzs8b', NULL, '+2768651567', NULL, NULL, '2025-08-29 13:49:15', 0, 'Durban, South Africa', 'Malawi', 'malawi', 'MWK', NULL, 0, '[\"6\", \"7\"]', 100000.00, 'tnm_mpamba', '454544645654', 'payment_proofs/nv8p9ncsTFIPwLO0gb1O2y6hbh0c6OMGYqzOSB6a.png', 'approved', 0, NULL, NULL, '2025-12-27 14:38:59', NULL, '2025-08-29 13:51:16', 7, '2025-08-29 13:38:59', '2025-08-29 13:51:17', 1);

-- --------------------------------------------------------

--
-- Table structure for table `enrollment_payments`
--

CREATE TABLE `enrollment_payments` (
  `id` bigint UNSIGNED NOT NULL,
  `enrollment_id` bigint UNSIGNED NOT NULL,
  `payment_method_id` bigint UNSIGNED NOT NULL,
  `reference_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `currency` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_proof_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_details` text COLLATE utf8mb4_unicode_ci,
  `payment_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'enrollment',
  `extension_months` int DEFAULT NULL,
  `status` enum('pending','processing','verified','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `admin_notes` text COLLATE utf8mb4_unicode_ci,
  `verified_at` timestamp NULL DEFAULT NULL,
  `verified_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `enrollment_payments`
--

INSERT INTO `enrollment_payments` (`id`, `enrollment_id`, `payment_method_id`, `reference_number`, `amount`, `currency`, `payment_proof_path`, `payment_details`, `payment_type`, `extension_months`, `status`, `admin_notes`, `verified_at`, `verified_by`, `created_at`, `updated_at`) VALUES
(1, 3, 12, '454544645654', 100000.00, 'MWK', 'payment_proofs/nv8p9ncsTFIPwLO0gb1O2y6hbh0c6OMGYqzOSB6a.png', NULL, 'enrollment', NULL, 'verified', NULL, NULL, NULL, '2025-08-29 13:38:59', '2025-08-29 13:51:16');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lessons`
--

CREATE TABLE `lessons` (
  `id` bigint UNSIGNED NOT NULL,
  `topic_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `video_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `video_filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration_minutes` int DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `order_index` int NOT NULL DEFAULT '0',
  `is_published` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_08_20_115037_add_role_column_to_users_table', 1),
(5, '2025_08_26_103456_create_subjects_table', 1),
(6, '2025_08_26_103457_create_topics_table', 1),
(7, '2025_08_26_103458_create_lessons_table', 1),
(8, '2025_08_26_113200_create_payments_table', 1),
(9, '2025_08_26_115607_create_payment_methods_table', 1),
(10, '2025_08_26_115627_create_access_durations_table', 1),
(11, '2025_08_26_160550_create_enrollments_table', 1),
(12, '2025_08_26_182634_create_site_contents_table', 1),
(13, '2025_08_26_182651_create_student_stories_table', 1),
(14, '2025_08_27_082205_create_enrollment_payments_table', 1),
(15, '2025_08_27_082517_modify_payment_methods_table', 1),
(16, '2025_08_27_100643_create_system_settings_table', 1),
(17, '2025_08_27_140411_add_extension_fields_to_enrollment_payments_table', 1),
(18, '2025_08_27_142000_add_malawi_curriculum_fields_to_subjects_table', 1),
(19, '2025_08_27_145707_create_notifications_table', 1),
(20, '2025_08_27_145730_add_verification_fields_to_enrollments_table', 1),
(21, '2025_08_28_120330_create_permissions_table', 1),
(22, '2025_08_28_120336_create_roles_table', 1),
(23, '2025_08_28_120342_create_role_user_table', 1),
(24, '2025_08_28_120347_create_permission_role_table', 1),
(25, '2025_08_28_120353_add_permissions_fields_to_users_table', 1),
(26, '2025_08_28_120815_create_chat_groups_table', 1),
(27, '2025_08_28_120816_create_chat_group_user_table', 1),
(28, '2025_08_28_120817_create_chat_messages_table', 1),
(29, '2025_08_28_121630_create_books_table', 1),
(30, '2025_08_28_121630_create_past_papers_table', 1),
(31, '2025_08_28_121630_create_resources_table', 1),
(32, '2025_08_28_122728_create_achievements_table', 1),
(33, '2025_08_28_123339_create_teacher_assignments_table', 1),
(34, '2025_08_28_185352_add_missing_fields_to_enrollments_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_id` bigint UNSIGNED NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `past_papers`
--

CREATE TABLE `past_papers` (
  `id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `payment_method` enum('tnm_mpamba','airtel_money','bank_transfer') COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `reference_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `proof_screenshot` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `access_duration_days` int NOT NULL DEFAULT '30',
  `access_expires_at` date DEFAULT NULL,
  `admin_notes` text COLLATE utf8mb4_unicode_ci,
  `verified_by` bigint UNSIGNED DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment_methods`
--

CREATE TABLE `payment_methods` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `region` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `instructions` text COLLATE utf8mb4_unicode_ci,
  `requirements` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment_methods`
--

INSERT INTO `payment_methods` (`id`, `name`, `code`, `type`, `region`, `currency`, `instructions`, `requirements`, `is_active`, `sort_order`, `created_at`, `updated_at`) VALUES
(12, 'TNM Mpamba', 'tnm_mpamba', 'mobile_money', 'malawi', 'MWK', 'Send payment to 0991234567. Use your enrollment number as reference.', '[\"reference_number\", \"screenshot\"]', 1, 1, '2025-08-29 13:18:12', '2025-08-29 13:18:12'),
(13, 'Airtel Money', 'airtel_money', 'mobile_money', 'malawi', 'MWK', 'Send payment to 0991234568. Use your enrollment number as reference.', '[\"reference_number\", \"screenshot\"]', 1, 2, '2025-08-29 13:18:12', '2025-08-29 13:18:12'),
(14, 'Bank Transfer', 'bank_transfer', 'bank', 'malawi', 'MWK', 'Transfer to Account: StudySeco Ltd, Account Number: 123456789, Bank: Standard Bank Malawi. Use enrollment number as reference.', '[\"reference_number\", \"bank_slip\"]', 1, 3, '2025-08-29 13:18:12', '2025-08-29 13:18:12'),
(15, 'Mukuru', 'mukuru', 'remittance', 'south_africa', 'ZAR', 'Send payment through Mukuru to StudySeco Ltd. Contact support for collection details.', '[\"reference_number\", \"receipt\"]', 1, 10, '2025-08-29 13:18:12', '2025-08-29 13:18:12'),
(16, 'Hello Paisa', 'hello_paisa', 'digital_wallet', 'south_africa', 'ZAR', 'Send payment through Hello Paisa to StudySeco account.', '[\"reference_number\", \"screenshot\"]', 1, 11, '2025-08-29 13:18:12', '2025-08-29 13:18:12'),
(17, 'WorldRemit', 'worldremit', 'remittance', 'international', 'USD', 'Send payment through WorldRemit to StudySeco Ltd, Malawi. Contact support for recipient details.', '[\"reference_number\", \"receipt\"]', 1, 20, '2025-08-29 13:18:12', '2025-08-29 13:18:12'),
(18, 'Remitly', 'remitly', 'remittance', 'international', 'USD', 'Send payment through Remitly to StudySeco Ltd, Malawi. Contact support for recipient details.', '[\"reference_number\", \"receipt\"]', 1, 21, '2025-08-29 13:18:12', '2025-08-29 13:18:12'),
(19, 'Western Union', 'western_union', 'remittance', 'international', 'USD', 'Send payment through Western Union to StudySeco Ltd, Malawi. Contact support for recipient details.', '[\"reference_number\", \"mtcn\"]', 1, 22, '2025-08-29 13:18:12', '2025-08-29 13:18:12'),
(20, 'MoneyGram', 'moneygram', 'remittance', 'international', 'USD', 'Send payment through MoneyGram to StudySeco Ltd, Malawi. Contact support for recipient details.', '[\"reference_number\", \"receipt\"]', 1, 23, '2025-08-29 13:18:12', '2025-08-29 13:18:12'),
(21, 'PayPal', 'paypal', 'digital_wallet', 'international', 'USD', 'Send payment to payments@studyseco.com through PayPal. Include enrollment number in notes.', '[\"transaction_id\", \"screenshot\"]', 1, 24, '2025-08-29 13:18:12', '2025-08-29 13:18:12');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'general',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permission_role`
--

CREATE TABLE `permission_role` (
  `id` bigint UNSIGNED NOT NULL,
  `permission_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE `resources` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject_id` bigint UNSIGNED DEFAULT NULL,
  `grade_level` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exam_board` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `year` int DEFAULT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` bigint DEFAULT NULL,
  `thumbnail` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `access_permissions` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_protected` tinyint(1) NOT NULL DEFAULT '1',
  `protection_settings` json DEFAULT NULL,
  `view_count` int NOT NULL DEFAULT '0',
  `download_attempts` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `priority` int NOT NULL DEFAULT '1',
  `dashboard_features` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `role_user`
--

CREATE TABLE `role_user` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `assigned_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `site_contents`
--

CREATE TABLE `site_contents` (
  `id` bigint UNSIGNED NOT NULL,
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_data` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student_stories`
--

CREATE TABLE `student_stories` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_flag` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `story` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `achievements` json DEFAULT NULL,
  `msce_credits` int DEFAULT NULL,
  `avatar_color_from` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar_color_to` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `achievement_icon` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `department` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `grade_level` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `credits` int NOT NULL DEFAULT '1',
  `teacher_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cover_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_compulsory` tinyint(1) NOT NULL DEFAULT '0',
  `subject_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`id`, `name`, `code`, `description`, `department`, `grade_level`, `credits`, `teacher_name`, `cover_image`, `is_active`, `is_compulsory`, `subject_type`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'English', 'ENG', 'English Language and Communication Skills - essential for all forms of communication and academic success', 'Languages', 'Forms 1-4', 1, NULL, NULL, 1, 1, 'core', 1, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(2, 'Chichewa', 'CHI', 'National language of Malawi - preserving cultural heritage and local communication', 'Languages', 'Forms 1-4', 1, NULL, NULL, 1, 1, 'core', 2, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(3, 'Mathematics', 'MATH', 'Pure and Applied Mathematics - building logical thinking and problem-solving skills', 'Sciences', 'Forms 1-4', 1, NULL, NULL, 1, 1, 'core', 3, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(4, 'Life Skills', 'LS', 'Personal development, health education, and practical life skills', 'General Studies', 'Forms 1-2', 1, NULL, NULL, 1, 1, 'core', 4, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(5, 'Biology', 'BIO', 'Study of living organisms and life processes - foundation for medical and biological sciences', 'Sciences', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'science', 5, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(6, 'Physical Science', 'PHYS', 'Integrated Physics and Chemistry for Forms 1-2 - building scientific foundation', 'Sciences', 'Forms 1-2', 1, NULL, NULL, 1, 0, 'science', 6, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(7, 'Chemistry', 'CHEM', 'Study of matter, its properties and reactions - essential for pharmaceutical and chemical industries', 'Sciences', 'Forms 3-4', 1, NULL, NULL, 1, 0, 'science', 7, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(8, 'Physics', 'PHY', 'Study of matter, energy and their interactions - foundation for engineering and technology', 'Sciences', 'Forms 3-4', 1, NULL, NULL, 1, 0, 'science', 8, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(9, 'Geography', 'GEO', 'Physical and human geography of Malawi and the world - understanding our environment', 'Humanities', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'humanities', 9, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(10, 'History', 'HIST', 'Malawian, African and World History - understanding our past to shape the future', 'Humanities', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'humanities', 10, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(11, 'Social Studies', 'SS', 'Civic education, government and society - preparing responsible citizens', 'Humanities', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'humanities', 11, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(12, 'Bible Knowledge', 'BK', 'Christian religious education and moral values', 'Humanities', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'humanities', 12, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(13, 'Agriculture', 'AGR', 'Agricultural practices, crop production and livestock management - vital for Malawi\'s economy', 'Technical', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'technical', 13, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(14, 'Home Economics', 'HE', 'Food and nutrition, family management, and household skills', 'Technical', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'technical', 14, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(15, 'Technical Drawing', 'TD', 'Engineering drawing and design fundamentals - foundation for engineering careers', 'Technical', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'technical', 15, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(16, 'Business Studies', 'BS', 'Entrepreneurship, business management and commercial practices', 'Commerce', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'commerce', 16, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(17, 'French', 'FR', 'French language and culture - opening opportunities for international communication', 'Languages', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'language', 17, '2025-08-29 08:41:53', '2025-08-29 08:41:53'),
(18, 'Computer Studies', 'CS', 'Basic computer literacy, programming fundamentals and digital literacy', 'Technology', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'technology', 18, '2025-08-29 08:41:53', '2025-08-29 08:41:53');

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

CREATE TABLE `system_settings` (
  `id` bigint UNSIGNED NOT NULL,
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text',
  `group` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'general',
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `system_settings`
--

INSERT INTO `system_settings` (`id`, `key`, `name`, `value`, `type`, `group`, `description`, `created_at`, `updated_at`) VALUES
(1, 'email_verification_required', 'Email Verification Required', '0', 'boolean', 'verification', 'Require email verification for student enrollment', '2025-08-29 08:34:30', '2025-08-29 13:41:06'),
(2, 'phone_verification_required', 'Phone Verification Required', '0', 'boolean', 'verification', 'Require phone verification for student enrollment', '2025-08-29 08:34:30', '2025-08-29 13:41:06'),
(3, 'verification_for_trial', 'Verification Required for Trial', '0', 'boolean', 'verification', 'Require verification even for free trials', '2025-08-29 08:34:30', '2025-08-29 08:34:30'),
(4, 'verification_for_paid', 'Verification Required for Paid', '0', 'boolean', 'verification', 'Require verification for paid enrollments', '2025-08-29 08:34:30', '2025-08-29 13:41:06'),
(5, 'favicon_url', 'Favicon URL', '/favicon.ico', 'image', 'appearance', 'Browser favicon', '2025-08-29 08:49:53', '2025-08-29 08:49:53'),
(6, 'app_name', 'Application Name', 'StudySeco', 'text', 'general', 'The name of your application', '2025-08-29 08:49:53', '2025-08-29 13:46:54'),
(7, 'app_description', 'Application Description', 'Excellence in Malawian Secondary Education - Comprehensive online learning platform', 'text', 'general', 'Short description of your application', '2025-08-29 08:56:21', '2025-08-29 08:56:21'),
(8, 'app_tagline', 'Application Tagline', 'Unlock Your Potential with StudySeco', 'text', 'general', 'Catchy tagline for your application', '2025-08-29 08:56:21', '2025-08-29 08:56:21'),
(9, 'contact_email', 'Contact Email', 'info@studyseco.com', 'email', 'contact', 'Main contact email address', '2025-08-29 08:56:21', '2025-08-29 08:56:21'),
(10, 'contact_phone', 'Contact Phone', '+265 123 456 789', 'text', 'contact', 'Main contact phone number', '2025-08-29 08:56:21', '2025-08-29 08:56:21'),
(11, 'contact_address', 'Contact Address', 'Lilongwe, Malawi', 'textarea', 'contact', 'Physical address', '2025-08-29 08:56:21', '2025-08-29 08:56:21'),
(12, 'social_facebook', 'Facebook URL', 'https://facebook.com/studyseco', 'url', 'contact', 'Facebook page URL', '2025-08-29 08:56:21', '2025-08-29 08:56:21'),
(13, 'social_twitter', 'Twitter URL', 'https://twitter.com/studyseco', 'url', 'contact', 'Twitter profile URL', '2025-08-29 08:56:21', '2025-08-29 08:56:21'),
(14, 'logo_url', 'Logo URL', '/images/logo.png', 'image', 'appearance', 'Main application logo', '2025-08-29 08:56:21', '2025-08-29 08:56:21'),
(15, 'primary_color', 'Primary Color', '#3B82F6', 'color', 'appearance', 'Primary brand color', '2025-08-29 08:56:21', '2025-08-29 08:56:21'),
(16, 'footer_text', 'Footer Text', '© 2024 StudySeco. All rights reserved. Excellence in Malawian Secondary Education.', 'textarea', 'footer', 'Footer copyright text', '2025-08-29 08:56:21', '2025-08-29 08:56:21'),
(17, 'footer_links', 'Footer Links', '[{\"name\":\"Privacy Policy\",\"url\":\"\\/privacy\"},{\"name\":\"Terms of Service\",\"url\":\"\\/terms\"},{\"name\":\"Contact Us\",\"url\":\"\\/contact\"}]', 'json', 'footer', 'Footer navigation links', '2025-08-29 08:56:21', '2025-08-29 08:56:21'),
(18, 'academic_year', 'Current Academic Year', '2024/2025', 'text', 'academic', 'Current academic year', '2025-08-29 08:56:21', '2025-08-29 08:56:21'),
(19, 'grade_levels', 'Grade Levels', '[\"Form 1\",\"Form 2\",\"Form 3\",\"Form 4\"]', 'json', 'academic', 'Available grade levels', '2025-08-29 08:56:21', '2025-08-29 08:56:21');

-- --------------------------------------------------------

--
-- Table structure for table `teacher_assignments`
--

CREATE TABLE `teacher_assignments` (
  `id` bigint UNSIGNED NOT NULL,
  `teacher_id` bigint UNSIGNED NOT NULL,
  `student_id` bigint UNSIGNED NOT NULL,
  `subject_id` bigint UNSIGNED NOT NULL,
  `assignment_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'automatic',
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `priority_score` int NOT NULL DEFAULT '0',
  `assignment_criteria` json DEFAULT NULL,
  `assigned_date` date NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `assigned_by` bigint UNSIGNED DEFAULT NULL,
  `assignment_notes` text COLLATE utf8mb4_unicode_ci,
  `performance_metrics` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `last_interaction_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `topics`
--

CREATE TABLE `topics` (
  `id` bigint UNSIGNED NOT NULL,
  `subject_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `order_index` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'student',
  `custom_permissions` json DEFAULT NULL,
  `dashboard_preferences` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `last_login_at` timestamp NULL DEFAULT NULL,
  `profile_photo_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `custom_permissions`, `dashboard_preferences`, `is_active`, `last_login_at`, `profile_photo_url`, `phone`, `bio`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin User', 'admin@example.com', NULL, '$2y$12$7McQEC/BPX.1tbSkpWMG.OGDiM95mU5esURI74E4WUfdjdIU6GqDG', 'admin', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '2025-08-29 08:33:44', '2025-08-29 08:33:44'),
(2, 'Teacher User', 'teacher@example.com', NULL, '$2y$12$UDn0xImO8.LkCsZkzLqXxuE.Mf3vsNByQVCv/4npj0k1v62qBnbf6', 'teacher', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '2025-08-29 08:33:44', '2025-08-29 08:33:44'),
(3, 'Student User', 'student@example.com', NULL, '$2y$12$HHSC3BNaeQXrT1KMM3kxUeAGJGmDYYvPSc0AM.dwMYho2MoQqHGB2', 'student', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '2025-08-29 08:33:44', '2025-08-29 08:33:44'),
(4, 'Admin User', 'admin@studyseco.com', NULL, '$2y$12$zvd2VtXIn0hhhSQZmrHVpOgBBI3bou/odyHfxvyhsh4JAyTYnAjU2', 'admin', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '2025-08-29 08:34:13', '2025-08-29 08:34:13'),
(5, 'Emmanuel Phiri', 'xtreamcoder2013@gmail.com', NULL, '$2y$12$VrYAc66c5j27Z/e/UYKELu1NJRWpRYbLxBd9rb0UF5iu0UF56bNXW', 'student', NULL, NULL, 1, NULL, NULL, '+27686518342', NULL, NULL, '2025-08-29 09:13:38', '2025-08-29 09:22:15'),
(6, 'Manzy', 'phirimsa@gmail.com', NULL, '$2y$12$zdBKYb.3BXuQ.yOdhBu6peUgLUzeJ0J.5AHmqRomdLFhU5CE8S3oS', 'student', NULL, NULL, 1, NULL, NULL, '+27686518367', NULL, NULL, '2025-08-29 11:36:54', '2025-08-29 11:36:54'),
(7, 'Emmanuel Phiri', 'james@gmail.com', NULL, '$2y$12$5uuyCBcEM5HfFMbkq4nvzem7ZaKRECKfT.Tvd2rMW7iO7VBpFmEiy', 'student', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '2025-08-29 13:51:17', '2025-08-29 13:51:17');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `access_durations`
--
ALTER TABLE `access_durations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `access_durations_is_active_sort_order_index` (`is_active`,`sort_order`);

--
-- Indexes for table `achievements`
--
ALTER TABLE `achievements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `achievements_awarded_by_foreign` (`awarded_by`),
  ADD KEY `achievements_user_id_type_achieved_date_index` (`user_id`,`type`,`achieved_date`),
  ADD KEY `achievements_is_public_is_featured_index` (`is_public`,`is_featured`),
  ADD KEY `achievements_achieved_date_index` (`achieved_date`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `chat_groups`
--
ALTER TABLE `chat_groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chat_groups_created_by_foreign` (`created_by`),
  ADD KEY `chat_groups_subject_id_is_active_index` (`subject_id`,`is_active`),
  ADD KEY `chat_groups_type_is_active_index` (`type`,`is_active`);

--
-- Indexes for table `chat_group_user`
--
ALTER TABLE `chat_group_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `chat_group_user_chat_group_id_user_id_unique` (`chat_group_id`,`user_id`),
  ADD KEY `chat_group_user_user_id_joined_at_index` (`user_id`,`joined_at`);

--
-- Indexes for table `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chat_messages_reply_to_foreign` (`reply_to`),
  ADD KEY `chat_messages_chat_group_id_created_at_index` (`chat_group_id`,`created_at`),
  ADD KEY `chat_messages_user_id_created_at_index` (`user_id`,`created_at`),
  ADD KEY `chat_messages_is_pinned_chat_group_id_index` (`is_pinned`,`chat_group_id`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `enrollments_enrollment_number_unique` (`enrollment_number`),
  ADD KEY `enrollments_user_id_foreign` (`user_id`),
  ADD KEY `enrollments_approved_by_foreign` (`approved_by`);

--
-- Indexes for table `enrollment_payments`
--
ALTER TABLE `enrollment_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `enrollment_payments_enrollment_id_foreign` (`enrollment_id`),
  ADD KEY `enrollment_payments_payment_method_id_foreign` (`payment_method_id`),
  ADD KEY `enrollment_payments_verified_by_foreign` (`verified_by`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lessons`
--
ALTER TABLE `lessons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lessons_topic_id_foreign` (`topic_id`);

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
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `past_papers`
--
ALTER TABLE `past_papers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_verified_by_foreign` (`verified_by`),
  ADD KEY `payments_user_id_status_index` (`user_id`,`status`),
  ADD KEY `payments_status_created_at_index` (`status`,`created_at`);

--
-- Indexes for table `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `payment_methods_key_unique` (`code`),
  ADD KEY `payment_methods_is_active_sort_order_index` (`is_active`,`sort_order`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_unique` (`name`),
  ADD UNIQUE KEY `permissions_slug_unique` (`slug`);

--
-- Indexes for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permission_role_permission_id_role_id_unique` (`permission_id`,`role_id`),
  ADD KEY `permission_role_role_id_foreign` (`role_id`);

--
-- Indexes for table `resources`
--
ALTER TABLE `resources`
  ADD PRIMARY KEY (`id`),
  ADD KEY `resources_subject_id_foreign` (`subject_id`),
  ADD KEY `resources_type_subject_id_is_active_index` (`type`,`subject_id`,`is_active`),
  ADD KEY `resources_grade_level_exam_board_index` (`grade_level`,`exam_board`),
  ADD KEY `resources_year_index` (`year`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_unique` (`name`),
  ADD UNIQUE KEY `roles_slug_unique` (`slug`);

--
-- Indexes for table `role_user`
--
ALTER TABLE `role_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role_user_user_id_role_id_unique` (`user_id`,`role_id`),
  ADD KEY `role_user_role_id_foreign` (`role_id`),
  ADD KEY `role_user_assigned_by_foreign` (`assigned_by`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `site_contents`
--
ALTER TABLE `site_contents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_contents_key_unique` (`key`),
  ADD KEY `site_contents_key_is_active_index` (`key`,`is_active`),
  ADD KEY `site_contents_is_active_sort_order_index` (`is_active`,`sort_order`);

--
-- Indexes for table `student_stories`
--
ALTER TABLE `student_stories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_stories_is_featured_is_active_sort_order_index` (`is_featured`,`is_active`,`sort_order`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subjects_code_unique` (`code`);

--
-- Indexes for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `system_settings_key_unique` (`key`);

--
-- Indexes for table `teacher_assignments`
--
ALTER TABLE `teacher_assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_teacher_student_subject` (`teacher_id`,`student_id`,`subject_id`),
  ADD KEY `teacher_assignments_assigned_by_foreign` (`assigned_by`),
  ADD KEY `teacher_assignments_teacher_id_is_active_index` (`teacher_id`,`is_active`),
  ADD KEY `teacher_assignments_student_id_is_active_index` (`student_id`,`is_active`),
  ADD KEY `teacher_assignments_subject_id_is_active_index` (`subject_id`,`is_active`),
  ADD KEY `teacher_assignments_assignment_type_status_index` (`assignment_type`,`status`);

--
-- Indexes for table `topics`
--
ALTER TABLE `topics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `topics_subject_id_foreign` (`subject_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `access_durations`
--
ALTER TABLE `access_durations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `achievements`
--
ALTER TABLE `achievements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chat_groups`
--
ALTER TABLE `chat_groups`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chat_group_user`
--
ALTER TABLE `chat_group_user`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chat_messages`
--
ALTER TABLE `chat_messages`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `enrollment_payments`
--
ALTER TABLE `enrollment_payments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lessons`
--
ALTER TABLE `lessons`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `past_papers`
--
ALTER TABLE `past_papers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment_methods`
--
ALTER TABLE `payment_methods`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permission_role`
--
ALTER TABLE `permission_role`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `resources`
--
ALTER TABLE `resources`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `role_user`
--
ALTER TABLE `role_user`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `site_contents`
--
ALTER TABLE `site_contents`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_stories`
--
ALTER TABLE `student_stories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `teacher_assignments`
--
ALTER TABLE `teacher_assignments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `topics`
--
ALTER TABLE `topics`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `achievements`
--
ALTER TABLE `achievements`
  ADD CONSTRAINT `achievements_awarded_by_foreign` FOREIGN KEY (`awarded_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `achievements_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `chat_groups`
--
ALTER TABLE `chat_groups`
  ADD CONSTRAINT `chat_groups_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chat_groups_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `chat_group_user`
--
ALTER TABLE `chat_group_user`
  ADD CONSTRAINT `chat_group_user_chat_group_id_foreign` FOREIGN KEY (`chat_group_id`) REFERENCES `chat_groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chat_group_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD CONSTRAINT `chat_messages_chat_group_id_foreign` FOREIGN KEY (`chat_group_id`) REFERENCES `chat_groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chat_messages_reply_to_foreign` FOREIGN KEY (`reply_to`) REFERENCES `chat_messages` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `chat_messages_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `enrollments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `enrollment_payments`
--
ALTER TABLE `enrollment_payments`
  ADD CONSTRAINT `enrollment_payments_enrollment_id_foreign` FOREIGN KEY (`enrollment_id`) REFERENCES `enrollments` (`id`),
  ADD CONSTRAINT `enrollment_payments_payment_method_id_foreign` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`),
  ADD CONSTRAINT `enrollment_payments_verified_by_foreign` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `lessons`
--
ALTER TABLE `lessons`
  ADD CONSTRAINT `lessons_topic_id_foreign` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_verified_by_foreign` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD CONSTRAINT `permission_role_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `permission_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `resources`
--
ALTER TABLE `resources`
  ADD CONSTRAINT `resources_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `role_user`
--
ALTER TABLE `role_user`
  ADD CONSTRAINT `role_user_assigned_by_foreign` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `role_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `teacher_assignments`
--
ALTER TABLE `teacher_assignments`
  ADD CONSTRAINT `teacher_assignments_assigned_by_foreign` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `teacher_assignments_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teacher_assignments_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teacher_assignments_teacher_id_foreign` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `topics`
--
ALTER TABLE `topics`
  ADD CONSTRAINT `topics_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
