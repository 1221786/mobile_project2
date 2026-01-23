-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 20, 2026 at 09:44 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `car_rental_ramallah`
--

-- --------------------------------------------------------

--
-- Table structure for table `accidents`
--

CREATE TABLE `accidents` (
  `accident_id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `car_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `accident_time` datetime NOT NULL,
  `location_text` varchar(255) DEFAULT NULL,
  `description` text NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'REPORTED',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accidents`
--

INSERT INTO `accidents` (`accident_id`, `booking_id`, `car_id`, `customer_id`, `accident_time`, `location_text`, `description`, `status`, `created_at`) VALUES
(1, 12, 5, 8, '2026-01-17 14:30:00', 'Gaza - Al Rimal Street', 'Front bumper damaged after minor collision.', 'REPORTED', '2026-01-17 19:53:53'),
(2, 8, 3, 7, '2026-01-16 22:16:00', 'ramallah', 'ssssssssssssssssssss', 'REPORTED', '2026-01-17 22:17:09'),
(3, 4, 3, 7, '2026-01-17 18:42:00', 'ramallah', 'ddddddd', 'REPORTED', '2026-01-18 20:42:17');

-- --------------------------------------------------------

--
-- Table structure for table `accident_images`
--

CREATE TABLE `accident_images` (
  `image_id` int(11) NOT NULL,
  `accident_id` int(11) NOT NULL,
  `image_name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accident_images`
--

INSERT INTO `accident_images` (`image_id`, `accident_id`, `image_name`, `created_at`) VALUES
(1, 1, 'accident_1_front.jpg', '2026-01-17 19:53:53'),
(2, 1, 'accident_1_side.jpg', '2026-01-17 19:53:53'),
(3, 1, 'accident_1_back.jpg', '2026-01-17 19:53:53');

-- --------------------------------------------------------

--
-- Table structure for table `addons`
--

CREATE TABLE `addons` (
  `addon_id` int(11) NOT NULL,
  `name` varchar(80) NOT NULL,
  `price_per_day` decimal(10,2) NOT NULL DEFAULT 0.00,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `addons`
--

INSERT INTO `addons` (`addon_id`, `name`, `price_per_day`, `is_active`) VALUES
(1, 'Child Seat', 5.00, 1),
(2, 'WiFi Router', 7.00, 1),
(3, 'Extra Driver', 10.00, 1),
(4, 'Full Insurance', 12.00, 1),
(5, 'Delivery Service', 0.00, 1);

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `booking_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `car_id` int(11) NOT NULL,
  `pickup_location_id` int(11) DEFAULT NULL,
  `dropoff_location_id` int(11) DEFAULT NULL,
  `pickup_address` varchar(255) DEFAULT NULL,
  `dropoff_address` varchar(255) DEFAULT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  `days_count` int(11) NOT NULL,
  `daily_price_at_booking` decimal(10,2) NOT NULL,
  `delivery_fee` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `addons_total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(10,2) NOT NULL,
  `status` enum('PENDING','CONFIRMED','ACTIVE','COMPLETED','CANCELLED','REJECTED') NOT NULL DEFAULT 'PENDING',
  `notes` varchar(400) DEFAULT NULL,
  `applied_discount_code_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`booking_id`, `customer_id`, `car_id`, `pickup_location_id`, `dropoff_location_id`, `pickup_address`, `dropoff_address`, `start_datetime`, `end_datetime`, `days_count`, `daily_price_at_booking`, `delivery_fee`, `discount_amount`, `addons_total`, `total_price`, `status`, `notes`, `applied_discount_code_id`, `created_at`, `updated_at`) VALUES
