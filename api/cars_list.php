<?php
require_once "db.php";

header("Content-Type: application/json; charset=UTF-8");

$type = trim($_GET['type'] ?? '');
$q    = trim($_GET['q'] ?? '');
$minP = trim($_GET['minPrice'] ?? '');
$maxP = trim($_GET['maxPrice'] ?? '');

// رابط الأساس للصور
$base = "http://127.0.0.1/car_rental_api/uploads/cars/";

// صورة افتراضية (لازم تكون موجودة)
$placeholder = "http://127.0.0.1/car_rental_api/uploads/cars/placeholder.jpg";

$sql = "
SELECT
  c.car_id, c.brand, c.model, c.model_year, c.type,
  c.seats, c.transmission, c.fuel_type, c.daily_price,

  -- ✅ status محسوب بناءً على الحجوزات الحالية
  CASE 
    WHEN EXISTS (
      SELECT 1 FROM bookings b
      WHERE b.car_id = c.car_id
        AND b.status IN ('CONFIRMED','ACTIVE')
        AND NOW() BETWEEN b.start_datetime AND b.end_datetime
    ) THEN 'BOOKED'
    ELSE 'AVAILABLE'
  END AS status,

  COALESCE(
    (SELECT CONCAT('$base', image_name)
     FROM car_images
     WHERE car_id = c.car_id
     ORDER BY sort_order ASC
     LIMIT 1),
    '$placeholder'
  ) AS cover_url

FROM cars c
WHERE 1=1
";

$params = [];

// ✅ فلترة النوع
if ($type !== '' && $type !== 'ALL') {
  $sql .= " AND c.type = :type";
  $params[':type'] = $type;
}

// ✅ بحث بالبراند أو الموديل
if ($q !== '') {
  $sql .= " AND (c.brand LIKE :q OR c.model LIKE :q)";
  $params[':q'] = "%$q%";
}

// ✅ فلترة السعر
if ($minP !== '' && is_numeric($minP)) {
  $sql .= " AND c.daily_price >= :minP";
  $params[':minP'] = (float)$minP;
}

if ($maxP !== '' && is_numeric($maxP)) {
  $sql .= " AND c.daily_price <= :maxP";
  $params[':maxP'] = (float)$maxP;
}

// ترتيب
$sql .= " ORDER BY c.daily_price ASC";

try {
  $stmt = $pdo->prepare($sql);
  $stmt->execute($params);

  echo json_encode(["ok" => true, "data" => $stmt->fetchAll()]);
} catch (Throwable $e) {
  http_response_code(500);
  echo json_encode(["ok" => false, "message" => "Server error", "debug" => $e->getMessage()]);
}
