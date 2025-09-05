-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 05, 2025 at 03:56 PM
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

--
-- Dumping data for table `access_durations`
--

INSERT INTO `access_durations` (`id`, `name`, `description`, `days`, `price`, `is_active`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, '1 Week Access', 'Perfect for trying out our platform', 7, 500.00, 1, 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(2, '1 Month Access', 'Most popular option for students', 30, 1500.00, 1, 2, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(3, '3 Months Access', 'Great value for term-long access', 90, 4000.00, 1, 3, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(4, '6 Months Access', 'Best for semester preparation', 180, 7500.00, 1, 4, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(5, '1 Year Access', 'Complete academic year access', 365, 12000.00, 1, 5, '2025-09-04 08:06:01', '2025-09-04 08:06:01');

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
-- Table structure for table `ai_training_materials`
--

CREATE TABLE `ai_training_materials` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('book','past_paper','notes','questions','answers') COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_id` bigint UNSIGNED NOT NULL,
  `grade_level` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `syllabus` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_size` bigint DEFAULT NULL,
  `is_processed` tinyint(1) NOT NULL DEFAULT '0',
  `metadata` json DEFAULT NULL,
  `uploaded_by` bigint UNSIGNED NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ai_training_materials`
--

INSERT INTO `ai_training_materials` (`id`, `title`, `content`, `type`, `subject_id`, `grade_level`, `syllabus`, `file_path`, `file_type`, `file_size`, `is_processed`, `metadata`, `uploaded_by`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'English Complete Textbook', 'Comprehensive textbook covering all English topics for secondary education', 'book', 1, 'Form 2', 'Malawi Secondary Education', 'ai-training-materials/book-1-2326.pdf', 'application/pdf', 8314329, 1, '{\"tags\": [\"english\", \"book\", \"secondary\", \"education\", \"grammar\", \"literature\"], \"uploaded_at\": \"2025-08-03T09:06:01.577853Z\", \"original_name\": \"english_complete_textbook.pdf\", \"processing_notes\": null}', 1, 1, '2025-08-25 08:06:01', '2025-09-03 08:06:01'),
(2, 'English Past Papers Collection', 'Collection of previous examination papers for English with marking schemes', 'past_paper', 1, 'Form 4', 'Malawi Secondary Education', 'ai-training-materials/past_paper-1-4749.pdf', 'application/pdf', 5121731, 1, '{\"tags\": [\"english\", \"past_paper\", \"secondary\", \"education\", \"grammar\", \"literature\"], \"uploaded_at\": \"2025-08-25T09:06:01.578133Z\", \"original_name\": \"english_past_papers_collection.pdf\", \"processing_notes\": \"Processed successfully\"}', 1, 1, '2025-08-01 08:06:01', '2025-08-15 08:06:01'),
(3, 'English Study Notes', 'Detailed study notes and summaries for English', 'notes', 1, 'Form 4', 'Malawi Secondary Education', 'ai-training-materials/notes-1-1457.pdf', 'application/pdf', 4502560, 1, '{\"tags\": [\"english\", \"notes\", \"secondary\", \"education\", \"grammar\", \"literature\"], \"uploaded_at\": \"2025-08-24T09:06:01.578212Z\", \"original_name\": \"english_study_notes.pdf\", \"processing_notes\": \"Processed successfully\"}', 1, 1, '2025-08-28 08:06:01', '2025-08-18 08:06:01'),
(4, 'Chichewa Complete Textbook', 'Comprehensive textbook covering all Chichewa topics for secondary education', 'book', 2, 'Form 2', 'Malawi Secondary Education', 'ai-training-materials/book-2-1679.pdf', 'application/pdf', 5173625, 1, '{\"tags\": [\"chichewa\", \"book\", \"secondary\", \"education\", \"general\", \"concepts\"], \"uploaded_at\": \"2025-09-01T09:06:01.578294Z\", \"original_name\": \"chichewa_complete_textbook.pdf\", \"processing_notes\": null}', 1, 1, '2025-07-27 08:06:01', '2025-08-31 08:06:01'),
(5, 'Chichewa Past Papers Collection', 'Collection of previous examination papers for Chichewa with marking schemes', 'past_paper', 2, 'Form 1', 'Malawi Secondary Education', 'ai-training-materials/past_paper-2-3661.pdf', 'application/pdf', 6256379, 1, '{\"tags\": [\"chichewa\", \"past_paper\", \"secondary\", \"education\", \"general\", \"concepts\"], \"uploaded_at\": \"2025-08-02T09:06:01.578365Z\", \"original_name\": \"chichewa_past_papers_collection.pdf\", \"processing_notes\": null}', 1, 1, '2025-07-08 08:06:01', '2025-08-14 08:06:01'),
(6, 'Chichewa Study Notes', 'Detailed study notes and summaries for Chichewa', 'notes', 2, 'Form 3', 'Malawi Secondary Education', 'ai-training-materials/notes-2-1597.pdf', 'application/pdf', 1632034, 1, '{\"tags\": [\"chichewa\", \"notes\", \"secondary\", \"education\", \"general\", \"concepts\"], \"uploaded_at\": \"2025-08-28T09:06:01.578443Z\", \"original_name\": \"chichewa_study_notes.pdf\", \"processing_notes\": \"Processed successfully\"}', 1, 1, '2025-08-26 08:06:01', '2025-08-30 08:06:01'),
(7, 'Mathematics Complete Textbook', 'Comprehensive textbook covering all Mathematics topics for secondary education', 'book', 3, 'Form 1', 'Malawi Secondary Education', 'ai-training-materials/book-3-2951.pdf', 'application/pdf', 5153480, 1, '{\"tags\": [\"mathematics\", \"book\", \"secondary\", \"education\", \"algebra\", \"geometry\"], \"uploaded_at\": \"2025-07-20T09:06:01.578522Z\", \"original_name\": \"mathematics_complete_textbook.pdf\", \"processing_notes\": \"Processed successfully\"}', 1, 1, '2025-07-25 08:06:01', '2025-08-13 08:06:01'),
(8, 'Mathematics Past Papers Collection', 'Collection of previous examination papers for Mathematics with marking schemes', 'past_paper', 3, 'Form 4', 'Malawi Secondary Education', 'ai-training-materials/past_paper-3-3779.pdf', 'application/pdf', 6298173, 1, '{\"tags\": [\"mathematics\", \"past_paper\", \"secondary\", \"education\", \"algebra\", \"geometry\"], \"uploaded_at\": \"2025-07-13T09:06:01.578591Z\", \"original_name\": \"mathematics_past_papers_collection.pdf\", \"processing_notes\": null}', 1, 1, '2025-08-28 08:06:01', '2025-08-30 08:06:01'),
(9, 'Mathematics Study Notes', 'Detailed study notes and summaries for Mathematics', 'notes', 3, 'Form 2', 'Malawi Secondary Education', 'ai-training-materials/notes-3-4080.pdf', 'application/pdf', 3512521, 0, '{\"tags\": [\"mathematics\", \"notes\", \"secondary\", \"education\", \"algebra\", \"geometry\"], \"uploaded_at\": \"2025-08-21T09:06:01.578659Z\", \"original_name\": \"mathematics_study_notes.pdf\", \"processing_notes\": \"Processed successfully\"}', 1, 1, '2025-08-31 08:06:01', '2025-08-17 08:06:01'),
(10, 'Life Skills Complete Textbook', 'Comprehensive textbook covering all Life Skills topics for secondary education', 'book', 4, 'Form 2', 'Malawi Secondary Education', 'ai-training-materials/book-4-6888.pdf', 'application/pdf', 9731027, 0, '{\"tags\": [\"life skills\", \"book\", \"secondary\", \"education\", \"general\", \"concepts\"], \"uploaded_at\": \"2025-08-03T09:06:01.578735Z\", \"original_name\": \"life_skills_complete_textbook.pdf\", \"processing_notes\": \"Processed successfully\"}', 1, 1, '2025-07-09 08:06:01', '2025-08-09 08:06:01'),
(11, 'Life Skills Past Papers Collection', 'Collection of previous examination papers for Life Skills with marking schemes', 'past_paper', 4, 'Form 4', 'Malawi Secondary Education', 'ai-training-materials/past_paper-4-7526.pdf', 'application/pdf', 4123834, 1, '{\"tags\": [\"life skills\", \"past_paper\", \"secondary\", \"education\", \"general\", \"concepts\"], \"uploaded_at\": \"2025-08-07T09:06:01.578803Z\", \"original_name\": \"life_skills_past_papers_collection.pdf\", \"processing_notes\": null}', 1, 1, '2025-08-23 08:06:01', '2025-08-28 08:06:01'),
(12, 'Life Skills Study Notes', 'Detailed study notes and summaries for Life Skills', 'notes', 4, 'Form 1', 'Malawi Secondary Education', 'ai-training-materials/notes-4-3927.pdf', 'application/pdf', 2479501, 1, '{\"tags\": [\"life skills\", \"notes\", \"secondary\", \"education\", \"general\", \"concepts\"], \"uploaded_at\": \"2025-09-01T09:06:01.578882Z\", \"original_name\": \"life_skills_study_notes.pdf\", \"processing_notes\": \"Processed successfully\"}', 1, 1, '2025-08-22 08:06:01', '2025-08-19 08:06:01'),
(13, 'Biology Complete Textbook', 'Comprehensive textbook covering all Biology topics for secondary education', 'book', 5, 'Form 3', 'Malawi Secondary Education', 'ai-training-materials/book-5-5574.pdf', 'application/pdf', 14763688, 0, '{\"tags\": [\"biology\", \"book\", \"secondary\", \"education\", \"genetics\", \"ecology\"], \"uploaded_at\": \"2025-08-15T09:06:01.578967Z\", \"original_name\": \"biology_complete_textbook.pdf\", \"processing_notes\": \"Processed successfully\"}', 1, 1, '2025-07-09 08:06:01', '2025-08-20 08:06:01'),
(14, 'Biology Past Papers Collection', 'Collection of previous examination papers for Biology with marking schemes', 'past_paper', 5, 'Form 1', 'Malawi Secondary Education', 'ai-training-materials/past_paper-5-8596.pdf', 'application/pdf', 4033778, 0, '{\"tags\": [\"biology\", \"past_paper\", \"secondary\", \"education\", \"genetics\", \"ecology\"], \"uploaded_at\": \"2025-08-18T09:06:01.579037Z\", \"original_name\": \"biology_past_papers_collection.pdf\", \"processing_notes\": null}', 1, 1, '2025-07-13 08:06:01', '2025-08-13 08:06:01'),
(15, 'Biology Study Notes', 'Detailed study notes and summaries for Biology', 'notes', 5, 'Form 4', 'Malawi Secondary Education', 'ai-training-materials/notes-5-7066.pdf', 'application/pdf', 1169291, 1, '{\"tags\": [\"biology\", \"notes\", \"secondary\", \"education\", \"genetics\", \"ecology\"], \"uploaded_at\": \"2025-09-02T09:06:01.579103Z\", \"original_name\": \"biology_study_notes.pdf\", \"processing_notes\": \"Processed successfully\"}', 1, 1, '2025-08-18 08:06:01', '2025-08-28 08:06:01'),
(16, 'Physical Science Complete Textbook', 'Comprehensive textbook covering all Physical Science topics for secondary education', 'book', 6, 'Form 2', 'Malawi Secondary Education', 'ai-training-materials/book-6-4539.pdf', 'application/pdf', 14774967, 0, '{\"tags\": [\"physical science\", \"book\", \"secondary\", \"education\", \"general\", \"concepts\"], \"uploaded_at\": \"2025-07-25T09:06:01.579178Z\", \"original_name\": \"physical_science_complete_textbook.pdf\", \"processing_notes\": \"Processed successfully\"}', 1, 1, '2025-08-24 08:06:01', '2025-08-18 08:06:01'),
(17, 'Physical Science Past Papers Collection', 'Collection of previous examination papers for Physical Science with marking schemes', 'past_paper', 6, 'Form 1', 'Malawi Secondary Education', 'ai-training-materials/past_paper-6-4344.pdf', 'application/pdf', 7192792, 1, '{\"tags\": [\"physical science\", \"past_paper\", \"secondary\", \"education\", \"general\", \"concepts\"], \"uploaded_at\": \"2025-07-11T09:06:01.579275Z\", \"original_name\": \"physical_science_past_papers_collection.pdf\", \"processing_notes\": null}', 1, 1, '2025-08-08 08:06:01', '2025-08-12 08:06:01'),
(18, 'Physical Science Study Notes', 'Detailed study notes and summaries for Physical Science', 'notes', 6, 'Form 3', 'Malawi Secondary Education', 'ai-training-materials/notes-6-3844.pdf', 'application/pdf', 3786455, 1, '{\"tags\": [\"physical science\", \"notes\", \"secondary\", \"education\", \"general\", \"concepts\"], \"uploaded_at\": \"2025-08-19T09:06:01.579389Z\", \"original_name\": \"physical_science_study_notes.pdf\", \"processing_notes\": null}', 1, 1, '2025-07-17 08:06:01', '2025-08-06 08:06:01');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `event` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `model_id` bigint UNSIGNED DEFAULT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `event`, `model_type`, `model_id`, `old_values`, `new_values`, `ip_address`, `user_agent`, `url`, `created_at`, `updated_at`) VALUES
(1, 1, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'http://127.0.0.1:8000/login', '2025-09-04 06:06:01', '2025-09-04 08:06:01'),
(2, 2, 'login', NULL, NULL, NULL, NULL, '192.168.1.100', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36', 'http://127.0.0.1:8000/login', '2025-09-04 07:06:01', '2025-09-04 08:06:01'),
(3, 3, 'enrollment', NULL, NULL, NULL, '{\"country\": \"Malawi\", \"subjects\": [\"Mathematics\", \"English\", \"Biology\"], \"enrollment_type\": \"trial\"}', '10.0.0.50', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15', 'http://127.0.0.1:8000/enroll', '2025-09-04 07:21:01', '2025-09-04 08:06:01'),
(4, 1, 'payment', NULL, NULL, '{\"status\": \"pending\"}', '{\"amount\": 50000, \"status\": \"verified\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'http://127.0.0.1:8000/admin/payments', '2025-09-04 07:36:01', '2025-09-04 08:06:01'),
(5, 1, 'access_granted', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'http://127.0.0.1:8000/admin/payments', '2025-09-04 07:36:01', '2025-09-04 08:06:01'),
(6, 1, 'tutor_assigned', NULL, NULL, NULL, '{\"tutor_id\": 2, \"tutor_name\": \"Teacher User\", \"student_name\": \"Student User\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'http://127.0.0.1:8000/admin/tutor-assignments', '2025-09-04 07:51:01', '2025-09-04 08:06:01'),
(7, NULL, 'system', NULL, NULL, NULL, NULL, '127.0.0.1', 'Laravel/12.0 (Artisan Command)', 'artisan:backup', '2025-09-04 08:01:01', '2025-09-04 08:06:01'),
(8, 3, 'logout', NULL, NULL, NULL, NULL, '10.0.0.50', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15', 'http://127.0.0.1:8000/logout', '2025-09-04 08:04:01', '2025-09-04 08:06:01'),
(9, 4, 'payment', 'App\\Models\\EnrollmentPayment', 1, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'http://127.0.0.1:8000/payments', '2025-09-05 14:07:19', '2025-09-05 14:07:19'),
(10, 1, 'access_granted', 'App\\Models\\User', 4, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36 Edg/139.0.0.0', 'http://127.0.0.1:8000/payments/1/verify', '2025-09-05 14:29:11', '2025-09-05 14:29:11'),
(11, 1, 'payment', 'App\\Models\\EnrollmentPayment', 1, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36 Edg/139.0.0.0', 'http://127.0.0.1:8000/payments/1/verify', '2025-09-05 14:29:11', '2025-09-05 14:29:11');

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

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('studyseco-cache-active_subjects', 'O:39:\"Illuminate\\Database\\Eloquent\\Collection\":2:{s:8:\"\0*\0items\";a:18:{i:0;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"English\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:1;s:4:\"name\";s:7:\"English\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:1;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:2;s:4:\"name\";s:8:\"Chichewa\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:2;s:4:\"name\";s:8:\"Chichewa\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:2;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:3;s:4:\"name\";s:11:\"Mathematics\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:3;s:4:\"name\";s:11:\"Mathematics\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:3;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:4;s:4:\"name\";s:11:\"Life Skills\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:4;s:4:\"name\";s:11:\"Life Skills\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:4;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:5;s:4:\"name\";s:7:\"Biology\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:5;s:4:\"name\";s:7:\"Biology\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:5;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:6;s:4:\"name\";s:16:\"Physical Science\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:6;s:4:\"name\";s:16:\"Physical Science\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:6;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:7;s:4:\"name\";s:9:\"Chemistry\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:7;s:4:\"name\";s:9:\"Chemistry\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:7;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:8;s:4:\"name\";s:7:\"Physics\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:8;s:4:\"name\";s:7:\"Physics\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:8;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:9;s:4:\"name\";s:9:\"Geography\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:9;s:4:\"name\";s:9:\"Geography\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:9;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:10;s:4:\"name\";s:7:\"History\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:10;s:4:\"name\";s:7:\"History\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:10;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:11;s:4:\"name\";s:14:\"Social Studies\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:11;s:4:\"name\";s:14:\"Social Studies\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:11;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:12;s:4:\"name\";s:15:\"Bible Knowledge\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:12;s:4:\"name\";s:15:\"Bible Knowledge\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:12;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:13;s:4:\"name\";s:11:\"Agriculture\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:13;s:4:\"name\";s:11:\"Agriculture\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:13;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:14;s:4:\"name\";s:14:\"Home Economics\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:14;s:4:\"name\";s:14:\"Home Economics\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:14;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:15;s:4:\"name\";s:17:\"Technical Drawing\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:15;s:4:\"name\";s:17:\"Technical Drawing\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:15;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:16;s:4:\"name\";s:16:\"Business Studies\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:16;s:4:\"name\";s:16:\"Business Studies\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:16;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:17;s:4:\"name\";s:6:\"French\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:17;s:4:\"name\";s:6:\"French\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}i:17;O:18:\"App\\Models\\Subject\":33:{s:13:\"\0*\0connection\";s:5:\"mysql\";s:8:\"\0*\0table\";s:8:\"subjects\";s:13:\"\0*\0primaryKey\";s:2:\"id\";s:10:\"\0*\0keyType\";s:3:\"int\";s:12:\"incrementing\";b:1;s:7:\"\0*\0with\";a:0:{}s:12:\"\0*\0withCount\";a:0:{}s:19:\"preventsLazyLoading\";b:0;s:10:\"\0*\0perPage\";i:15;s:6:\"exists\";b:1;s:18:\"wasRecentlyCreated\";b:0;s:28:\"\0*\0escapeWhenCastingToString\";b:0;s:13:\"\0*\0attributes\";a:2:{s:2:\"id\";i:18;s:4:\"name\";s:16:\"Computer Studies\";}s:11:\"\0*\0original\";a:2:{s:2:\"id\";i:18;s:4:\"name\";s:16:\"Computer Studies\";}s:10:\"\0*\0changes\";a:0:{}s:11:\"\0*\0previous\";a:0:{}s:8:\"\0*\0casts\";a:2:{s:9:\"is_active\";s:7:\"boolean\";s:13:\"is_compulsory\";s:7:\"boolean\";}s:17:\"\0*\0classCastCache\";a:0:{}s:21:\"\0*\0attributeCastCache\";a:0:{}s:13:\"\0*\0dateFormat\";N;s:10:\"\0*\0appends\";a:0:{}s:19:\"\0*\0dispatchesEvents\";a:0:{}s:14:\"\0*\0observables\";a:0:{}s:12:\"\0*\0relations\";a:0:{}s:10:\"\0*\0touches\";a:0:{}s:27:\"\0*\0relationAutoloadCallback\";N;s:26:\"\0*\0relationAutoloadContext\";N;s:10:\"timestamps\";b:1;s:13:\"usesUniqueIds\";b:0;s:9:\"\0*\0hidden\";a:0:{}s:10:\"\0*\0visible\";a:0:{}s:11:\"\0*\0fillable\";a:12:{i:0;s:4:\"name\";i:1;s:4:\"code\";i:2;s:11:\"description\";i:3;s:10:\"department\";i:4;s:11:\"grade_level\";i:5;s:7:\"credits\";i:6;s:12:\"teacher_name\";i:7;s:11:\"cover_image\";i:8;s:9:\"is_active\";i:9;s:13:\"is_compulsory\";i:10;s:12:\"subject_type\";i:11;s:10:\"sort_order\";}s:10:\"\0*\0guarded\";a:1:{i:0;s:1:\"*\";}}}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1757005988);

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
-- Table structure for table `cancellation_requests`
--

CREATE TABLE `cancellation_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `enrollment_id` bigint UNSIGNED DEFAULT NULL,
  `cancellation_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'enrollment',
  `reason` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','approved','rejected','processed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `requested_at` timestamp NOT NULL,
  `cancellation_deadline` timestamp NULL DEFAULT NULL,
  `processed_at` timestamp NULL DEFAULT NULL,
  `processed_by` bigint UNSIGNED DEFAULT NULL,
  `admin_notes` text COLLATE utf8mb4_unicode_ci,
  `refund_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `refund_status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `refund_processed_at` timestamp NULL DEFAULT NULL,
  `original_payment_data` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
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
-- Table structure for table `community_posts`
--

CREATE TABLE `community_posts` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'post',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachments` json DEFAULT NULL,
  `tags` json DEFAULT NULL,
  `subject_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `priority` enum('low','medium','high','urgent') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medium',
  `is_anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `is_solved` tinyint(1) NOT NULL DEFAULT '0',
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `allows_comments` tinyint(1) NOT NULL DEFAULT '1',
  `views_count` int NOT NULL DEFAULT '0',
  `likes_count` int NOT NULL DEFAULT '0',
  `comments_count` int NOT NULL DEFAULT '0',
  `shares_count` int NOT NULL DEFAULT '0',
  `poll_options` json DEFAULT NULL,
  `poll_votes` json DEFAULT NULL,
  `poll_expires_at` timestamp NULL DEFAULT NULL,
  `metadata` json DEFAULT NULL,
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
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `assigned_tutor_id` bigint UNSIGNED DEFAULT NULL,
  `tutor_assigned_at` timestamp NULL DEFAULT NULL,
  `last_extension_at` timestamp NULL DEFAULT NULL,
  `can_extend_before_expiry` tinyint(1) NOT NULL DEFAULT '1',
  `cancellation_reason` text COLLATE utf8mb4_unicode_ci,
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `refund_status` enum('pending','processing','completed','failed') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `refund_processed_at` timestamp NULL DEFAULT NULL,
  `refund_reference` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`id`, `enrollment_number`, `name`, `email`, `email_verification_token`, `email_verified_at`, `phone`, `phone_verification_code`, `phone_verified_at`, `verification_expires_at`, `is_verified`, `address`, `country`, `region`, `currency`, `price_per_subject`, `subject_count`, `selected_subjects`, `total_amount`, `payment_method`, `payment_reference`, `payment_proof_path`, `status`, `is_trial`, `trial_started_at`, `trial_expires_at`, `access_expires_at`, `admin_notes`, `approved_at`, `user_id`, `created_at`, `updated_at`, `approved_by`, `assigned_tutor_id`, `tutor_assigned_at`, `last_extension_at`, `can_extend_before_expiry`, `cancellation_reason`, `cancelled_at`, `refund_status`, `refund_processed_at`, `refund_reference`) VALUES
(1, 'ENR2025000001', 'Emmanuel Phiri', 'xtreamcoder2013@gmail.com', NULL, NULL, '+27686518342', NULL, NULL, NULL, 0, 'Durban, South Africa', 'South Africa', 'south_africa', 'ZAR', NULL, 0, '[16, 9, 2]', 0.00, 'trial', 'TRIAL_68B95C132EC5E', NULL, 'approved', 0, '2025-09-04 08:29:55', '2025-09-11 08:29:55', '2025-10-05 14:29:02', NULL, '2025-09-05 14:29:02', 4, '2025-09-04 08:29:55', '2025-09-05 14:29:02', 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL);

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
  `additional_data` json DEFAULT NULL,
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

INSERT INTO `enrollment_payments` (`id`, `enrollment_id`, `payment_method_id`, `reference_number`, `amount`, `currency`, `payment_proof_path`, `payment_details`, `payment_type`, `additional_data`, `extension_months`, `status`, `admin_notes`, `verified_at`, `verified_by`, `created_at`, `updated_at`) VALUES
(1, 1, 4, '2342423423', 4000.00, 'MWK', NULL, NULL, 'enrollment', NULL, 3, 'verified', NULL, '2025-09-05 14:29:02', 1, '2025-09-05 14:07:19', '2025-09-05 14:29:02');

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
-- Table structure for table `live_sessions`
--

CREATE TABLE `live_sessions` (
  `id` bigint UNSIGNED NOT NULL,
  `student_id` bigint UNSIGNED NOT NULL,
  `tutor_id` bigint UNSIGNED NOT NULL,
  `subject_id` bigint UNSIGNED DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('requested','approved','rejected','scheduled','in_progress','completed','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'requested',
  `scheduled_at` datetime DEFAULT NULL,
  `duration_minutes` int NOT NULL DEFAULT '60',
  `meeting_link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `student_notes` text COLLATE utf8mb4_unicode_ci,
  `tutor_notes` text COLLATE utf8mb4_unicode_ci,
  `rejection_reason` text COLLATE utf8mb4_unicode_ci,
  `started_at` timestamp NULL DEFAULT NULL,
  `ended_at` timestamp NULL DEFAULT NULL,
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
(34, '2025_08_28_185352_add_missing_fields_to_enrollments_table', 1),
(35, '2025_08_31_170906_create_support_chats_table', 1),
(36, '2025_08_31_170929_create_support_chat_messages_table', 1),
(37, '2025_09_01_063346_create_community_posts_table', 1),
(38, '2025_09_01_063422_create_post_reactions_table', 1),
(39, '2025_09_01_063448_create_post_comments_table', 1),
(40, '2025_09_01_063503_create_shared_resources_table', 1),
(41, '2025_09_02_144835_create_secondary_schools_table', 1),
(42, '2025_09_02_144841_create_student_school_selections_table', 1),
(43, '2025_09_02_150725_add_tutor_assignment_fields_to_enrollments_table', 1),
(44, '2025_09_02_150739_create_live_sessions_table', 1),
(45, '2025_09_02_150740_create_ai_training_materials_table', 1),
(46, '2025_09_02_152142_create_audit_logs_table', 1),
(47, '2025_09_02_191000_add_notification_settings_to_users_table', 1),
(48, '2025_09_03_065446_create_terms_acceptances_table', 1),
(49, '2025_09_03_065456_create_cancellation_requests_table', 1),
(51, '2025_09_05_153539_add_additional_data_to_enrollment_payments_table', 2);

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

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at`) VALUES
('36e8095d-8189-4581-83b0-ef1745aa1934', 'App\\Notifications\\TrialWelcomeEmail', 'App\\Models\\User', 4, '{\"type\":\"trial_welcome_email\",\"title\":\"FREE Trial Activated!\",\"message\":\"Your 7-day free trial is ready. Check your email for login credentials.\",\"enrollment_id\":1,\"user_id\":4,\"trial_expires_at\":\"2025-09-11T09:29:55.000000Z\",\"action_url\":\"http:\\/\\/127.0.0.1:8000\\/dashboard\"}', '2025-09-04 11:11:52', '2025-09-04 08:30:02', '2025-09-04 11:11:52'),
('5c710bc7-6f7c-4090-aaeb-8ec5fa6a8d9e', 'App\\Notifications\\PaymentApproved', 'App\\Models\\User', 4, '{\"type\":\"payment_approved\",\"title\":\"Payment Approved!\",\"message\":\"Your payment has been approved. Welcome to StudySeco!\",\"enrollment_id\":1,\"expires_at\":\"2025-10-05T15:29:02.000000Z\",\"days_remaining\":30,\"action_url\":\"http:\\/\\/127.0.0.1:8000\\/dashboard\"}', '2025-09-05 14:29:27', '2025-09-05 14:29:11', '2025-09-05 14:29:27');

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
(1, 'TNM Mpamba', 'tnm_mpamba', 'mobile_money', 'malawi', 'MWK', 'Send payment to 0991234567. Use your enrollment number as reference.', '[\"reference_number\", \"screenshot\"]', 1, 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(2, 'Airtel Money', 'airtel_money', 'mobile_money', 'malawi', 'MWK', 'Send payment to 0991234568. Use your enrollment number as reference.', '[\"reference_number\", \"screenshot\"]', 1, 2, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(3, 'Bank Transfer', 'bank_transfer', 'bank', 'malawi', 'MWK', 'Transfer to Account: StudySeco Ltd, Account Number: 123456789, Bank: Standard Bank Malawi. Use enrollment number as reference.', '[\"reference_number\", \"bank_slip\"]', 1, 3, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(4, 'Mukuru', 'mukuru', 'remittance', 'south_africa', 'ZAR', 'Send payment through Mukuru to StudySeco Ltd. Contact support for collection details.', '[\"reference_number\", \"receipt\"]', 1, 10, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(5, 'Hello Paisa', 'hello_paisa', 'digital_wallet', 'south_africa', 'ZAR', 'Send payment through Hello Paisa to StudySeco account.', '[\"reference_number\", \"screenshot\"]', 1, 11, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(6, 'WorldRemit', 'worldremit', 'remittance', 'international', 'USD', 'Send payment through WorldRemit to StudySeco Ltd, Malawi. Contact support for recipient details.', '[\"reference_number\", \"receipt\"]', 1, 20, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(7, 'Remitly', 'remitly', 'remittance', 'international', 'USD', 'Send payment through Remitly to StudySeco Ltd, Malawi. Contact support for recipient details.', '[\"reference_number\", \"receipt\"]', 1, 21, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(8, 'Western Union', 'western_union', 'remittance', 'international', 'USD', 'Send payment through Western Union to StudySeco Ltd, Malawi. Contact support for recipient details.', '[\"reference_number\", \"mtcn\"]', 1, 22, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(9, 'MoneyGram', 'moneygram', 'remittance', 'international', 'USD', 'Send payment through MoneyGram to StudySeco Ltd, Malawi. Contact support for recipient details.', '[\"reference_number\", \"receipt\"]', 1, 23, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(10, 'PayPal', 'paypal', 'digital_wallet', 'international', 'USD', 'Send payment to payments@studyseco.com through PayPal. Include enrollment number in notes.', '[\"transaction_id\", \"screenshot\"]', 1, 24, '2025-09-04 08:06:01', '2025-09-04 08:06:01');

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

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `slug`, `description`, `category`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'View Users', 'view-users', 'Can view all users', 'user_management', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(2, 'Create Users', 'create-users', 'Can create new users', 'user_management', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(3, 'Edit Users', 'edit-users', 'Can edit user details', 'user_management', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(4, 'Delete Users', 'delete-users', 'Can delete users', 'user_management', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(5, 'Assign Roles', 'assign-roles', 'Can assign roles to users', 'user_management', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(6, 'View Subjects', 'view-subjects', 'Can view all subjects', 'academic', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(7, 'Create Subjects', 'create-subjects', 'Can create new subjects', 'academic', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(8, 'Edit Subjects', 'edit-subjects', 'Can edit subjects', 'academic', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(9, 'Delete Subjects', 'delete-subjects', 'Can delete subjects', 'academic', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(10, 'Manage Topics', 'manage-topics', 'Can manage topics and lessons', 'academic', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(11, 'View Payments', 'view-payments', 'Can view all payments', 'financial', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(12, 'Verify Payments', 'verify-payments', 'Can verify and approve payments', 'financial', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(13, 'Manage Payment Methods', 'manage-payment-methods', 'Can manage payment methods', 'financial', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(14, 'View Financial Reports', 'view-financial-reports', 'Can view financial reports', 'financial', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(15, 'Join Chat Groups', 'join-chat-groups', 'Can join subject-based chat groups', 'communication', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(16, 'Create Chat Groups', 'create-chat-groups', 'Can create new chat groups', 'communication', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(17, 'Moderate Chats', 'moderate-chats', 'Can moderate chat messages', 'communication', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(18, 'Send Announcements', 'send-announcements', 'Can send system-wide announcements', 'communication', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(19, 'View Analytics', 'view-analytics', 'Can view system analytics', 'analytics', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(20, 'View Student Progress', 'view-student-progress', 'Can view student progress reports', 'analytics', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(21, 'Export Reports', 'export-reports', 'Can export system reports', 'analytics', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(22, 'Manage Settings', 'manage-settings', 'Can manage system settings', 'system', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(23, 'View System Logs', 'view-system-logs', 'Can view system logs', 'system', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(24, 'Manage Enrollments', 'manage-enrollments', 'Can manage student enrollments', 'system', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(25, 'Upload Resources', 'upload-resources', 'Can upload learning resources', 'resources', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(26, 'Manage Resources', 'manage-resources', 'Can manage all resources', 'resources', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(27, 'Download Resources', 'download-resources', 'Can download learning resources', 'resources', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(28, 'Create Assignments', 'create-assignments', 'Can create assignments', 'assessment', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(29, 'Grade Assignments', 'grade-assignments', 'Can grade student assignments', 'assessment', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(30, 'View Grades', 'view-grades', 'Can view assignment grades', 'assessment', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(31, 'Submit Assignments', 'submit-assignments', 'Can submit assignments', 'assessment', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01');

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

--
-- Dumping data for table `permission_role`
--

INSERT INTO `permission_role` (`id`, `permission_id`, `role_id`, `created_at`, `updated_at`) VALUES
(1, 5, 1, NULL, NULL),
(2, 28, 1, NULL, NULL),
(3, 16, 1, NULL, NULL),
(4, 7, 1, NULL, NULL),
(5, 2, 1, NULL, NULL),
(6, 9, 1, NULL, NULL),
(7, 4, 1, NULL, NULL),
(8, 27, 1, NULL, NULL),
(9, 8, 1, NULL, NULL),
(10, 3, 1, NULL, NULL),
(11, 21, 1, NULL, NULL),
(12, 29, 1, NULL, NULL),
(13, 15, 1, NULL, NULL),
(14, 24, 1, NULL, NULL),
(15, 13, 1, NULL, NULL),
(16, 26, 1, NULL, NULL),
(17, 22, 1, NULL, NULL),
(18, 10, 1, NULL, NULL),
(19, 17, 1, NULL, NULL),
(20, 18, 1, NULL, NULL),
(21, 31, 1, NULL, NULL),
(22, 25, 1, NULL, NULL),
(23, 12, 1, NULL, NULL),
(24, 19, 1, NULL, NULL),
(25, 14, 1, NULL, NULL),
(26, 30, 1, NULL, NULL),
(27, 11, 1, NULL, NULL),
(28, 20, 1, NULL, NULL),
(29, 6, 1, NULL, NULL),
(30, 23, 1, NULL, NULL),
(31, 1, 1, NULL, NULL),
(32, 5, 2, NULL, NULL),
(33, 28, 2, NULL, NULL),
(34, 16, 2, NULL, NULL),
(35, 7, 2, NULL, NULL),
(36, 2, 2, NULL, NULL),
(37, 9, 2, NULL, NULL),
(38, 4, 2, NULL, NULL),
(39, 27, 2, NULL, NULL),
(40, 8, 2, NULL, NULL),
(41, 3, 2, NULL, NULL),
(42, 21, 2, NULL, NULL),
(43, 29, 2, NULL, NULL),
(44, 15, 2, NULL, NULL),
(45, 24, 2, NULL, NULL),
(46, 13, 2, NULL, NULL),
(47, 26, 2, NULL, NULL),
(48, 22, 2, NULL, NULL),
(49, 10, 2, NULL, NULL),
(50, 17, 2, NULL, NULL),
(51, 18, 2, NULL, NULL),
(52, 31, 2, NULL, NULL),
(53, 25, 2, NULL, NULL),
(54, 12, 2, NULL, NULL),
(55, 19, 2, NULL, NULL),
(56, 14, 2, NULL, NULL),
(57, 30, 2, NULL, NULL),
(58, 11, 2, NULL, NULL),
(59, 20, 2, NULL, NULL),
(60, 6, 2, NULL, NULL),
(61, 1, 2, NULL, NULL),
(62, 28, 3, NULL, NULL),
(63, 16, 3, NULL, NULL),
(64, 7, 3, NULL, NULL),
(65, 27, 3, NULL, NULL),
(66, 8, 3, NULL, NULL),
(67, 21, 3, NULL, NULL),
(68, 29, 3, NULL, NULL),
(69, 15, 3, NULL, NULL),
(70, 26, 3, NULL, NULL),
(71, 10, 3, NULL, NULL),
(72, 17, 3, NULL, NULL),
(73, 25, 3, NULL, NULL),
(74, 30, 3, NULL, NULL),
(75, 20, 3, NULL, NULL),
(76, 6, 3, NULL, NULL),
(77, 27, 4, NULL, NULL),
(78, 15, 4, NULL, NULL),
(79, 31, 4, NULL, NULL),
(80, 30, 4, NULL, NULL),
(81, 6, 4, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `post_comments`
--

CREATE TABLE `post_comments` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `community_post_id` bigint UNSIGNED NOT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachments` json DEFAULT NULL,
  `is_solution` tinyint(1) NOT NULL DEFAULT '0',
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `likes_count` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `post_reactions`
--

CREATE TABLE `post_reactions` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `community_post_id` bigint UNSIGNED NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'like',
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

--
-- Dumping data for table `resources`
--

INSERT INTO `resources` (`id`, `title`, `description`, `type`, `category`, `subject_id`, `grade_level`, `exam_board`, `year`, `file_path`, `file_type`, `file_size`, `thumbnail`, `access_permissions`, `is_active`, `is_protected`, `protection_settings`, `view_count`, `download_attempts`, `created_at`, `updated_at`) VALUES
(1, 'Advanced Mathematics for Form 3', 'Comprehensive mathematics textbook covering algebra, geometry, and trigonometry for Form 3 students.', 'book', 'Textbook', 3, '11', NULL, 2024, 'library-resources/sample.pdf', 'application/pdf', 15728640, NULL, NULL, 1, 0, NULL, 46, 0, '2025-09-04 08:06:01', '2025-09-04 15:15:13'),
(2, 'Mathematics Workbook Form 2', 'Practice exercises and worksheets for Form 2 mathematics curriculum.', 'book', 'Workbook', 3, '10', NULL, 2024, 'library-resources/sample.pdf', 'application/pdf', 8388608, NULL, NULL, 1, 0, NULL, 32, 0, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(3, 'English Literature Anthology', 'Collection of poems, short stories, and excerpts from novels for secondary school students.', 'book', 'Literature', 1, '11', NULL, 2024, 'library-resources/sample.pdf', 'application/pdf', 12582912, NULL, NULL, 1, 0, NULL, 28, 0, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(4, 'Grammar and Composition Guide', 'Comprehensive guide to English grammar rules and essay writing techniques.', 'book', 'Grammar', 1, '10', NULL, 2024, 'library-resources/sample.pdf', 'application/pdf', 5242880, NULL, NULL, 1, 0, NULL, 67, 0, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(5, 'Biology Practical Manual', 'Laboratory experiments and practical work guide for biology students.', 'book', 'Practical Guide', 5, '12', NULL, 2024, 'library-resources/sample.pdf', 'application/pdf', 18874368, NULL, NULL, 1, 0, NULL, 23, 0, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(6, 'MSCE Mathematics 2023', 'Complete MSCE Mathematics examination paper from 2023 with marking scheme.', 'past_paper', 'MSCE', 3, '12', 'MANEB', 2023, 'library-resources/sample.pdf', 'application/pdf', 2097152, NULL, NULL, 1, 0, NULL, 156, 0, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(7, 'MSCE English 2023', 'MSCE English Language examination paper 2023 with comprehensive answers.', 'past_paper', 'MSCE', 1, '12', 'MANEB', 2023, 'library-resources/sample.pdf', 'application/pdf', 1572864, NULL, NULL, 1, 0, NULL, 134, 0, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(8, 'JCE Mathematics 2023', 'Junior Certificate of Education Mathematics paper from 2023.', 'past_paper', 'JCE', 3, '10', 'MANEB', 2023, 'library-resources/sample.pdf', 'application/pdf', 1048576, NULL, NULL, 1, 0, NULL, 89, 0, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(9, 'Study Tips for Effective Learning', 'Comprehensive guide with proven strategies for effective studying and exam preparation.', 'document', 'Study Guide', NULL, NULL, NULL, 2024, 'library-resources/sample.pdf', 'application/pdf', 3145728, NULL, NULL, 1, 0, NULL, 78, 0, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(10, 'MANEB Examination Guidelines 2024', 'Official guidelines and regulations for MANEB examinations in 2024.', 'document', 'Official Guidelines', NULL, NULL, NULL, 2024, 'library-resources/sample.pdf', 'application/pdf', 1572864, NULL, NULL, 1, 0, NULL, 67, 0, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(11, 'MSCE Biology 2023', 'MSCE Biology examination paper 2023 with marking scheme and diagrams.', 'past_paper', 'MSCE', 5, '12', 'MANEB', 2023, 'library-resources/sample.pdf', 'application/pdf', 3145728, NULL, NULL, 1, 0, NULL, 112, 0, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(12, 'JCE English 2023', 'Junior Certificate English Language paper with comprehension and essay sections.', 'past_paper', 'JCE', 1, '10', 'MANEB', 2023, 'library-resources/sample.pdf', 'application/pdf', 1835008, NULL, NULL, 1, 0, NULL, 76, 0, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(13, 'Mathematical Formulas Reference', 'Quick reference guide containing all essential mathematical formulas for secondary education.', 'document', 'Reference', 3, NULL, NULL, 2024, 'library-resources/sample.pdf', 'application/pdf', 2097152, NULL, NULL, 1, 0, NULL, 145, 0, '2025-09-04 08:06:01', '2025-09-04 08:06:01');

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

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `slug`, `description`, `priority`, `dashboard_features`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Super Administrator', 'super-admin', 'Full system access with all permissions', 100, '[\"users\", \"subjects\", \"payments\", \"analytics\", \"settings\", \"chat\", \"resources\", \"assignments\"]', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(2, 'Administrator', 'admin', 'System administrator with most permissions', 90, '[\"users\", \"subjects\", \"payments\", \"analytics\", \"chat\", \"resources\", \"assignments\"]', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(3, 'Teacher', 'teacher', 'Educator with teaching and assessment permissions', 50, '[\"subjects\", \"chat\", \"resources\", \"assignments\", \"analytics\"]', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(4, 'Student', 'student', 'Learner with basic access permissions', 10, '[\"subjects\", \"chat\", \"resources\", \"assignments\"]', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01');

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
-- Table structure for table `secondary_schools`
--

CREATE TABLE `secondary_schools` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `region` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `district` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `capacity` int NOT NULL DEFAULT '100',
  `facilities` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `secondary_schools`
--

INSERT INTO `secondary_schools` (`id`, `name`, `code`, `region`, `district`, `address`, `phone`, `email`, `capacity`, `facilities`, `is_active`, `latitude`, `longitude`, `created_at`, `updated_at`) VALUES
(1, 'Bandawe Boys Secondary School', 'BAN_CHI_2d', 'Northern', 'Chintheche', ' Nkhata Bay,  P/Bag 1', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(2, 'Baula CDSS', 'BAU_MZI_b7', 'Northern', 'Mzimba', 'Mzimba', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(3, 'Bembeke CDSS', 'BEM_DED_cc', 'Northern', 'Dedza—cross-regional', ' P/A Bembeke', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(4, 'Biwi DEC', 'BIW_LIL_0c', 'Northern', 'Lilongwe—cross-regional', ' P.O. Box 1064', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(5, 'Bolero Secondary School', 'BOL_RUM_ed', 'Northern', 'Rumphi', ' P.O. Box 138', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(6, 'Bwengu CDSS', 'BWE_MZI_ff', 'Northern', 'Mzimba', ' P.O3176. Mlodza CDSS (Lilongwe,  P.O. Box 20106,  Kawale', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(7, 'Mitundu Secondary School', 'MIT_LIL_bc', 'Northern', 'Lilongwe', ' P/Bag 10', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(8, 'Mpando CDSS', 'MPA_DOW_b5', 'Northern', 'Dowa', ' P/Bag 3,  Nsalu', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(9, 'Mphomwa CDSS', 'MPH_KAS_56', 'Northern', 'Kasungu', 'Kasungu', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(10, 'Mseche CDSS', 'MSE_LIL_5d', 'Northern', 'Lilongwe Rural East', 'Lilongwe Rural East', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(11, 'Mtendere Secondary School', 'MTE_DED_36', 'Northern', 'Dedza', ' P.O. Box 25,  Malirana', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(12, 'Mwalawanyenje CDSS', 'MWA_KAS_94', 'Northern', 'Kasungu', ' P.O. Box 38', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(13, 'Mwatibu CDSS', 'MWA_LIL_ff', 'Northern', 'Lilongwe', ' P.O. Box 120,  Nathenje', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(14, 'Namitete Secondary School', 'NAM_LIL_34', 'Northern', 'Lilongwe', ' P.O. Box 138', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(15, 'Nkhamenya Girls Secondary School', 'NKH_KAS_3c', 'Northern', 'Kasungu', ' P/Bag 1,  Chisemphere', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(16, 'Nkhotakota Secondary School', 'NKH_NKH_14', 'Northern', 'Nkhotakota', ' P.O. Box 136', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(17, 'Ntcheu Secondary School', 'NTC_NTC_57', 'Northern', 'Ntcheu', ' P.O. Box 42', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(18, 'Ntchisi Boys Secondary School', 'NTC_NTC_dd', 'Northern', 'Ntchisi', ' P.O. Box 36', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(19, 'Robert Blake Boys Secondary School', 'ROB_DOW_f4', 'Northern', 'Dowa', ' P/Bag 1', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(20, 'Salima Secondary School', 'SAL_SAL_47', 'Northern', 'Salima', ' P.O. Box 85', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(21, 'St. Johns Boys Secondary School', 'STJ_LIL_1f', 'Northern', 'Lilongwe', ' P.O. Box 191', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(22, 'Umbwi Boys Secondary School', 'UMB_DED_a1', 'Northern', 'Dedza', ' P.O. Box 22', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(23, 'William Murry Boys Secondary School', 'WIL_LIL_00', 'Northern', 'Lilongwe', ' P.O. Box 44,  Nkhoma', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(24, 'Yakobe CDSS', 'YAK_DOW_25', 'Northern', 'Dowa', 'Dowa', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(25, 'Athens', 'ATH_PVT_8c', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(26, 'Lilongwe Islamic', 'LIL_PVT_4b', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(27, 'Magodi Christian', 'MAG_PVT_ad', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(28, 'Maya', 'MAY_PVT_cf', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(29, 'Ungwelu', 'UNG_PVT_05', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(30, 'Ulemu kwa Atate', 'ULE_PVT_48', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(31, 'Walani', 'WAL_PVT_13', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(32, 'Chikhutu CDSS', 'CHI_LIL_86', 'Central', 'Lilongwe', ' P.O. Box 144,  Lumbadzi', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(33, 'Chilambula CDSS', 'CHI_LIL_2c', 'Central', 'Lilongwe', ' P.O. Box 1093', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(34, 'Chilanga CDSS', 'CHI_KAS_a5', 'Central', 'Kasungu', ' P.O. Box 36', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(35, 'Chimphalika DEC', 'CHI_DED_de', 'Central', 'Dedza', ' P.O. Box 25,  Chimoto', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(36, 'Chinkwenzule CDSS', 'CHI_LIL_a1', 'Central', 'Lilongwe', ' P.O. Box 29,  Lumbadzi', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(37, 'Chisamba CDSS', 'CHI_LIL_96', 'Central', 'Lilongwe', ' P.O. Box 20147,  Kawale', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(38, 'Chiwoko CDSS', 'CHI_LIL_e6', 'Central', 'Lilongwe', ' P/Bag 256,  Kawale', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(39, 'Chowo CDSS', 'CHO_LIL_94', 'Central', 'Lilongwe', ' P.O. Box 74,  Nkhoma', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(40, 'Chulu CDSS', 'CHU_KAS_47', 'Central', 'Kasungu', ' P/A Chulu', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(41, 'Davy Boys', 'DAV_PVT_63', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(42, 'Davy Girls', 'DAV_PVT_13', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(43, 'Dzuka Girls', 'DZU_PVT_2e', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(44, 'Dzoole CDSS', 'DZO_DOW_3a', 'Central', 'Dowa', ' P/Bag 14,  Mponela', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(45, 'Golong’ozi CDSS', 'GOL_DOW_7f', 'Central', 'Dowa', ' P.O. Box 154', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(46, 'Gowa DEC', 'GOW_NTC_08', 'Central', 'Ntcheu', ' P.O. Box 47,  Mulangeni', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(47, 'Indaba', 'IND_PVT_d8', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(48, 'Kabwazi CDSS', 'KAB_NTC_ba', 'Central', 'Ntcheu', ' P/A Bawi', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(49, 'Kachokolo CDSS', 'KAC_KAS_fc', 'Central', 'Kasungu', ' P/Bag 3,  Mtunthama', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(50, 'Kalaka CDSS', 'KAL_NTC_1c', 'Central', 'Ntcheu', ' P.O. Box 17,  Kandeu', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(51, 'Kaluluma CDSS', 'KAL_KAS_a9', 'Central', 'Kasungu', ' P.O. Box 41,  Nkhamenya', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(52, 'Kapelula CDSS', 'KAP_KAS_3c', 'Central', 'Kasungu', ' P.O. Box 48,  Ndonda', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(53, 'Kapirintiwa CDSS', 'KAP_SAL_81', 'Central', 'Salima', ' P.O. Box 41,  Chitala', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(54, 'Kasiya CDSS', 'KAS_LIL_cd', 'Central', 'Lilongwe', ' P/Bag 1', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(55, 'Katewe CDSS', 'KAT_DED_bc', 'Central', 'Dedza', ' P/A Katewe', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(56, 'Katsekaminga CDSS', 'KAT_DED_23', 'Central', 'Dedza', ' P.O. Box 266', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(57, 'Kayoyo CDSS', 'KAY_NTC_3d', 'Central', 'Ntchisi', ' P.O. Box 35', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(58, 'Kochilira CDSS', 'KOC_MCH_78', 'Central', 'Mchinji', ' P/Bag 5,  Magawa', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(59, 'Kondwani', 'KON_PVT_39', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(60, 'Liberty', 'LIB_PVT_81', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(61, 'Linthipe Secondary School', 'LIN_DED_c1', 'Central', 'Dedza', ' P/Bag 3', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(62, 'Livimbo CDSS', 'LIV_LIL_aa', 'Central', 'Lilongwe', ' P.O. Box 323', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(63, 'Macey Williams', 'MAC_PVT_8d', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(64, 'Magwero DEC', 'MAG_LIL_17', 'Central', 'Lilongwe', ' P.O. Box 40859,  Kanengo', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(65, 'Malikha DEC', 'MAL_LIL_b6', 'Central', 'Lilongwe', ' P.O. Box 40623,  Kanengo', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(66, 'Malingunde DEC', 'MAL_LIL_f0', 'Central', 'Lilongwe', ' P.O. Box 79,  Sinyala', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(67, 'Malomo CDSS', 'MAL_NTC_54', 'Central', 'Ntchisi', ' P/Bag 141', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(68, 'Marist Secondary School', 'MAR_DED_97', 'Central', 'Dedza', ' P.O. Box 46,  Malirana', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(69, 'Mast Day', 'MAS_PVT_87', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(70, 'Mchisu CDSS', 'MCH_DED_e6', 'Central', 'Dedza', ' P.O. Box 126', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(71, 'Mikundi DEC', 'MIK_LIL_49', 'Central', 'Lilongwe', ' P.O. Box 14,  Msanama', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(72, 'Misale CDSS', 'MIS_MCH_2c', 'Central', 'Mchinji', ' P.O. Box 15,  Tembwe', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(73, 'Mkhota CDSS', 'MKH_KAS_74', 'Central', 'Kasungu', ' P.O. Box 9', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(74, 'Mkomachi CDSS', 'MKO_LIL_e2', 'Central', 'Lilongwe', ' P.O. Box 40103,  Kanengo', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(75, 'Mkwichi DEC', 'MKW_LIL_8f', 'Central', 'Lilongwe', ' P.O. Box 30676', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(76, 'Mkwichi Secondary School', 'MKW_LIL_06', 'Central', 'Lilongwe', ' P/Bag 249', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(77, 'Mpingu CDSS', 'MPI_LIL_3e', 'Central', 'Lilongwe', ' P/Bag 6', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(78, 'Mtenthera CDSS', 'MTE_LIL_ba', 'Central', 'Lilongwe', ' P.O. Box 37,  Mbuna', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(79, 'Mtunthama Saints CDSS', 'MTU_KAS_ad', 'Central', 'Kasungu', ' P/Bag 4,  Mtunthama', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(80, 'Mvera CDSS', 'MVE_DOW_b8', 'Central', 'Dowa', ' P.O. Box 40', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(81, 'Mvera Girls', 'MVE_PVT_c1', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(82, 'Nanthomba CDSS', 'NAN_DOW_c1', 'Central', 'Dowa', ' P.O. Box 146', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(83, 'Natola CDSS', 'NAT_DOW_70', 'Central', 'Dowa', ' P.O. Box 168,  Madisi', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(84, 'Nkhoma CDSS', 'NKH_LIL_69', 'Central', 'Lilongwe', ' P.O. Box 46', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(85, 'Sevec', 'SEV_PVT_1f', 'Central', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(86, 'Tsokankanansi DEC', 'TSO_LIL_b9', 'Central', 'Lilongwe', ' P/Bag B-370', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(87, 'Aim High', 'AIM_PVT_c4', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(88, 'ALMA', 'ALM_PVT_5a', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(89, 'ARMY Secondary School', 'ARM_LUN_4d', 'Southern', 'Lunzu', ' P/Bag 91', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(90, 'ASTEPI', 'AST_PVT_14', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(91, 'Bakhita DEC', 'BAK_BAL_7a', 'Southern', 'Balaka', ' P.O. Box 62', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(92, 'Balaka Secondary School', 'BAL_BAL_04', 'Southern', 'Balaka', ' P.O. Box 222', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(93, 'Balamanja DEC', 'BAL_MAS_e2', 'Southern', 'Masaula', ' Chingale,  Zomba,  P.O. Box 30', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(94, 'Bangula Secondary School', 'BAN_CHI_d6', 'Southern', 'Chiromo', ' P/Bag 2', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(95, 'Bangwe', 'BAN_PVT_23', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(96, 'Bangwe Catholic DEC', 'BAN_BAN_7b', 'Southern', 'Bangwe', ' Blantyre,  P.O. Box 90246', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(97, 'Berelin', 'BER_PVT_5e', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(98, 'Bethel', 'BET_PVT_d0', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(99, 'Bilila CDSS', 'BIL_BIL_54', 'Southern', 'Bilila', ' P.O. Box 41', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(100, 'Blantyre Secondary School', 'BLA_BLA_92', 'Southern', 'Blantyre', ' P/Bag 10', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(101, 'Bvumbwe', 'BVU_PVT_9a', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(102, 'Bvumbwe CDSS', 'BVU_THY_e9', 'Southern', 'Thyolo', ' P.O. Box 43', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(103, 'Cathie', 'CAT_PVT_93', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(104, 'Chambe CDSS', 'CHA_MUL_ef', 'Southern', 'Mulanje', ' P.O. Box 510', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(105, 'Chambe Secondary School', 'CHA_MUL_17', 'Southern', 'Mulanje', ' P.O. Box 2', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(106, 'Changali CDSS', 'CHA_MAN_59', 'Southern', 'Mangochi', ' P/Bag 23', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(107, 'Charles Lwanga CDSS', 'CHA_BAL_45', 'Southern', 'Balaka', ' P.O. Box 482', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(108, 'Chichiri Secondary School', 'CHI_BLA_00', 'Southern', 'Blantyre', ' P/Bag 304', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(109, 'Chididi CDSS', 'CHI_NSA_10', 'Southern', 'Nsanje', ' P.O. Box 8', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(110, 'Chikhwaza CDSS', 'CHI_MUL_44', 'Southern', 'Mulanje', ' P.O. Box 196,  Luchenza', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(111, 'Chilimba CDSS', 'CHI_MAC_61', 'Southern', 'Machinga', 'Machinga', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(112, 'Chikwawa Boys Secondary School', 'CHI_CHI_c2', 'Southern', 'Chikwawa', ' P.O. Box 5', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(113, 'Chiradzulu Secondary School', 'CHI_CHI_84', 'Southern', 'Chiradzulu', ' P/Bag 3', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(114, 'Dziwe CDSS', 'DZI_BAL_86', 'Southern', 'Balaka', 'Balaka', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(115, 'H. H. I. Secondary School', 'HHI_BLA_d7', 'Southern', 'Blantyre', ' P.O. Box 65', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(116, 'Hope CDSS', 'HOP_MAC_a2', 'Southern', 'Machinga', 'Machinga', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(117, 'Limbe CDSS', 'LIM_BLA_9a', 'Southern', 'Blantyre', 'Blantyre', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(118, 'Likangala Secondary School', 'LIK_ZOM_a4', 'Southern', 'Zomba', ' P/Bag 16', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(119, 'Lisumbwi Secondary School', 'LIS_MAN_ec', 'Southern', 'Mangochi', ' P/Bag 3,  Monkey Bay', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(120, 'Londola CDSS', 'LON_ZOM_d1', 'Southern', 'Zomba', 'Zomba', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(121, 'Luchenza Secondary School', 'LUC_LUC_79', 'Southern', 'Luchenza', ' P.O. Box 84', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(122, 'Lunzu Secondary School', 'LUN_LUN_11', 'Southern', 'Lunzu', ' P.O. Box 130', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(123, 'Malosa Secondary School', 'MAL_ZOM_39', 'Southern', 'Zomba', ' P/Bag 3,  Chilema', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(124, 'Mangochi Boys Secondary School', 'MAN_MAN_6a', 'Southern', 'Mangochi', ' P/Bag 1', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(125, 'Mlanda Secondary School', 'MLA_NTC_be', 'Southern', 'Ntcheu', ' P/Bag 1,  Lizulu', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(126, 'Mountain View Secondary School', 'MOU_THY_f1', 'Southern', 'Thyolo', ' P/Bag 12,  Bvumbwe', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(127, 'Mulanje Secondary School', 'MUL_MUL_5b', 'Southern', 'Mulanje', ' P.O. Box 61', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(128, 'Mulunguzi Secondary School', 'MUL_ZOM_e4', 'Southern', 'Zomba', ' P.O. Box 138', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(129, 'Mwanza Boys Secondary School', 'MWA_MWA_f5', 'Southern', 'Mwanza', ' P/Bag 2', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(130, 'Namalomba CDSS', 'NAM_BAL_80', 'Southern', 'Balaka', 'Balaka', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(131, 'Nanjiriri CDSS', 'NAN_BLA_24', 'Southern', 'Blantyre Urban', ' P.O. Box 5536,  Limbe', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(132, 'Nankumba CDSS', 'NAN_BLA_26', 'Southern', 'Blantyre Rural', ' P.O. Box 29,  Mbane', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(133, 'Nkhate CDSS', 'NKH_CHI_36', 'Southern', 'Chikwawa', 'Chikwawa', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(134, 'Nasawa Secondary School', 'NAS_ZOM_5b', 'Southern', 'Zomba', ' P.O. Box 10,  Magomero,  also known as Chimwalira Secondary School', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(135, 'Ngabu Secondary School', 'NGA_CHI_14', 'Southern', 'Chikwawa', ' P/Bag 6', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(136, 'Nsanje Boys Secondary School', 'NSA_NSA_fb', 'Southern', 'Nsanje', ' P.O. Box 40', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(137, 'Phalombe Secondary School', 'PHA_PHA_93', 'Southern', 'Phalombe', ' P.O. Box 142', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(138, 'Police Secondary School', 'POL_ZOM_f3', 'Southern', 'Zomba', ' P.O. Box 41', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(139, 'Providence Girls Secondary School', 'PRO_MUL_f2', 'Southern', 'Mulanje', ' P.O. Box 136', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(140, 'Soche Hill Secondary School', 'SOC_BLA_a7', 'Southern', 'Blantyre', ' P.O. Box 5692,  Limbe', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(141, 'St. Marys Girls Secondary School', 'STM_ZOM_cb', 'Southern', 'Zomba', ' P.O. Box 149', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(142, 'St. Michels Girls Secondary School', 'STM_MAN_8b', 'Southern', 'Mangochi', ' P/Bag 3', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(143, 'St. Patricks Boys Secondary School', 'STP_BLA_2e', 'Southern', 'Blantyre', ' P.O. Box 5450,  Limbe', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(144, 'Stella Maris Girls Secondary School', 'STE_BLA_74', 'Southern', 'Blantyre', ' P/Bag 42', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(145, 'Thyolo Secondary School', 'THY_THY_b7', 'Southern', 'Thyolo', ' P.O. Box 34', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(146, 'Zingwangwa Secondary School', 'ZIN_BLA_3c', 'Southern', 'Blantyre', ' P/Bag 46,  Soche', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(147, 'Zomba Boys Secondary School', 'ZOM_ZOM_30', 'Southern', 'Zomba', ' P.O. Box 2', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(148, 'Zomba Urban CDSS', 'ZOM_ZOM_2e', 'Southern', 'Zomba', ' P.O. Box 460', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(149, 'Bedir International', 'BED_PVT_6b', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(150, 'Bedir Star International', 'BED_PVT_d1', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(151, 'Tukombo Girls', 'TUK_PVT_f5', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(152, 'Umodzi', 'UMO_PVT_a6', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(153, 'Vonken CDSS', 'VON_MUL_e1', 'Southern', 'Mulanje', ' P.O. Box 15,  Mimosa,  small private', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(154, 'Wilberforce', 'WIL_PVT_59', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(155, 'Chikuli CDSS', 'CHI_BLA_81', 'Southern', 'Blantyre', ' P/A Chikowa,  P.O. Chileka', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(156, 'Chilangoma DEC', 'CHI_BLA_f0', 'Southern', 'Blantyre', ' P.O. Box 49,  Chileka', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(157, 'Chilipa CDSS', 'CHI_BAL_4d', 'Southern', 'Balaka', ' P.O. Box 80,  Mtobwa', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(158, 'Chilomoni', 'CHI_PVT_19', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(159, 'Chimbale', 'CHI_PVT_09', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(160, 'Chimkwezule CDSS', 'CHI_MAC_5c', 'Southern', 'Machinga', ' P.O. Box 33', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(161, 'Chimwalira Secondary School', 'CHI_CHI_e9', 'Southern', 'Chiradzulu', ' P.O. Box 10,  Magomero,  also known as Nasawa Secondary School', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(162, 'Chimwankhunda DEC', 'CHI_BLA_76', 'Southern', 'Blantyre', ' P.O. Box 2575', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(163, 'Chinamwali', 'CHI_PVT_80', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(164, 'Chiringa CDSS', 'CHI_MUL_83', 'Southern', 'Mulanje', ' P.O. Box 46', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(165, 'Chisomo', 'CHI_PVT_dc', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(166, 'Chiyambi', 'CHI_PVT_13', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(167, 'DDK and N Girls', 'DDK_PVT_e6', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(168, 'Debora', 'DEB_PVT_d6', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(169, 'Denis', 'DEN_PVT_f1', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(170, 'Domasi', 'DOM_PVT_3b', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(171, 'Dombole Secondary School', 'DOM_NTC_8a', 'Southern', 'Ntcheu', ' P.O. Box 375', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(172, 'Dzendje CDSS', 'DZE_LUC_79', 'Southern', 'Luchenza', ' P.O. Box 57,  Mbiza', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(173, 'Jamia Islamia', 'JAM_PVT_67', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(174, 'Johnstone', 'JOH_PVT_c3', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(175, 'Joyce Banda Foundation', 'JOY_PVT_0e', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(176, 'Kabichi DEC', 'KAB_MUL_81', 'Southern', 'Mulanje', ' P.O. Box 72,  Mimosa', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(177, 'Kachingwe DEC', 'KAC_CHI_de', 'Southern', 'Chiradzulu', ' P.O. Box 17,  Njuli', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(178, 'Kamacha', 'KAM_PVT_2a', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(179, 'Kaphuka', 'KAP_PVT_4e', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(180, 'Kaporo', 'KAP_PVT_b5', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(181, 'Katamba DEC', 'KAT_ZOM_88', 'Southern', 'Zomba', ' P.O. Box 5,  Sakata', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(182, 'Khola CDSS', 'KHO_NTC_83', 'Southern', 'Ntcheu', ' P.O. Box 72,  Kasinje', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(183, 'Kings Foundation', 'KIN_PVT_ae', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(184, 'Kirk Range', 'KIR_PVT_a7', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(185, 'Ligowe Secondary School', 'LIG_BVU_c8', 'Southern', 'Bvumbwe', ' P.O. Box 124', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(186, 'Likanani CDSS', 'LIK_MUL_32', 'Southern', 'Mulanje', ' P.O. Box 21,  Sukasanje', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(187, 'Likudzi CDSS', 'LIK_NTC_d2', 'Southern', 'Ntcheu', ' P.O. Box 133,  Senzani', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(188, 'Limbe DEC', 'LIM_BLA_ea', 'Southern', 'Blantyre', ' P.O. Box 5378', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(189, 'Litchenza CDSS', 'LIT_LUC_a5', 'Southern', 'Luchenza', ' P.A. Chimwawa,  P.O. Luchenza', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(190, 'Livunzu CDSS', 'LIV_CHI_45', 'Southern', 'Chikwawa', ' P/A Makhwila', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(191, 'Liwonde', 'LIW_PVT_7b', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(192, 'Liwonde Secondary School', 'LIW_LIW_39', 'Southern', 'Liwonde', ' P/Bag 18', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(193, 'Lizulu CDSS', 'LIZ_NTC_ca', 'Southern', 'Ntcheu', ' P.O. Box 4', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(194, 'Llwonde DEC', 'LLW_LIW_c1', 'Southern', 'Liwonde', ' P.O. Box 130', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(195, 'Luchenza', 'LUC_PVT_c9', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(196, 'Luchenza CDSS', 'LUC_LUC_95', 'Southern', 'Luchenza', ' P.O. Box 38', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(197, 'Lumbira CDSS', 'LUM_BLA_0b', 'Southern', 'Blantyre', ' P.O. Box 70023,  Chilomoni', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(198, 'Lunzu Night Secondary School', 'LUN_LUN_84', 'Southern', 'Lunzu', ' P.O. Box 130', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(199, 'Madalo', 'MAD_PVT_4c', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(200, 'Maera CDSS', 'MAE_CHI_0c', 'Southern', 'Chiradzulu', ' P.O. Box 62,  Namadzi', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(201, 'Magomero DEC', 'MAG_ZOM_b3', 'Southern', 'Zomba', ' P.O. Box 39', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(202, 'Magoti CDSS', 'MAG_CHI_07', 'Southern', 'Chiromo', ' P.O. Box 43,  Sorgin', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(203, 'Makande CDSS', 'MAK_CHI_b1', 'Southern', 'Chikwawa', ' P.O. Box 18,  Ngabu', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(204, 'Makapwa CDSS', 'MAK_THY_35', 'Southern', 'Thyolo', ' P.O. Box 24,  Sandama', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(205, 'Makhanga CDSS', 'MAK_NSA_d2', 'Southern', 'Nsanje', ' P.O. Box 68,  Chiromo', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(206, 'Malamulo Secondary School', 'MAL_THY_5c', 'Southern', 'Thyolo', ' P/Bag 3,  Makwasa', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(207, 'Malepera CDSS', 'MAL_KAS_bd', 'Southern', 'Kasungu', ' P/Bag 151,  cross-regional', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(208, 'Malombe Secondary School', 'MAL_MAN_51', 'Southern', 'Mangochi', ' P/Bag 1', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(209, 'Mangochi', 'MAN_PVT_8c', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(210, 'Mapanga CDSS', 'MAP_BVU_89', 'Southern', 'Bvumbwe', ' P/Bag 19', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(211, 'Mapazi CDSS', 'MAP_CHI_b8', 'Southern', 'Chiradzulu', ' P.O. Box 150,  Njuli', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(212, 'Matandani Secondary School', 'MAT_MWA_bc', 'Southern', 'Mwanza', ' P.O. Box 60,  Neno', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(213, 'Matope DEC', 'MAT_NTC_0b', 'Southern', 'Ntcheu', ' P.O. Box 16', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(214, 'Mawiri CDSS', 'MAW_NTC_a6', 'Southern', 'Ntcheu', ' P/Bag 37', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(215, 'Mayaka CDSS', 'MAY_ZOM_17', 'Southern', 'Zomba', ' P.O. Box 49', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(216, 'Mdeka CDSS', 'MDE_BLA_78', 'Southern', 'Blantyre', ' P.O. Box 60', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(217, 'Mdika CDSS', 'MDI_BLA_dd', 'Southern', 'Blantyre', ' P.O. Box 48,  Nambuma', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(218, 'Mdinde DEC', 'MDI_MAN_60', 'Southern', 'Mangochi', ' P/A Katuli,  Namwera', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(219, 'Mendulo CDSS', 'MEN_LUC_6c', 'Southern', 'Luchenza', ' P.O. Box 297', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(220, 'Michiru View', 'MIC_PVT_f3', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(221, 'Migowi CDSS', 'MIG_PHA_80', 'Southern', 'Phalombe', ' P.O. Box 10', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(222, 'Milonde CDSS', 'MIL_MUL_9b', 'Southern', 'Mulanje', ' P.O. Box 24', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(223, 'Mpingwe CDSS', 'MPI_BLA_7b', 'Southern', 'Blantyre', ' P.O. Box 90524,  Bangwe', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(224, 'Mpita', 'MPI_PVT_2b', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(225, 'Mpumbe CDSS', 'MPU_CHI_8c', 'Southern', 'Chiradzulu', ' P.O. Box 18,  Njuli', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(226, 'Msambanjati CDSS', 'MSA_THY_98', 'Southern', 'Thyolo', ' P.O. Box 10', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(227, 'Msonkhamanja Secondary School', 'MSO_LIL_06', 'Southern', 'Lilongwe', ' P.O. Box 183,  cross-regional', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(228, 'Mthumba CDSS', 'MTH_CHI_aa', 'Southern', 'Chikwawa', ' P.O. Box 136', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(229, 'Mulanje Mission CDSS', 'MUL_MUL_12', 'Southern', 'Mulanje', ' P.O. Box 309', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(230, 'Mulomba CDSS', 'MUL_NSA_81', 'Southern', 'Nsanje', ' P.O. Box 18', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(231, 'Muloza CDSS', 'MUL_MUL_ee', 'Southern', 'Mulanje', ' P.O. Box 46', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(232, 'Mulunguzi DEC', 'MUL_BLA_74', 'Southern', 'Blantyre', ' P/Bag 204', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(233, 'Muona DEC', 'MUO_NSA_1f', 'Southern', 'Nsanje', ' P.O. Box 77', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(234, 'Namadzi CDSS', 'NAM_CHI_a2', 'Southern', 'Chiradzulu', ' P/Bag 6', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(235, 'Namandanje CDSS', 'NAM_MAC_fa', 'Southern', 'Machinga', ' P/Bag 20,  Ntaja', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(236, 'Nambuma DEC', 'NAM_BLA_00', 'Southern', 'Blantyre', ' P.O. Box 38', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(237, 'Namisonga CDSS', 'NAM_ZOM_91', 'Southern', 'Zomba', ' P/Bag 2,  Jali', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(238, 'Namitembo DEC', 'NAM_ZOM_6b', 'Southern', 'Zomba', ' P.O. Box 11,  Chingale', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(239, 'Namwera', 'NAM_PVT_c8', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(240, 'Namwera DEC', 'NAM_MAN_2d', 'Southern', 'Mangochi', ' P/Bag 15', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(241, 'Namwera Girls DEC', 'NAM_MAN_d3', 'Southern', 'Mangochi', ' P/Bag 20', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(242, 'Nankhundi CDSS', 'NAN_CHI_cc', 'Southern', 'Chiradzulu', ' P.O. Box 112', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(243, 'Nazarene Mission Secondary School', 'NAZ_BLA_9d', 'Southern', 'Blantyre', ' P.O. Box 51073,  Limbe', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(244, 'Nchalo DEC', 'NCH_CHI_8c', 'Southern', 'Chikwawa', ' P.O. Box 145', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(245, '**Neno CDSS (Mwanza, P.O. Box 14, N impep.com/using-x/creating-a-post/20250903205639175', 'NEN_UNK_47', 'Southern', 'Unknown', 'Unknown', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(246, 'New Era Boys', 'NEW_PVT_6e', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(247, 'New Era Girls', 'NEW_PVT_26', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(248, 'Nguludi Secondary School', 'NGU_BLA_60', 'Southern', 'Blantyre', ' P.O. Box 90336,  Bangwe', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(249, 'Njamba DEC', 'NJA_BLA_4a', 'Southern', 'Blantyre', ' P.O. Box 19,  Chileka', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(250, 'Njamba Secondary School', 'NJA_BLA_af', 'Southern', 'Blantyre', ' P/Bag 392,  Chichiri', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(251, 'Njerenjere Secondary School', 'NJE_MZU_c9', 'Southern', 'Mzuzu', ' P.O. Box 641,  cross-regional', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(252, 'Njolomole CDSS', 'NJO_NTC_33', 'Southern', 'Ntcheu', ' P.O. Box 45,  Mlangeni', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(253, 'Nkhamenya', 'NKH_PVT_b0', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(254, 'Nsala CDSS', 'NSA_ZOM_23', 'Southern', 'Zomba', ' P.O. Box 467', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(255, 'Nsanje CDSS', 'NSA_NSA_f7', 'Southern', 'Nsanje', ' P.O. Box 41', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(256, 'Nsipe CDSS', 'NSI_NTC_04', 'Southern', 'Ntcheu', ' P.O. Box 35,  Kampepuza', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(257, 'Nsondole CDSS', 'NSO_ZOM_58', 'Southern', 'Zomba', ' P.O. Box 137,  Domasi', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(258, 'Nsoni CDSS', 'NSO_CHI_a8', 'Southern', 'Chiradzulu', ' P.O. Box 64,  Namitambo', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(259, 'Ntaja DEC', 'NTA_MAC_06', 'Southern', 'Machinga', ' P/B 1', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(260, 'Ntambanyama CDSS', 'NTA_THY_92', 'Southern', 'Thyolo', ' P.O. Box 3', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(261, 'Ntonda CDSS', 'NTO_NTC_f2', 'Southern', 'Ntcheu', ' P/A Matale', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(262, 'Ntonya', 'NTO_PVT_15', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(263, 'Nyachilenda DEC', 'NYA_NSA_b0', 'Southern', 'Nsanje', ' P.O. Box 66,  Marka', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(264, 'Nyambadwe CDSS', 'NYA_BLA_2a', 'Southern', 'Blantyre', ' P.O. Box 1914', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06');
INSERT INTO `secondary_schools` (`id`, `name`, `code`, `region`, `district`, `address`, `phone`, `email`, `capacity`, `facilities`, `is_active`, `latitude`, `longitude`, `created_at`, `updated_at`) VALUES
(265, 'Nyungwe CDSS', 'NYU_CHI_ee', 'Southern', 'Chiradzulu', ' P.O. Box 58,  Namadzi', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(266, 'Perkins Girls', 'PER_PVT_34', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(267, 'Phalula CDSS', 'PHA_BAL_66', 'Southern', 'Balaka', ' P.O. Box 84', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(268, 'Phanda DEC', 'PHA_CHI_5d', 'Southern', 'Chikwawa', ' P.O. Box 94,  Ngabu', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(269, 'Phwadzi CDSS', 'PHW_CHI_00', 'Southern', 'Chikwawa', ' P/Bag 4', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(270, 'PIM CDSS', 'PIM_NSA_6c', 'Southern', 'Nsanje', ' P.O. Box 13,  Chisombezi', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(271, 'Pirimiti CDSS', 'PIR_ZOM_4e', 'Southern', 'Zomba', ' P/Bag 1,  Jali', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(272, 'Precious', 'PRE_PVT_8a', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(273, 'Puteya', 'PUT_PVT_a7', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(274, 'Radson', 'RAD_PVT_1d', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(275, 'Radson Boys', 'RAD_PVT_43', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(276, 'Sacred Heart CDSS', 'SAC_ZOM_40', 'Southern', 'Zomba', ' P.O. Box 566', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(277, 'Sakata', 'SAK_PVT_cb', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(278, 'Santhe', 'SAN_PVT_b4', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(279, 'Sharpevalle CDSS', 'SHA_NTC_7a', 'Southern', 'Ntcheu', ' P.O. Bwanje', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(280, 'Soche Progressive', 'SOC_PVT_4a', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(281, 'Songani CDSS', 'SON_ZOM_30', 'Southern', 'Zomba', ' P/Bag 1,  Domasi', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(282, 'South Lunzu DEC', 'SOU_BLA_ea', 'Southern', 'Blantyre', ' P.O. Box 643', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(283, 'St Anthony CDSS', 'STA_ZOM_3d', 'Southern', 'Zomba', ' P/Bag 2,  Thondwe', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(284, 'St Augustine CDSS', 'STA_NKH_fe', 'Southern', 'Nkhata Bay', ' P.O. Box 88,  cross-regional', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(285, 'St Bapton', 'STB_PVT_b1', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(286, 'St Dominics', 'STD_PVT_85', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(287, 'St Kizito CDSS', 'STK_BLA_d2', 'Southern', 'Blantyre', ' P.O. Box 5541,  Limbe', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(288, 'St Louis Montfort DEC', 'STL_BAL_c2', 'Southern', 'Balaka', ' P.O. Box 420', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(289, 'St Marys CDSS', 'STM_MAC_12', 'Southern', 'Machinga', ' P/Bag 19,  Ntaja', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(290, 'St Monica DEC', 'STM_MAN_ea', 'Southern', 'Mangochi', ' P.O. Box 424', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(291, 'St Pauls CDSS', 'STP_BLA_0e', 'Southern', 'Blantyre', ' P.O. Box 18,  Soche', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(292, 'St Pius DEC', 'STP_BLA_49', 'Southern', 'Blantyre', ' P.O. Box 18,  Soche', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(293, 'Swama', 'SWA_PVT_8f', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(294, 'Thambani DEC', 'THA_MWA_a9', 'Southern', 'Mwanza', ' P.O. Box 34', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(295, 'Thandizo', 'THA_PVT_1b', 'Southern', 'Pvt', 'Pvt', NULL, NULL, 400, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(296, 'Thekerani DEC', 'THE_THY_ea', 'Southern', 'Thyolo', ' P.O. Box 47', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(297, 'Thuchila DEC', 'THU_MUL_06', 'Southern', 'Mulanje', ' P.O. Box 44', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(298, 'Thunga CDSS', 'THU_BVU_5d', 'Southern', 'Bvumbwe', ' P.O. Box 58', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(299, 'Ulongwe DEC', 'ULO_MAC_bc', 'Southern', 'Machinga', ' P.O. Box 43', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(300, 'Waliranji CDSS', 'WAL_LIL_e7', 'Southern', 'Lilongwe', ' P.O. Box 372,  Namitete,  cross-regional', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(301, 'Wanda CDSS', 'WAN_MCH_7f', 'Southern', 'Mchinji', ' P.O. Box 208,  Mkanda', NULL, NULL, 300, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06'),
(302, 'Zomba CCAP DEC', 'ZOM_ZOM_f6', 'Southern', 'Zomba', ' P.O. Box 460', NULL, NULL, 200, '[\"Classrooms\", \"Library\"]', 1, NULL, NULL, '2025-09-04 13:26:06', '2025-09-04 13:26:06');

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
-- Table structure for table `shared_resources`
--

CREATE TABLE `shared_resources` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `community_post_id` bigint UNSIGNED DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `external_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mime_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_size` bigint DEFAULT NULL,
  `tags` json DEFAULT NULL,
  `subject_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `downloads_count` int NOT NULL DEFAULT '0',
  `views_count` int NOT NULL DEFAULT '0',
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
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

--
-- Dumping data for table `site_contents`
--

INSERT INTO `site_contents` (`id`, `key`, `title`, `content`, `meta_data`, `is_active`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'hero_title', 'Hero Section Title', 'Unlock Your Potential with StudySeco - Excellence in Malawian Secondary Education', '\"{\\\"section\\\":\\\"hero\\\",\\\"priority\\\":1}\"', 1, 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(2, 'hero_subtitle', 'Hero Section Subtitle', 'Comprehensive online learning platform designed specifically for Malawian secondary school students', '\"{\\\"section\\\":\\\"hero\\\",\\\"priority\\\":2}\"', 1, 2, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(3, 'about_title', 'About Section Title', 'About StudySeco', '\"{\\\"section\\\":\\\"about\\\",\\\"priority\\\":1}\"', 1, 3, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(4, 'about_content', 'About Section Content', 'StudySeco is dedicated to providing quality education resources tailored specifically for Malawian secondary school students. Our platform offers comprehensive study materials aligned with the national curriculum.', '\"{\\\"section\\\":\\\"about\\\",\\\"priority\\\":2}\"', 1, 4, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(5, 'features_title', 'Features Section Title', 'Why Choose StudySeco?', '\"{\\\"section\\\":\\\"features\\\",\\\"priority\\\":1}\"', 1, 5, '2025-09-04 08:06:01', '2025-09-04 08:06:01');

-- --------------------------------------------------------

--
-- Table structure for table `student_school_selections`
--

CREATE TABLE `student_school_selections` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `secondary_school_id` bigint UNSIGNED NOT NULL,
  `priority_order` int NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `rejection_reason` text COLLATE utf8mb4_unicode_ci,
  `confirmed_at` timestamp NULL DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `student_school_selections`
--

INSERT INTO `student_school_selections` (`id`, `user_id`, `secondary_school_id`, `priority_order`, `status`, `rejection_reason`, `confirmed_at`, `rejected_at`, `created_at`, `updated_at`) VALUES
(1, 4, 88, 1, 'confirmed', NULL, '2025-09-04 13:52:23', NULL, '2025-09-04 13:28:10', '2025-09-04 13:52:23'),
(2, 4, 90, 2, 'pending', NULL, NULL, NULL, '2025-09-04 13:28:10', '2025-09-04 13:28:10'),
(3, 4, 91, 3, 'pending', NULL, NULL, NULL, '2025-09-04 13:28:10', '2025-09-04 13:28:10'),
(4, 4, 93, 4, 'pending', NULL, NULL, NULL, '2025-09-04 13:28:10', '2025-09-04 13:28:10'),
(5, 4, 92, 5, 'pending', NULL, NULL, NULL, '2025-09-04 13:28:10', '2025-09-04 13:28:10'),
(6, 3, 1, 1, 'confirmed', NULL, '2025-09-05 13:16:23', NULL, '2025-09-05 13:16:23', '2025-09-05 13:16:23');

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

--
-- Dumping data for table `student_stories`
--

INSERT INTO `student_stories` (`id`, `name`, `location`, `country_flag`, `current_status`, `story`, `achievements`, `msce_credits`, `avatar_color_from`, `avatar_color_to`, `achievement_icon`, `is_featured`, `is_active`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'Temwa Chisale', 'Lilongwe', '🇲🇼', 'University of Cape Town - Medical Student', 'StudySeco helped me excel in my MSCE examinations. The comprehensive study materials and practice tests prepared me well for university admission. Now I am pursuing my dream of becoming a doctor.', '\"[\\\"MSCE 9 Credits\\\",\\\"UCT Medical School Admission\\\",\\\"Academic Excellence Award\\\"]\"', 9, 'emerald-500', 'blue-500', '🎓', 1, 1, 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(2, 'James Mwale', 'Blantyre', '🇲🇼', 'Chancellor College - Engineering Student', 'The mathematics and science resources on StudySeco were exceptional. I was able to understand complex concepts through the clear explanations and interactive content.', '\"[\\\"MSCE 8 Credits\\\",\\\"Engineering Scholarship\\\",\\\"Top 5% National Performance\\\"]\"', 8, 'blue-500', 'purple-500', '🏆', 1, 1, 2, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(3, 'Grace Banda', 'Mzuzu', '🇲🇼', 'Mzuzu University - Education Student', 'StudySeco transformed my approach to learning. The English and Chichewa language resources helped me improve my communication skills significantly.', '\"[\\\"MSCE 7 Credits\\\",\\\"Teaching Diploma\\\",\\\"Community Service Award\\\"]\"', 7, 'purple-500', 'pink-500', '⭐', 0, 1, 3, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(4, 'Temwa Mwale', 'London, UK', '🇬🇧', 'University of Edinburgh - Engineering', 'StudySeco allowed me to complete my Malawian secondary education while living in London. The teachers were incredible, and I passed my MSCE with 6 credits!', '[\"MSCE 6 Credits\", \"Engineering Student\", \"Top Performer\"]', 6, 'emerald-500', 'blue-500', '🎓', 1, 1, 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(5, 'Grace Kachingwe', 'Toronto, Canada', '🇨🇦', 'University of Toronto - Medicine', 'The flexibility of studying online while maintaining the Malawian curriculum was perfect. I achieved my dream of studying medicine in Canada!', '[\"MSCE 8 Credits\", \"Medical Student\", \"Scholarship Winner\"]', 8, 'purple-500', 'pink-500', '🏆', 1, 1, 2, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(6, 'James Nyirenda', 'Sydney, Australia', '🇦🇺', 'UNSW Sydney - MBA Student', 'StudySeco prepared me well for university. The quality of education was exceptional, and I\'m now pursuing my MBA while working in Sydney.', '[\"MSCE 7 Credits\", \"MBA Student\", \"Business Leader\"]', 7, 'orange-500', 'red-500', '💼', 1, 1, 3, '2025-09-04 08:06:01', '2025-09-04 08:06:01');

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
(1, 'English', 'ENG', 'English Language and Communication Skills - essential for all forms of communication and academic success', 'Languages', 'Forms 1-4', 1, NULL, NULL, 1, 1, 'core', 1, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(2, 'Chichewa', 'CHI', 'National language of Malawi - preserving cultural heritage and local communication', 'Languages', 'Forms 1-4', 1, NULL, NULL, 1, 1, 'core', 2, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(3, 'Mathematics', 'MATH', 'Pure and Applied Mathematics - building logical thinking and problem-solving skills', 'Sciences', 'Forms 1-4', 1, NULL, NULL, 1, 1, 'core', 3, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(4, 'Life Skills', 'LS', 'Personal development, health education, and practical life skills', 'General Studies', 'Forms 1-2', 1, NULL, NULL, 1, 1, 'core', 4, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(5, 'Biology', 'BIO', 'Study of living organisms and life processes - foundation for medical and biological sciences', 'Sciences', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'science', 5, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(6, 'Physical Science', 'PHYS', 'Integrated Physics and Chemistry for Forms 1-2 - building scientific foundation', 'Sciences', 'Forms 1-2', 1, NULL, NULL, 1, 0, 'science', 6, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(7, 'Chemistry', 'CHEM', 'Study of matter, its properties and reactions - essential for pharmaceutical and chemical industries', 'Sciences', 'Forms 3-4', 1, NULL, NULL, 1, 0, 'science', 7, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(8, 'Physics', 'PHY', 'Study of matter, energy and their interactions - foundation for engineering and technology', 'Sciences', 'Forms 3-4', 1, NULL, NULL, 1, 0, 'science', 8, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(9, 'Geography', 'GEO', 'Physical and human geography of Malawi and the world - understanding our environment', 'Humanities', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'humanities', 9, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(10, 'History', 'HIST', 'Malawian, African and World History - understanding our past to shape the future', 'Humanities', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'humanities', 10, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(11, 'Social Studies', 'SS', 'Civic education, government and society - preparing responsible citizens', 'Humanities', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'humanities', 11, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(12, 'Bible Knowledge', 'BK', 'Christian religious education and moral values', 'Humanities', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'humanities', 12, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(13, 'Agriculture', 'AGR', 'Agricultural practices, crop production and livestock management - vital for Malawi\'s economy', 'Technical', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'technical', 13, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(14, 'Home Economics', 'HE', 'Food and nutrition, family management, and household skills', 'Technical', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'technical', 14, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(15, 'Technical Drawing', 'TD', 'Engineering drawing and design fundamentals - foundation for engineering careers', 'Technical', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'technical', 15, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(16, 'Business Studies', 'BS', 'Entrepreneurship, business management and commercial practices', 'Commerce', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'commerce', 16, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(17, 'French', 'FR', 'French language and culture - opening opportunities for international communication', 'Languages', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'language', 17, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(18, 'Computer Studies', 'CS', 'Basic computer literacy, programming fundamentals and digital literacy', 'Technology', 'Forms 1-4', 1, NULL, NULL, 1, 0, 'technology', 18, '2025-09-04 08:06:01', '2025-09-04 08:06:01');

-- --------------------------------------------------------

--
-- Table structure for table `support_chats`
--

CREATE TABLE `support_chats` (
  `id` bigint UNSIGNED NOT NULL,
  `session_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `agent_id` bigint UNSIGNED DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'waiting',
  `priority` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal',
  `category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_info` json DEFAULT NULL,
  `started_at` timestamp NULL DEFAULT NULL,
  `assigned_at` timestamp NULL DEFAULT NULL,
  `closed_at` timestamp NULL DEFAULT NULL,
  `queue_position` int DEFAULT NULL,
  `initial_message` text COLLATE utf8mb4_unicode_ci,
  `tags` json DEFAULT NULL,
  `resolution_summary` text COLLATE utf8mb4_unicode_ci,
  `satisfaction_rating` int DEFAULT NULL,
  `satisfaction_feedback` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `support_chats`
--

INSERT INTO `support_chats` (`id`, `session_id`, `user_id`, `agent_id`, `status`, `priority`, `category`, `user_name`, `user_email`, `user_info`, `started_at`, `assigned_at`, `closed_at`, `queue_position`, `initial_message`, `tags`, `resolution_summary`, `satisfaction_rating`, `satisfaction_feedback`, `created_at`, `updated_at`) VALUES
(1, '583fcce7-678a-40cc-a799-43de112c55fd', 3, 1, 'closed', 'normal', 'payment', NULL, NULL, NULL, '2025-09-02 08:06:01', '2025-09-02 09:06:01', '2025-09-03 08:06:01', NULL, 'Hi, I need help with my payment verification. I made a payment yesterday but my account is still not activated.', NULL, 'Payment was verified and account activated successfully.', 5, 'Very helpful and quick response. Thank you!', '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(2, '29471547-90bf-4f12-9f40-d68b55095726', 3, 2, 'active', 'high', 'technical', NULL, NULL, NULL, '2025-09-04 05:06:01', '2025-09-04 06:06:01', NULL, NULL, 'I cannot access the lessons. The page keeps loading but never shows the content.', NULL, NULL, NULL, NULL, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(3, '4f786e4c-5326-4122-98b0-5e60418ab1ef', 3, NULL, 'waiting', 'normal', 'enrollment', NULL, NULL, NULL, '2025-09-04 07:36:01', NULL, NULL, 1, 'Hello, I want to add Mathematics to my subjects. How can I do this?', NULL, NULL, NULL, NULL, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(4, '4fb8eb5c-4822-4880-a76a-1e25a69d05f5', NULL, NULL, 'waiting', 'low', 'general', 'John Guest', 'john@example.com', '{\"phone\": \"+265 999 123 456\", \"location\": \"Lilongwe, Malawi\"}', '2025-09-04 07:51:01', NULL, NULL, 2, 'Hi, I would like to know more about your courses and pricing.', NULL, NULL, NULL, NULL, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(5, '189dd319-bf3f-408d-985c-ddde91bdfc09', 4, 1, 'active', 'low', 'technical', NULL, NULL, NULL, '2025-09-04 13:35:10', '2025-09-04 14:09:18', NULL, NULL, 'gdfgdgfdfgfdgdgfdgdgdgfdgfdg', NULL, NULL, NULL, NULL, '2025-09-04 13:35:10', '2025-09-04 14:09:18');

-- --------------------------------------------------------

--
-- Table structure for table `support_chat_messages`
--

CREATE TABLE `support_chat_messages` (
  `id` bigint UNSIGNED NOT NULL,
  `support_chat_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text',
  `attachments` json DEFAULT NULL,
  `sender_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read_by_user` tinyint(1) NOT NULL DEFAULT '0',
  `is_read_by_agent` tinyint(1) NOT NULL DEFAULT '0',
  `read_by_user_at` timestamp NULL DEFAULT NULL,
  `read_by_agent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `support_chat_messages`
--

INSERT INTO `support_chat_messages` (`id`, `support_chat_id`, `user_id`, `message`, `message_type`, `attachments`, `sender_type`, `is_read_by_user`, `is_read_by_agent`, `read_by_user_at`, `read_by_agent_at`, `created_at`, `updated_at`) VALUES
(1, 1, 3, 'Hi, I need help with my payment verification. I made a payment yesterday but my account is still not activated.', 'text', NULL, 'user', 0, 1, NULL, '2025-09-02 09:06:01', '2025-09-02 08:06:01', '2025-09-04 08:06:01'),
(2, 1, 1, 'Hello! I\'m here to help you with your payment verification. Let me check your account details.', 'text', NULL, 'agent', 1, 0, '2025-09-02 08:08:01', NULL, '2025-09-02 09:07:01', '2025-09-04 08:06:01'),
(3, 1, 3, 'Thank you! My reference number is PAY123456.', 'text', NULL, 'user', 0, 1, NULL, '2025-09-02 09:09:01', '2025-09-02 09:08:01', '2025-09-04 08:06:01'),
(4, 1, 1, 'I found your payment and have verified it. Your account is now activated. You should have full access to all subjects.', 'text', NULL, 'agent', 1, 0, '2025-09-02 09:12:01', NULL, '2025-09-02 09:11:01', '2025-09-04 08:06:01'),
(5, 2, 3, 'I cannot access the lessons. The page keeps loading but never shows the content.', 'text', NULL, 'user', 0, 1, NULL, '2025-09-04 06:06:01', '2025-09-04 05:06:01', '2025-09-04 08:06:01'),
(6, 2, 2, 'Hi! I understand you\'re having trouble accessing lessons. Let me help you troubleshoot this issue.', 'text', NULL, 'agent', 1, 0, '2025-09-04 06:08:01', NULL, '2025-09-04 06:07:01', '2025-09-04 08:06:01'),
(7, 2, 3, 'Yes, it happens on both my phone and computer. The loading spinner just keeps spinning.', 'text', NULL, 'user', 0, 0, NULL, NULL, '2025-09-04 06:09:01', '2025-09-04 08:06:01'),
(8, 3, 3, 'Hello, I want to add Mathematics to my subjects. How can I do this?', 'text', NULL, 'user', 0, 0, NULL, NULL, '2025-09-04 07:36:01', '2025-09-04 08:06:01'),
(9, 4, NULL, 'Hi, I would like to know more about your courses and pricing.', 'text', NULL, 'user', 0, 0, NULL, NULL, '2025-09-04 07:51:01', '2025-09-04 08:06:01'),
(10, 5, 4, '**Subject:** dfgdfgdfgdfg\n\ngdfgdgfdfgfdgdgfdgdgdgfdgfdg', 'text', NULL, 'user', 0, 1, NULL, '2025-09-04 14:09:18', '2025-09-04 13:35:10', '2025-09-04 14:09:18'),
(11, 5, NULL, 'Agent Admin User has joined the chat.', 'system', NULL, 'system', 0, 1, NULL, '2025-09-04 14:09:18', '2025-09-04 14:09:18', '2025-09-04 14:09:18');

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
-- Table structure for table `terms_acceptances`
--

CREATE TABLE `terms_acceptances` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `terms_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'general',
  `terms_version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1.0',
  `accepted_at` timestamp NOT NULL,
  `ip_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `terms_data` json DEFAULT NULL,
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
  `notification_settings` json DEFAULT NULL,
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

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `custom_permissions`, `dashboard_preferences`, `notification_settings`, `is_active`, `last_login_at`, `profile_photo_url`, `phone`, `bio`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin User', 'admin@example.com', NULL, '$2y$12$wR8jvt2MuNAOM0Nt85XJ/ec0DyTmLX5FGNjQIA49OLN.w8XVkY/o.', 'admin', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '2025-09-04 08:06:00', '2025-09-04 08:06:00'),
(2, 'Teacher User', 'teacher@example.com', NULL, '$2y$12$y1M2Pzf564bHDkMkwL4IteGyGRrIZdNQxFDA3j0NevXWBbWEVyw5K', 'teacher', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(3, 'Student User', 'student@example.com', NULL, '$2y$12$QAmqLYXUtL4wEamGHJc1Kuxd6c6aWClxw9O1vCE1AJt9wUc/6Sk1W', 'student', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '2025-09-04 08:06:01', '2025-09-04 08:06:01'),
(4, 'Emmanuel Phiri', 'xtreamcoder2013@gmail.com', '2025-09-04 13:01:44', '$2y$12$QWVJiSKLGg3TWr9owzCMZ.sqFgiwzAFrFzi93OZc2.VoHUNuZ9R7q', 'student', NULL, NULL, NULL, 1, NULL, 'profile-photos/4x4nNWeqqg2FNRgNQNf0pQARQuSjeIHj576o7bGt.jpg', '+27686518342', NULL, NULL, '2025-09-04 08:29:55', '2025-09-05 14:03:53');

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
-- Indexes for table `ai_training_materials`
--
ALTER TABLE `ai_training_materials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ai_training_materials_uploaded_by_foreign` (`uploaded_by`),
  ADD KEY `ai_training_materials_subject_id_type_index` (`subject_id`,`type`),
  ADD KEY `ai_training_materials_grade_level_syllabus_index` (`grade_level`,`syllabus`),
  ADD KEY `ai_training_materials_is_processed_index` (`is_processed`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_logs_user_id_event_index` (`user_id`,`event`),
  ADD KEY `audit_logs_model_type_model_id_index` (`model_type`,`model_id`),
  ADD KEY `audit_logs_created_at_index` (`created_at`);

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
-- Indexes for table `cancellation_requests`
--
ALTER TABLE `cancellation_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cancellation_requests_enrollment_id_foreign` (`enrollment_id`),
  ADD KEY `cancellation_requests_processed_by_foreign` (`processed_by`),
  ADD KEY `cancellation_requests_user_id_status_index` (`user_id`,`status`),
  ADD KEY `cancellation_requests_cancellation_deadline_index` (`cancellation_deadline`),
  ADD KEY `cancellation_requests_requested_at_index` (`requested_at`);

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
-- Indexes for table `community_posts`
--
ALTER TABLE `community_posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `community_posts_type_created_at_index` (`type`,`created_at`),
  ADD KEY `community_posts_user_id_created_at_index` (`user_id`,`created_at`),
  ADD KEY `community_posts_subject_id_created_at_index` (`subject_id`,`created_at`),
  ADD KEY `community_posts_is_featured_is_pinned_created_at_index` (`is_featured`,`is_pinned`,`created_at`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `enrollments_enrollment_number_unique` (`enrollment_number`),
  ADD KEY `enrollments_user_id_foreign` (`user_id`),
  ADD KEY `enrollments_approved_by_foreign` (`approved_by`),
  ADD KEY `enrollments_assigned_tutor_id_foreign` (`assigned_tutor_id`);

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
-- Indexes for table `live_sessions`
--
ALTER TABLE `live_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `live_sessions_subject_id_foreign` (`subject_id`),
  ADD KEY `live_sessions_student_id_status_index` (`student_id`,`status`),
  ADD KEY `live_sessions_tutor_id_status_index` (`tutor_id`,`status`),
  ADD KEY `live_sessions_scheduled_at_index` (`scheduled_at`);

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
-- Indexes for table `post_comments`
--
ALTER TABLE `post_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_comments_user_id_foreign` (`user_id`),
  ADD KEY `post_comments_community_post_id_created_at_index` (`community_post_id`,`created_at`),
  ADD KEY `post_comments_parent_id_created_at_index` (`parent_id`,`created_at`);

--
-- Indexes for table `post_reactions`
--
ALTER TABLE `post_reactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `post_reactions_user_id_community_post_id_type_unique` (`user_id`,`community_post_id`,`type`),
  ADD KEY `post_reactions_community_post_id_type_index` (`community_post_id`,`type`);

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
-- Indexes for table `secondary_schools`
--
ALTER TABLE `secondary_schools`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `secondary_schools_code_unique` (`code`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `shared_resources`
--
ALTER TABLE `shared_resources`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shared_resources_user_id_foreign` (`user_id`),
  ADD KEY `shared_resources_community_post_id_foreign` (`community_post_id`),
  ADD KEY `shared_resources_type_created_at_index` (`type`,`created_at`),
  ADD KEY `shared_resources_subject_id_created_at_index` (`subject_id`,`created_at`);

--
-- Indexes for table `site_contents`
--
ALTER TABLE `site_contents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_contents_key_unique` (`key`),
  ADD KEY `site_contents_key_is_active_index` (`key`,`is_active`),
  ADD KEY `site_contents_is_active_sort_order_index` (`is_active`,`sort_order`);

--
-- Indexes for table `student_school_selections`
--
ALTER TABLE `student_school_selections`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_school_selections_user_id_secondary_school_id_unique` (`user_id`,`secondary_school_id`),
  ADD KEY `student_school_selections_secondary_school_id_foreign` (`secondary_school_id`),
  ADD KEY `student_school_selections_user_id_priority_order_index` (`user_id`,`priority_order`);

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
-- Indexes for table `support_chats`
--
ALTER TABLE `support_chats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `support_chats_session_id_unique` (`session_id`),
  ADD KEY `support_chats_user_id_foreign` (`user_id`),
  ADD KEY `support_chats_status_created_at_index` (`status`,`created_at`),
  ADD KEY `support_chats_agent_id_status_index` (`agent_id`,`status`);

--
-- Indexes for table `support_chat_messages`
--
ALTER TABLE `support_chat_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `support_chat_messages_user_id_foreign` (`user_id`),
  ADD KEY `support_chat_messages_support_chat_id_created_at_index` (`support_chat_id`,`created_at`);

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
-- Indexes for table `terms_acceptances`
--
ALTER TABLE `terms_acceptances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `terms_acceptances_user_id_terms_type_index` (`user_id`,`terms_type`),
  ADD KEY `terms_acceptances_accepted_at_index` (`accepted_at`);

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `achievements`
--
ALTER TABLE `achievements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ai_training_materials`
--
ALTER TABLE `ai_training_materials`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cancellation_requests`
--
ALTER TABLE `cancellation_requests`
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
-- AUTO_INCREMENT for table `community_posts`
--
ALTER TABLE `community_posts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
-- AUTO_INCREMENT for table `live_sessions`
--
ALTER TABLE `live_sessions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `permission_role`
--
ALTER TABLE `permission_role`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `post_comments`
--
ALTER TABLE `post_comments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `post_reactions`
--
ALTER TABLE `post_reactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `resources`
--
ALTER TABLE `resources`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `role_user`
--
ALTER TABLE `role_user`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `secondary_schools`
--
ALTER TABLE `secondary_schools`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=303;

--
-- AUTO_INCREMENT for table `shared_resources`
--
ALTER TABLE `shared_resources`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `site_contents`
--
ALTER TABLE `site_contents`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `student_school_selections`
--
ALTER TABLE `student_school_selections`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `student_stories`
--
ALTER TABLE `student_stories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `support_chats`
--
ALTER TABLE `support_chats`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `support_chat_messages`
--
ALTER TABLE `support_chat_messages`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `teacher_assignments`
--
ALTER TABLE `teacher_assignments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `terms_acceptances`
--
ALTER TABLE `terms_acceptances`
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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
-- Constraints for table `ai_training_materials`
--
ALTER TABLE `ai_training_materials`
  ADD CONSTRAINT `ai_training_materials_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ai_training_materials_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cancellation_requests`
--
ALTER TABLE `cancellation_requests`
  ADD CONSTRAINT `cancellation_requests_enrollment_id_foreign` FOREIGN KEY (`enrollment_id`) REFERENCES `enrollments` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `cancellation_requests_processed_by_foreign` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `cancellation_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

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
-- Constraints for table `community_posts`
--
ALTER TABLE `community_posts`
  ADD CONSTRAINT `community_posts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `enrollments_assigned_tutor_id_foreign` FOREIGN KEY (`assigned_tutor_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
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
-- Constraints for table `live_sessions`
--
ALTER TABLE `live_sessions`
  ADD CONSTRAINT `live_sessions_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `live_sessions_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `live_sessions_tutor_id_foreign` FOREIGN KEY (`tutor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

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
-- Constraints for table `post_comments`
--
ALTER TABLE `post_comments`
  ADD CONSTRAINT `post_comments_community_post_id_foreign` FOREIGN KEY (`community_post_id`) REFERENCES `community_posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `post_comments_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `post_comments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `post_comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `post_reactions`
--
ALTER TABLE `post_reactions`
  ADD CONSTRAINT `post_reactions_community_post_id_foreign` FOREIGN KEY (`community_post_id`) REFERENCES `community_posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `post_reactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

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
-- Constraints for table `shared_resources`
--
ALTER TABLE `shared_resources`
  ADD CONSTRAINT `shared_resources_community_post_id_foreign` FOREIGN KEY (`community_post_id`) REFERENCES `community_posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `shared_resources_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_school_selections`
--
ALTER TABLE `student_school_selections`
  ADD CONSTRAINT `student_school_selections_secondary_school_id_foreign` FOREIGN KEY (`secondary_school_id`) REFERENCES `secondary_schools` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_school_selections_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `support_chats`
--
ALTER TABLE `support_chats`
  ADD CONSTRAINT `support_chats_agent_id_foreign` FOREIGN KEY (`agent_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `support_chats_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `support_chat_messages`
--
ALTER TABLE `support_chat_messages`
  ADD CONSTRAINT `support_chat_messages_support_chat_id_foreign` FOREIGN KEY (`support_chat_id`) REFERENCES `support_chats` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `support_chat_messages_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `teacher_assignments`
--
ALTER TABLE `teacher_assignments`
  ADD CONSTRAINT `teacher_assignments_assigned_by_foreign` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `teacher_assignments_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teacher_assignments_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teacher_assignments_teacher_id_foreign` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `terms_acceptances`
--
ALTER TABLE `terms_acceptances`
  ADD CONSTRAINT `terms_acceptances_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `topics`
--
ALTER TABLE `topics`
  ADD CONSTRAINT `topics_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