(1, 3, 2, 2, 1, NULL, NULL, '2026-01-20 10:00:00', '2026-01-23 10:00:00', 3, 45.00, 0.00, 13.50, 0.00, 121.50, 'CONFIRMED', 'Customer requested clean interior', 1, '2026-01-16 13:30:35', NULL),
(2, 4, 1, NULL, NULL, 'Ramallah - Al-Tireh area', 'Al-Bireh Downtown', '2026-01-18 09:00:00', '2026-01-19 09:00:00', 1, 65.00, 10.00, 0.00, 0.00, 75.00, 'PENDING', 'Delivery requested', NULL, '2026-01-16 13:30:35', NULL),
(3, 5, 5, 1, 2, NULL, NULL, '2026-02-02 12:00:00', '2026-02-05 12:00:00', 3, 110.00, 0.00, 20.00, 24.00, 334.00, 'CONFIRMED', 'Luxury requested', 2, '2026-01-16 13:30:35', NULL),
(4, 7, 3, NULL, NULL, 'Ramallah – Al-Manara', 'Birzeit', '2026-01-16 00:00:00', '2026-01-31 00:00:00', 15, 35.00, 0.00, 0.00, 0.00, 525.00, 'CONFIRMED', NULL, NULL, '2026-01-16 19:41:12', '2026-01-17 11:37:02'),
(5, 7, 7, NULL, NULL, 'Ramallah – City Center', 'Ramallah – City Center', '2026-01-16 00:00:00', '2026-01-31 00:00:00', 15, 50.00, 0.00, 0.00, 0.00, 750.00, 'CONFIRMED', NULL, NULL, '2026-01-16 19:43:19', '2026-01-17 15:11:23'),
(6, 7, 7, NULL, NULL, 'Ramallah – City Center', 'Ramallah – City Center', '2026-01-31 00:00:00', '2026-02-11 00:00:00', 11, 50.00, 0.00, 0.00, 0.00, 550.00, 'PENDING', NULL, NULL, '2026-01-16 19:44:39', NULL),
(7, 7, 5, NULL, NULL, 'Ramallah – Company Branch', 'Ramallah – Al-Manara', '2026-01-16 00:00:00', '2026-01-20 00:00:00', 4, 110.00, 0.00, 0.00, 0.00, 440.00, 'CONFIRMED', NULL, NULL, '2026-01-16 20:34:50', '2026-01-16 21:33:06'),
(8, 7, 3, NULL, NULL, 'Ramallah – Al-Manara', 'Birzeit', '2026-02-08 00:00:00', '2026-02-28 00:00:00', 20, 35.00, 0.00, 0.00, 0.00, 700.00, 'CONFIRMED', NULL, NULL, '2026-01-16 21:16:10', '2026-01-16 21:16:44'),
(9, 7, 8, NULL, NULL, 'Ramallah – Al-Manara', 'Birzeit', '2026-02-01 00:00:00', '2026-02-28 00:00:00', 27, 48.00, 0.00, 0.00, 0.00, 1296.00, 'CONFIRMED', NULL, NULL, '2026-01-17 10:41:16', '2026-01-17 10:41:36'),
(10, 7, 6, NULL, NULL, 'Ramallah – Al-Manara', 'Ramallah – City Center', '2026-01-17 00:00:00', '2026-01-18 00:00:00', 1, 95.00, 0.00, 0.00, 0.00, 95.00, 'PENDING', NULL, NULL, '2026-01-17 11:36:44', NULL),
(11, 7, 8, NULL, NULL, 'Birzeit', 'Ramallah – Al-Manara', '2026-01-17 00:00:00', '2026-01-29 00:00:00', 12, 48.00, 0.00, 0.00, 0.00, 576.00, '', NULL, NULL, '2026-01-17 14:20:51', '2026-01-17 14:21:23'),
(12, 7, 3, NULL, NULL, 'Birzeit', 'Ramallah – Company Branch', '2026-01-31 00:00:00', '2026-02-02 00:00:00', 2, 35.00, 0.00, 0.00, 0.00, 70.00, '', NULL, NULL, '2026-01-17 14:23:35', '2026-01-17 14:24:22'),
(13, 7, 2, NULL, NULL, 'Ramallah – Company Branch', 'Ramallah – City Center', '2026-02-13 00:00:00', '2026-02-28 00:00:00', 15, 45.00, 0.00, 0.00, 0.00, 675.00, 'CANCELLED', NULL, NULL, '2026-01-17 15:30:46', '2026-01-17 15:57:53'),
(14, 7, 6, NULL, NULL, 'Birzeit', 'Ramallah – Company Branch', '2026-03-03 00:00:00', '2026-03-31 00:00:00', 28, 95.00, 0.00, 0.00, 0.00, 2660.00, 'CANCELLED', NULL, NULL, '2026-01-17 15:57:37', '2026-01-17 18:08:34'),
(15, 7, 2, NULL, NULL, 'Ramallah – Al-Manara', 'Birzeit', '2026-03-01 00:00:00', '2026-03-31 00:00:00', 30, 45.00, 0.00, 0.00, 0.00, 1350.00, '', NULL, NULL, '2026-01-17 18:07:36', '2026-01-17 18:08:17');

--
-- Triggers `bookings`
--
DELIMITER $$
CREATE TRIGGER `trg_bookings_status_history` AFTER UPDATE ON `bookings` FOR EACH ROW BEGIN
  IF (OLD.status <> NEW.status) THEN
    INSERT INTO booking_status_history(booking_id, old_status, new_status, changed_by, comment)
    VALUES (NEW.booking_id, OLD.status, NEW.status, NULL, 'Auto log');
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `booking_addons`
--

