<?php
/**
 * get/report.php  -  the single AJAX endpoint behind "Professional Reports".
 * Replaces getCustReport.php, getAccReport.php and the four inline POST handlers.
 *
 * POST report = customer | account | balance | message
 *      id, start, end, variant   (see libirary/functions.php -> run_report)
 */
require_once __DIR__ . '/../conn.php';
require_once __DIR__ . '/../libirary/functions.php';

require_login(true);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    exit(report_alert('POST only.', 'danger'));
}

echo run_report($conn, isset($_POST['report']) ? $_POST['report'] : '', $_POST);