CREATE TABLE `booking_addons` (
  `booking_id` int(11) NOT NULL,
  `addon_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 1,
  `price_per_day_at_booking` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking_addons`
--

INSERT INTO `booking_addons` (`booking_id`, `addon_id`, `qty`, `price_per_day_at_booking`) VALUES
(3, 1, 1, 5.00),
(3, 4, 1, 12.00);

-- --------------------------------------------------------

--
-- Table structure for table `booking_status_history`
--

CREATE TABLE `booking_status_history` (
  `history_id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `old_status` varchar(20) NOT NULL,
  `new_status` varchar(20) NOT NULL,
  `changed_by` int(11) DEFAULT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `comment` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking_status_history`
--

INSERT INTO `booking_status_history` (`history_id`, `booking_id`, `old_status`, `new_status`, `changed_by`, `changed_at`, `comment`) VALUES
(1, 8, 'PENDING', 'CONFIRMED', NULL, '2026-01-16 21:16:44', 'Auto log'),
(2, 7, 'PENDING', 'CONFIRMED', NULL, '2026-01-16 21:33:06', 'Auto log'),
(3, 9, 'PENDING', 'CONFIRMED', NULL, '2026-01-17 10:41:36', 'Auto log'),
(4, 4, 'PENDING', 'CONFIRMED', NULL, '2026-01-17 11:37:02', 'Auto log'),
(5, 11, 'PENDING', '', NULL, '2026-01-17 14:21:23', 'Auto log'),
(6, 12, 'PENDING', '', NULL, '2026-01-17 14:24:22', 'Auto log'),
(7, 5, 'PENDING', 'CONFIRMED', NULL, '2026-01-17 15:11:23', 'Auto log'),
(8, 13, 'PENDING', 'CANCELLED', NULL, '2026-01-17 15:57:53', 'Auto log'),
(9, 15, 'PENDING', '', NULL, '2026-01-17 18:08:17', 'Auto log'),
(10, 14, 'PENDING', 'CANCELLED', NULL, '2026-01-17 18:08:34', 'Auto log');

-- --------------------------------------------------------

--
-- Table structure for table `cars`
--

CREATE TABLE `cars` (
  `car_id` int(11) NOT NULL,
  `plate_number` varchar(20) NOT NULL,
  `brand` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `model_year` smallint(6) NOT NULL,
  `type` enum('SUV','SEDAN','HATCHBACK','VAN','PICKUP','LUXURY') NOT NULL,
  `seats` tinyint(4) NOT NULL DEFAULT 5,
  `transmission` enum('AUTO','MANUAL') NOT NULL DEFAULT 'AUTO',
  `fuel_type` enum('GAS','DIESEL','HYBRID','ELECTRIC') NOT NULL DEFAULT 'GAS',
  `daily_price` decimal(10,2) NOT NULL,
  `deposit_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('AVAILABLE','RENTED','MAINTENANCE','DISABLED') NOT NULL DEFAULT 'AVAILABLE',
  `mileage_km` int(11) NOT NULL DEFAULT 0,
  `color` varchar(30) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cars`
--

INSERT INTO `cars` (`car_id`, `plate_number`, `brand`, `model`, `model_year`, `type`, `seats`, `transmission`, `fuel_type`, `daily_price`, `deposit_amount`, `status`, `mileage_km`, `color`, `description`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'P-12345', 'Toyota', 'RAV4', 2022, 'SUV', 5, 'AUTO', 'GAS', 65.00, 200.00, 'AVAILABLE', 42000, 'White', 'Comfortable SUV for city and trips.', 1, '2026-01-16 13:30:35', NULL),
(2, 'P-23456', 'Hyundai', 'Elantra', 2021, 'SEDAN', 5, 'AUTO', 'GAS', 45.00, 150.00, 'AVAILABLE', 53000, 'Gray', 'Economic sedan, great on fuel.', 1, '2026-01-16 13:30:35', NULL),
(3, 'P-34567', 'Kia', 'Picanto', 2020, 'HATCHBACK', 5, 'AUTO', 'GAS', 35.00, 100.00, 'AVAILABLE', 61000, 'Red', 'Small and easy to park.', 1, '2026-01-16 13:30:35', NULL),
(4, 'P-45678', 'Nissan', 'X-Trail', 2023, 'SUV', 7, 'AUTO', 'GAS', 75.00, 250.00, 'MAINTENANCE', 18000, 'Black', '7-seater family SUV.', 1, '2026-01-16 13:30:35', NULL),
(5, 'P-56789', 'Mercedes', 'C200', 2022, 'LUXURY', 5, 'AUTO', 'GAS', 110.00, 400.00, 'AVAILABLE', 26000, 'Black', 'Premium ride for business.', 1, '2026-01-16 13:30:35', NULL),
(6, 'P-67890', 'Ford', 'Transit', 2019, 'VAN', 12, 'MANUAL', 'DIESEL', 95.00, 300.00, 'AVAILABLE', 98000, 'White', 'Group transport van.', 1, '2026-01-16 13:30:35', NULL),
(7, 'P-77777', 'Honda', 'Civic', 2020, 'SEDAN', 5, 'AUTO', 'GAS', 50.00, 160.00, 'AVAILABLE', 70000, 'Blue', 'Reliable daily driver.', 1, '2026-01-16 13:30:35', NULL),
(8, 'P-88888', 'Volkswagen', 'Golf', 2021, 'HATCHBACK', 5, 'AUTO', 'GAS', 48.00, 150.00, 'AVAILABLE', 39000, 'Silver', 'Sporty hatchback.', 1, '2026-01-16 13:30:35', NULL),
(9, 'P-99999', 'Mitsubishi', 'L200', 2020, 'PICKUP', 5, 'MANUAL', 'DIESEL', 80.00, 280.00, 'AVAILABLE', 85000, 'White', 'Pickup for heavy needs.', 1, '2026-01-16 13:30:35', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `car_features`
--

CREATE TABLE `car_features` (
  `feature_id` int(11) NOT NULL,
  `feature_name` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `car_features`
--

INSERT INTO `car_features` (`feature_id`, `feature_name`) VALUES
(6, 'Air Conditioning'),
(8, 'Android Auto'),
(7, 'Apple CarPlay'),
(1, 'Bluetooth'),
(5, 'Cruise Control'),
(2, 'GPS'),
(9, 'Heated Seats'),
(4, 'Parking Sensors'),
(3, 'Rear Camera'),
(10, 'Sunroof');

-- --------------------------------------------------------

--
-- Table structure for table `car_feature_map`
--

CREATE TABLE `car_feature_map` (
  `car_id` int(11) NOT NULL,
  `feature_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `car_feature_map`
--

INSERT INTO `car_feature_map` (`car_id`, `feature_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 6),
(1, 7),
(2, 1),
(2, 6),
(2, 8),
(3, 1),
(3, 6),
(5, 1),
(5, 2),
(5, 3),
(5, 6),
(5, 9),
(5, 10),
(8, 1),
(8, 6),
(8, 7),
(8, 8);

-- --------------------------------------------------------

--
-- Table structure for table `car_images`
--

CREATE TABLE `car_images` (
  `image_id` int(11) NOT NULL,
  `car_id` int(11) NOT NULL,
  `image_name` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `car_images`
--

INSERT INTO `car_images` (`image_id`, `car_id`, `image_name`, `sort_order`) VALUES
(1, 1, 'rav4_1.jpg', 1),
(2, 1, 'rav4_2.jpg', 2),
(3, 2, 'elantra_1.jpg', 1),
(4, 3, 'picanto_1.jpg', 1),
(5, 5, 'c200_1.jpg', 1),
(6, 8, 'golf_1.jpg', 1);

-- --------------------------------------------------------

--
-- Table structure for table `car_unavailability`
--

CREATE TABLE `car_unavailability` (
  `unavail_id` int(11) NOT NULL,
  `car_id` int(11) NOT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  `reason` enum('MAINTENANCE','BLOCKED','OTHER') NOT NULL DEFAULT 'MAINTENANCE',
  `note` varchar(300) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ;

--
-- Dumping data for table `car_unavailability`
--

INSERT INTO `car_unavailability` (`unavail_id`, `car_id`, `start_datetime`, `end_datetime`, `reason`, `note`, `created_by`, `created_at`) VALUES
(1, 4, '2026-01-16 00:00:00', '2026-01-20 00:00:00', 'MAINTENANCE', 'Oil + brake check', 1, '2026-01-16 13:30:35'),
(2, 6, '2026-01-25 08:00:00', '2026-01-26 20:00:00', 'BLOCKED', 'Reserved for company event', 1, '2026-01-16 13:30:35');

-- --------------------------------------------------------

--
-- Table structure for table `discount_codes`
--

CREATE TABLE `discount_codes` (
  `code_id` int(11) NOT NULL,
  `code` varchar(40) NOT NULL,
  `type` enum('PERCENT','FIXED') NOT NULL,
  `value` decimal(10,2) NOT NULL,
  `min_total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `max_discount` decimal(10,2) DEFAULT NULL,
  `start_at` datetime DEFAULT NULL,
  `end_at` datetime DEFAULT NULL,
  `usage_limit` int(11) DEFAULT NULL,
  `used_count` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `discount_codes`
--

INSERT INTO `discount_codes` (`code_id`, `code`, `type`, `value`, `min_total`, `max_discount`, `start_at`, `end_at`, `usage_limit`, `used_count`, `is_active`, `created_by`, `created_at`) VALUES
(1, 'RAMALLAH10', 'PERCENT', 10.00, 50.00, 40.00, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 200, 0, 1, 1, '2026-01-16 13:30:35'),
(2, 'WELCOME20', 'FIXED', 20.00, 80.00, NULL, '2026-01-01 00:00:00', '2026-06-30 23:59:59', 100, 0, 1, 1, '2026-01-16 13:30:35'),
(3, 'WEEKEND5', 'PERCENT', 5.00, 30.00, 15.00, '2026-01-01 00:00:00', '2026-12-31 23:59:59', NULL, 0, 1, 1, '2026-01-16 13:30:35');

-- --------------------------------------------------------

--
-- Table structure for table `discount_code_redemptions`
--

CREATE TABLE `discount_code_redemptions` (
  `redemption_id` int(11) NOT NULL,
  `code_id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `discount_amount` decimal(10,2) NOT NULL,
  `redeemed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `discount_code_redemptions`
--

INSERT INTO `discount_code_redemptions` (`redemption_id`, `code_id`, `booking_id`, `customer_id`, `discount_amount`, `redeemed_at`) VALUES
(1, 1, 1, 3, 13.50, '2026-01-16 13:30:35'),
(2, 2, 3, 5, 20.00, '2026-01-16 13:30:35');

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `customer_id` int(11) NOT NULL,
  `car_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `favorites`
--

INSERT INTO `favorites` (`customer_id`, `car_id`, `created_at`) VALUES
(3, 1, '2026-01-16 13:30:35'),
(3, 5, '2026-01-16 13:30:35'),
(4, 2, '2026-01-16 13:30:35');

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `location_id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `city` varchar(80) NOT NULL DEFAULT 'Ramallah',
  `lat` decimal(10,7) DEFAULT NULL,
  `lng` decimal(10,7) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`location_id`, `name`, `city`, `lat`, `lng`, `is_active`) VALUES
(1, 'Ramallah City Center', 'Ramallah', 31.9021000, 35.2040000, 1),
(2, 'Al-Manara Square', 'Ramallah', 31.9038000, 35.2034000, 1),
(3, 'Ramallah Bus Station', 'Ramallah', 31.9062000, 35.2031000, 1),
(4, 'Al-Irsal Street', 'Ramallah', 31.9006000, 35.2113000, 1),
(5, 'Al-Tireh', 'Ramallah', 31.8959000, 35.2058000, 1),
(6, 'Al-Bireh Downtown', 'Al-Bireh', 31.9102000, 35.2152000, 1),
(7, 'Birzeit Pickup Point', 'Ramallah', 31.9737000, 35.2104000, 1);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `booking_id` int(11) DEFAULT NULL,
  `title` varchar(120) NOT NULL,
  `body` varchar(300) NOT NULL,
  `type` enum('RENT_REMINDER_24H','RENT_ENDED','BOOKING_STATUS','GENERAL') NOT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `is_sent` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `booking_id`, `title`, `body`, `type`, `scheduled_at`, `sent_at`, `is_sent`, `created_at`) VALUES
(1, 3, 1, 'Reminder: Rent ending soon', 'Your rental ends in 24 hours. Please prepare for return.', 'RENT_REMINDER_24H', '2026-01-22 10:00:00', NULL, 0, '2026-01-16 13:30:35'),
(2, 3, 1, 'Booking confirmed', 'Your booking has been confirmed successfully.', 'BOOKING_STATUS', NULL, NULL, 1, '2026-01-16 13:30:35');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `method` enum('CASH','CARD','PAYPAL','STRIPE','MOCK') NOT NULL DEFAULT 'MOCK',
  `status` enum('PENDING','SUCCESS','FAILED','REFUNDED') NOT NULL DEFAULT 'PENDING',
  `transaction_ref` varchar(120) DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`payment_id`, `booking_id`, `amount`, `method`, `status`, `transaction_ref`, `paid_at`, `created_at`) VALUES
(1, 1, 121.50, 'MOCK', 'SUCCESS', 'MOCK-TXN-10001', '2026-01-16 14:00:00', '2026-01-16 13:30:35'),
(2, 3, 334.00, 'MOCK', 'SUCCESS', 'MOCK-TXN-10002', '2026-01-16 14:05:00', '2026-01-16 13:30:35'),
(3, 8, 700.00, 'MOCK', 'SUCCESS', 'MOCK-TXN-19915', '2026-01-16 23:16:44', '2026-01-16 21:16:44'),
(4, 7, 440.00, '', 'SUCCESS', 'MOCK-TXN-20696', '2026-01-16 23:33:06', '2026-01-16 21:33:06'),
(5, 9, 1296.00, '', 'SUCCESS', 'MOCK-TXN-16917', '2026-01-17 12:41:36', '2026-01-17 10:41:36'),
(6, 4, 525.00, '', 'SUCCESS', 'MOCK-TXN-62755', '2026-01-17 13:37:02', '2026-01-17 11:37:02'),
(7, 11, 576.00, 'CASH', 'SUCCESS', 'MOCK-TXN-98207', '2026-01-17 16:21:23', '2026-01-17 14:21:23'),
(8, 12, 70.00, 'CASH', 'SUCCESS', 'MOCK-TXN-65927', '2026-01-17 16:24:22', '2026-01-17 14:24:22'),
(9, 5, 750.00, '', 'SUCCESS', 'MOCK-TXN-43168', '2026-01-17 17:11:23', '2026-01-17 15:11:23'),
(10, 15, 1350.00, 'CASH', 'SUCCESS', 'MOCK-TXN-59070', '2026-01-17 20:08:17', '2026-01-17 18:08:17');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `car_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `rating` tinyint(4) NOT NULL,
  `comment` varchar(600) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`review_id`, `booking_id`, `car_id`, `customer_id`, `rating`, `comment`, `created_at`) VALUES
(1, 1, 2, 3, 5, 'Very clean car and smooth pickup.', '2026-01-16 13:30:35'),
(2, 3, 5, 5, 4, 'Great car, but delivery took a bit longer.', '2026-01-16 13:30:35');

-- --------------------------------------------------------

--
-- Table structure for table `support_tickets`
--

CREATE TABLE `support_tickets` (
  `ticket_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `subject` varchar(150) NOT NULL,
  `status` enum('OPEN','IN_PROGRESS','CLOSED') NOT NULL DEFAULT 'OPEN',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `closed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `support_tickets`
--

INSERT INTO `support_tickets` (`ticket_id`, `customer_id`, `subject`, `status`, `created_at`, `closed_at`) VALUES
(1, 3, 'Need to change drop-off location', 'OPEN', '2026-01-16 13:30:35', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `support_ticket_messages`
--

CREATE TABLE `support_ticket_messages` (
  `message_id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `sender_user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `support_ticket_messages`
--

INSERT INTO `support_ticket_messages` (`message_id`, `ticket_id`, `sender_user_id`, `message`, `created_at`) VALUES
(1, 1, 3, 'Hi, can I change drop-off to Al-Bireh downtown?', '2026-01-16 13:30:35'),
(2, 1, 2, 'Sure, please confirm the new address and time.', '2026-01-16 13:30:35');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(120) NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('CUSTOMER','WASHING_EMPLOYEE','COMPANY_MANAGER') NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `avatar_url` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `email`, `phone`, `password_hash`, `role`, `is_active`, `avatar_url`, `created_at`, `updated_at`) VALUES
(1, 'Company Manager', 'manager@ramallahcars.ps', '+970599000001', '$2y$10$MANAGER_HASH_PLACEHOLDER', '', 1, NULL, '2026-01-16 13:30:34', NULL),
(2, 'Front Desk Employee', 'employee@ramallahcars.ps', '+970599000002', '$2y$10$EMPLOYEE_HASH_PLACEHOLDER', '', 1, NULL, '2026-01-16 13:30:34', NULL),
(3, 'Ahmad Customer', 'ahmad@gmail.com', '+970599111111', '$2y$10$CUSTOMER_HASH_PLACEHOLDER', 'CUSTOMER', 1, NULL, '2026-01-16 13:30:34', NULL),
(4, 'Lina Customer', 'lina@gmail.com', '+970599222222', '$2y$10$CUSTOMER_HASH_PLACEHOLDER2', 'CUSTOMER', 1, NULL, '2026-01-16 13:30:34', NULL),
(5, 'Sami Customer', 'sami@gmail.com', '+970599333333', '$2y$10$CUSTOMER_HASH_PLACEHOLDER3', 'CUSTOMER', 1, NULL, '2026-01-16 13:30:34', NULL),
(6, 'sara', 'sara@mail.com', '059979904', '$2y$10$Fld5CyqCwTGJbxc5LDYD0.j47BgKCcltdwQtQ63x1F53V1wGf9QV2', 'CUSTOMER', 1, NULL, '2026-01-16 15:08:14', NULL),
(7, 'aya', 'donia@mail.com', '05987880', '$2y$10$5mfGNUMzMwTWkrjyFA5f.eUYzs4y2sJKeTrZmaQCDyXdqErxl28QC', 'CUSTOMER', 1, NULL, '2026-01-16 17:23:04', '2026-01-17 18:09:09'),
(8, 'saraahmad', 'sara123@mail.com', '059879906', '$2y$10$8U3hfyzXEu3rNw8R4a3iauWV9eVYuTE5sRKPLdk6kW38SYb5tz3qi', 'CUSTOMER', 1, NULL, '2026-01-18 14:48:14', NULL),
(9, 'joury', 'joury@mail.com', '059879908', '$2y$10$PA5RRMhYK6kJ2prILh36vu3nAr/OK8/mzPjATg/68nNHdWoR5ToNK', 'COMPANY_MANAGER', 1, NULL, '2026-01-18 15:40:29', NULL);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_available_cars`
-- (See below for the actual view)
--
CREATE TABLE `v_available_cars` (
`car_id` int(11)
,`plate_number` varchar(20)
,`brand` varchar(60)
,`model` varchar(60)
,`model_year` smallint(6)
,`type` enum('SUV','SEDAN','HATCHBACK','VAN','PICKUP','LUXURY')
,`seats` tinyint(4)
,`transmission` enum('AUTO','MANUAL')
,`fuel_type` enum('GAS','DIESEL','HYBRID','ELECTRIC')
,`daily_price` decimal(10,2)
,`status` enum('AVAILABLE','RENTED','MAINTENANCE','DISABLED')
);

-- --------------------------------------------------------

--
-- Structure for view `v_available_cars`
--
DROP TABLE IF EXISTS `v_available_cars`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_available_cars`  AS SELECT `c`.`car_id` AS `car_id`, `c`.`plate_number` AS `plate_number`, `c`.`brand` AS `brand`, `c`.`model` AS `model`, `c`.`model_year` AS `model_year`, `c`.`type` AS `type`, `c`.`seats` AS `seats`, `c`.`transmission` AS `transmission`, `c`.`fuel_type` AS `fuel_type`, `c`.`daily_price` AS `daily_price`, `c`.`status` AS `status` FROM `cars` AS `c` WHERE `c`.`status` = 'AVAILABLE' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accidents`
--
ALTER TABLE `accidents`
  ADD PRIMARY KEY (`accident_id`),
  ADD KEY `booking_id` (`booking_id`),
  ADD KEY `car_id` (`car_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `accident_images`
--
ALTER TABLE `accident_images`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `accident_id` (`accident_id`);

--
-- Indexes for table `addons`
--
ALTER TABLE `addons`
  ADD PRIMARY KEY (`addon_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `fk_bookings_pickup_loc` (`pickup_location_id`),
  ADD KEY `fk_bookings_dropoff_loc` (`dropoff_location_id`),
  ADD KEY `idx_bookings_customer` (`customer_id`,`created_at`),
  ADD KEY `idx_bookings_car_dates` (`car_id`,`start_datetime`,`end_datetime`),
  ADD KEY `idx_bookings_status` (`status`);

--
-- Indexes for table `booking_addons`
--
ALTER TABLE `booking_addons`
  ADD PRIMARY KEY (`booking_id`,`addon_id`),
  ADD KEY `fk_ba_addon` (`addon_id`);

--
-- Indexes for table `booking_status_history`
--
ALTER TABLE `booking_status_history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `fk_bsh_booking` (`booking_id`),
  ADD KEY `fk_bsh_changed_by` (`changed_by`);

--
-- Indexes for table `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`car_id`),
  ADD UNIQUE KEY `plate_number` (`plate_number`),
  ADD KEY `fk_cars_created_by` (`created_by`),
  ADD KEY `idx_cars_type_price` (`type`,`daily_price`),
  ADD KEY `idx_cars_status` (`status`);

--
-- Indexes for table `car_features`
--
ALTER TABLE `car_features`
  ADD PRIMARY KEY (`feature_id`),
  ADD UNIQUE KEY `feature_name` (`feature_name`);

--
-- Indexes for table `car_feature_map`
--
ALTER TABLE `car_feature_map`
  ADD PRIMARY KEY (`car_id`,`feature_id`),
  ADD KEY `fk_cfm_feature` (`feature_id`);

--
-- Indexes for table `car_images`
--
ALTER TABLE `car_images`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `idx_car_images_car` (`car_id`);

--
-- Indexes for table `car_unavailability`
--
ALTER TABLE `car_unavailability`
  ADD PRIMARY KEY (`unavail_id`),
  ADD KEY `fk_unavail_created_by` (`created_by`),
  ADD KEY `idx_unavail_car_dates` (`car_id`,`start_datetime`,`end_datetime`);

--
-- Indexes for table `discount_codes`
--
ALTER TABLE `discount_codes`
  ADD PRIMARY KEY (`code_id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `fk_dc_created_by` (`created_by`);

--
-- Indexes for table `discount_code_redemptions`
--
ALTER TABLE `discount_code_redemptions`
  ADD PRIMARY KEY (`redemption_id`),
  ADD KEY `fk_dcr_code` (`code_id`),
  ADD KEY `fk_dcr_booking` (`booking_id`),
  ADD KEY `fk_dcr_customer` (`customer_id`);

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`customer_id`,`car_id`),
  ADD KEY `fk_fav_car` (`car_id`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`location_id`),
  ADD KEY `idx_locations_city` (`city`),
  ADD KEY `idx_locations_active` (`is_active`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `fk_notifications_user` (`user_id`),
  ADD KEY `fk_notifications_booking` (`booking_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `fk_payments_booking` (`booking_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `fk_reviews_booking` (`booking_id`),
  ADD KEY `fk_reviews_customer` (`customer_id`),
  ADD KEY `idx_reviews_car` (`car_id`,`created_at`);

--
-- Indexes for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD PRIMARY KEY (`ticket_id`),
  ADD KEY `fk_ticket_customer` (`customer_id`);

--
-- Indexes for table `support_ticket_messages`
--
ALTER TABLE `support_ticket_messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `fk_stm_ticket` (`ticket_id`),
  ADD KEY `fk_stm_sender` (`sender_user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`),
  ADD KEY `idx_users_role` (`role`),
  ADD KEY `idx_users_active` (`is_active`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accidents`
--
ALTER TABLE `accidents`
  MODIFY `accident_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `accident_images`
--
ALTER TABLE `accident_images`
  MODIFY `image_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `addons`
--
ALTER TABLE `addons`
  MODIFY `addon_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `booking_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_status_history`
--
ALTER TABLE `booking_status_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `cars`
--
ALTER TABLE `cars`
  MODIFY `car_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `car_features`
--
ALTER TABLE `car_features`
  MODIFY `feature_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `car_images`
--
ALTER TABLE `car_images`
  MODIFY `image_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `car_unavailability`
--
ALTER TABLE `car_unavailability`
  MODIFY `unavail_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `discount_codes`
--
ALTER TABLE `discount_codes`
  MODIFY `code_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `discount_code_redemptions`
--
ALTER TABLE `discount_code_redemptions`
  MODIFY `redemption_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `location_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_tickets`
--
ALTER TABLE `support_tickets`
  MODIFY `ticket_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `support_ticket_messages`
--
ALTER TABLE `support_ticket_messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_bookings_car` FOREIGN KEY (`car_id`) REFERENCES `cars` (`car_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bookings_customer` FOREIGN KEY (`customer_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bookings_dropoff_loc` FOREIGN KEY (`dropoff_location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bookings_pickup_loc` FOREIGN KEY (`pickup_location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `booking_addons`
--
ALTER TABLE `booking_addons`
  ADD CONSTRAINT `fk_ba_addon` FOREIGN KEY (`addon_id`) REFERENCES `addons` (`addon_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ba_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `booking_status_history`
--
ALTER TABLE `booking_status_history`
  ADD CONSTRAINT `fk_bsh_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bsh_changed_by` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `cars`
--
ALTER TABLE `cars`
  ADD CONSTRAINT `fk_cars_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `car_feature_map`
--
ALTER TABLE `car_feature_map`
  ADD CONSTRAINT `fk_cfm_car` FOREIGN KEY (`car_id`) REFERENCES `cars` (`car_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cfm_feature` FOREIGN KEY (`feature_id`) REFERENCES `car_features` (`feature_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `car_images`
--
ALTER TABLE `car_images`
  ADD CONSTRAINT `fk_car_images_car` FOREIGN KEY (`car_id`) REFERENCES `cars` (`car_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `car_unavailability`
--
ALTER TABLE `car_unavailability`
  ADD CONSTRAINT `fk_unavail_car` FOREIGN KEY (`car_id`) REFERENCES `cars` (`car_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_unavail_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `discount_codes`
--
ALTER TABLE `discount_codes`
  ADD CONSTRAINT `fk_dc_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `discount_code_redemptions`
--
ALTER TABLE `discount_code_redemptions`
  ADD CONSTRAINT `fk_dcr_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_dcr_code` FOREIGN KEY (`code_id`) REFERENCES `discount_codes` (`code_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_dcr_customer` FOREIGN KEY (`customer_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `fk_fav_car` FOREIGN KEY (`car_id`) REFERENCES `cars` (`car_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_fav_customer` FOREIGN KEY (`customer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payments_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_reviews_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reviews_car` FOREIGN KEY (`car_id`) REFERENCES `cars` (`car_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reviews_customer` FOREIGN KEY (`customer_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD CONSTRAINT `fk_ticket_customer` FOREIGN KEY (`customer_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `support_ticket_messages`
--
ALTER TABLE `support_ticket_messages`
  ADD CONSTRAINT `fk_stm_sender` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stm_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets` (`ticket_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

-- ============================================
-- Manager Functionality Database Updates
-- Added for manager features support
-- ============================================

-- 1. Update accidents table to support manager decisions
ALTER TABLE `accidents` 
  MODIFY `status` ENUM('REPORTED', 'PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
  ADD COLUMN `manager_notes` TEXT DEFAULT NULL AFTER `status`,
  ADD COLUMN `handled_by` INT(11) DEFAULT NULL AFTER `manager_notes`,
  ADD COLUMN `handled_at` DATETIME DEFAULT NULL AFTER `handled_by`,
  ADD KEY `fk_accidents_handled_by` (`handled_by`);

-- Add foreign key for handled_by
ALTER TABLE `accidents`
  ADD CONSTRAINT `fk_accidents_handled_by` FOREIGN KEY (`handled_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- Update existing accidents to PENDING status
UPDATE `accidents` SET `status` = 'PENDING' WHERE `status` = 'REPORTED';

-- 2. Update cars table status to include UNAVAILABLE
ALTER TABLE `cars` 
  MODIFY `status` ENUM('AVAILABLE', 'UNAVAILABLE', 'RENTED', 'MAINTENANCE', 'DISABLED') NOT NULL DEFAULT 'AVAILABLE';

-- 3. Fix users table - update existing manager and employee with proper roles and passwords
-- Password hash for 'password' (using bcrypt)
UPDATE `users` 
SET 
  `role` = 'COMPANY_MANAGER',
  `password_hash` = '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'
WHERE `user_id` = 1;

UPDATE `users` 
SET 
  `role` = 'WASHING_EMPLOYEE',
  `password_hash` = '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'
WHERE `user_id` = 2;

-- 4. Insert additional manager and employee accounts for testing
INSERT INTO `users` (`user_id`, `full_name`, `email`, `phone`, `password_hash`, `role`, `is_active`, `avatar_url`, `created_at`) VALUES
(10, 'Manager Ali', 'manager.ali@ramallahcars.ps', '+970599000010', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'COMPANY_MANAGER', 1, NULL, NOW()),
(11, 'Manager Sara', 'manager.sara@ramallahcars.ps', '+970599000011', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'COMPANY_MANAGER', 1, NULL, NOW()),
(12, 'Employee Khaled', 'employee.khaled@ramallahcars.ps', '+970599000020', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'WASHING_EMPLOYEE', 1, NULL, NOW()),
(13, 'Employee Rana', 'employee.rana@ramallahcars.ps', '+970599000021', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'WASHING_EMPLOYEE', 1, NULL, NOW()),
(14, 'Employee Omar', 'employee.omar@ramallahcars.ps', '+970599000022', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'WASHING_EMPLOYEE', 0, NULL, NOW());

-- 5. Add more sample cars for manager to manage
INSERT INTO `cars` (`car_id`, `plate_number`, `brand`, `model`, `model_year`, `type`, `seats`, `transmission`, `fuel_type`, `daily_price`, `deposit_amount`, `status`, `mileage_km`, `color`, `description`, `created_by`, `created_at`) VALUES
(10, 'P-10101', 'BMW', '320i', 2023, 'SEDAN', 5, 'AUTO', 'GAS', 85.00, 300.00, 'AVAILABLE', 15000, 'Black', 'Luxury sedan with premium features.', 1, NOW()),
(11, 'P-20202', 'Audi', 'A4', 2022, 'SEDAN', 5, 'AUTO', 'GAS', 95.00, 350.00, 'AVAILABLE', 28000, 'Silver', 'Premium German engineering.', 1, NOW()),
(12, 'P-30303', 'Mazda', 'CX-5', 2023, 'SUV', 5, 'AUTO', 'GAS', 70.00, 250.00, 'UNAVAILABLE', 12000, 'Blue', 'Compact SUV perfect for families.', 1, NOW()),
(13, 'P-40404', 'Nissan', 'Altima', 2021, 'SEDAN', 5, 'AUTO', 'GAS', 55.00, 180.00, 'MAINTENANCE', 65000, 'White', 'Reliable mid-size sedan.', 1, NOW()),
(14, 'P-50505', 'Chevrolet', 'Tahoe', 2022, 'SUV', 8, 'AUTO', 'GAS', 120.00, 500.00, 'AVAILABLE', 22000, 'Black', 'Large SUV for big families.', 1, NOW());

-- 6. Add sample bookings for manager to review
INSERT INTO `bookings` (`booking_id`, `customer_id`, `car_id`, `pickup_address`, `dropoff_address`, `start_datetime`, `end_datetime`, `days_count`, `daily_price_at_booking`, `delivery_fee`, `discount_amount`, `addons_total`, `total_price`, `status`, `notes`, `created_at`) VALUES
(16, 3, 10, 'Ramallah - Al-Manara', 'Ramallah - City Center', '2026-02-01 10:00:00', '2026-02-05 10:00:00', 4, 85.00, 0.00, 0.00, 0.00, 340.00, 'PENDING', 'Customer requested early pickup', NOW()),
(17, 4, 11, 'Al-Bireh Downtown', 'Ramallah - Al-Manara', '2026-02-03 09:00:00', '2026-02-06 09:00:00', 3, 95.00, 15.00, 0.00, 20.00, 320.00, 'PENDING', 'Delivery requested', NOW()),
(18, 5, 14, 'Ramallah - City Center', 'Birzeit', '2026-02-10 12:00:00', '2026-02-15 12:00:00', 5, 120.00, 0.00, 60.00, 0.00, 540.00, 'PENDING', 'Long term rental', NOW());

-- 7. Add more sample accidents for manager to handle
INSERT INTO `accidents` (`accident_id`, `booking_id`, `car_id`, `customer_id`, `accident_time`, `location_text`, `description`, `status`, `created_at`) VALUES
(4, 1, 2, 3, '2026-01-20 15:30:00', 'Ramallah - Al-Tireh', 'Minor scratch on rear bumper from parking incident.', 'PENDING', NOW()),
(5, 3, 5, 5, '2026-01-18 20:00:00', 'Al-Bireh - Main Street', 'Side mirror damaged by another vehicle.', 'PENDING', NOW()),
(6, 7, 5, 7, '2026-01-19 11:15:00', 'Birzeit - University Road', 'Front windshield cracked by stone.', 'PENDING', NOW());

-- 8. Add images for new accidents
INSERT INTO `accident_images` (`image_id`, `accident_id`, `image_name`, `created_at`) VALUES
(4, 4, 'accident_4_rear.jpg', NOW()),
(5, 5, 'accident_5_mirror.jpg', NOW()),
(6, 6, 'accident_6_windshield.jpg', NOW());

-- 9. Add car images for new cars
INSERT INTO `car_images` (`image_id`, `car_id`, `image_name`, `sort_order`) VALUES
(7, 10, 'bmw320i_1.jpg', 1),
(8, 11, 'audia4_1.jpg', 1),
(9, 12, 'mazdacx5_1.jpg', 1),
(10, 13, 'nissanaltima_1.jpg', 1),
(11, 14, 'tahoe_1.jpg', 1);

-- 10. Create view for manager bookings list (with customer info)
CREATE OR REPLACE VIEW `v_manager_bookings` AS
SELECT 
  b.booking_id,
  b.customer_id,
  u.full_name AS customer_name,
  u.email AS customer_email,
  u.phone AS customer_phone,
  b.car_id,
  c.brand,
  c.model,
  c.model_year,
  b.start_datetime,
  b.end_datetime,
  b.days_count,
  b.total_price,
  b.status,
  b.pickup_address,
  b.dropoff_address,
  b.created_at,
  (SELECT image_name FROM car_images WHERE car_id = c.car_id ORDER BY sort_order ASC LIMIT 1) AS cover_image
FROM bookings b
JOIN users u ON b.customer_id = u.user_id
JOIN cars c ON b.car_id = c.car_id
ORDER BY b.created_at DESC;

-- 11. Create view for manager accidents list (with customer and car info)
CREATE OR REPLACE VIEW `v_manager_accidents` AS
SELECT 
  a.accident_id,
  a.booking_id,
  a.car_id,
  c.brand,
  c.model,
  c.model_year,
  a.customer_id,
  u.full_name AS customer_name,
  u.email AS customer_email,
  a.accident_time,
  a.location_text,
  a.description,
  a.status,
  a.manager_notes,
  a.handled_by,
  m.full_name AS handled_by_name,
  a.handled_at,
  a.created_at,
  (SELECT GROUP_CONCAT(image_name SEPARATOR ',') FROM accident_images WHERE accident_id = a.accident_id) AS images
FROM accidents a
JOIN users u ON a.customer_id = u.user_id
JOIN cars c ON a.car_id = c.car_id
LEFT JOIN users m ON a.handled_by = m.user_id
ORDER BY a.created_at DESC;

-- 12. Create view for manager employees list
CREATE OR REPLACE VIEW `v_manager_employees` AS
SELECT 
  user_id,
  full_name,
  email,
  phone,
  role,
  is_active,
  created_at,
  updated_at
FROM users
WHERE role IN ('WASHING_EMPLOYEE', 'COMPANY_MANAGER')
ORDER BY role, full_name;

-- 13. Update AUTO_INCREMENT values
ALTER TABLE `users` AUTO_INCREMENT = 15;
ALTER TABLE `cars` AUTO_INCREMENT = 15;
ALTER TABLE `bookings` AUTO_INCREMENT = 19;
ALTER TABLE `accidents` AUTO_INCREMENT = 7;
ALTER TABLE `accident_images` AUTO_INCREMENT = 7;
ALTER TABLE `car_images` AUTO_INCREMENT = 12;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
