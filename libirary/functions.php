<?php
/**
 * functions.php  -  shared helpers for the whole system.
 *
 * One place for everything that used to be copy-pasted between
 * VeiwReportcust / VeiwReportAcc / VeiwRepBalance / VeiwRepHormud,
 * getCustReport / getAccReport and the old index.php dashboard.
 *
 * Usage:  require_once __DIR__ . '/libirary/functions.php';   (from the root)
 *         require_once __DIR__ . '/../libirary/functions.php'; (from a sub-folder)
 */

if (defined('APP_FUNCTIONS_LOADED')) {
    return;
}
define('APP_FUNCTIONS_LOADED', true);

/* ------------------------------------------------------------------ */
/*  Session / security                                                 */
/* ------------------------------------------------------------------ */

function app_session()
{
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
}

/**
 * Stop the request when nobody is logged in.
 * $ajax = true  -> answer with a short text (used by get/report.php)
 * $ajax = false -> redirect to the login page
 */
function require_login($ajax = false, $loginUrl = 'login.php')
{
    app_session();
    if (empty($_SESSION['username'])) {
        if ($ajax) {
            http_response_code(401);
            exit('<div class="alert alert-warning">Session expired. Please login again.</div>');
        }
        header('location: ' . $loginUrl . '?error=Please Make Login');
        exit;
    }
}

/* ------------------------------------------------------------------ */
/*  Small output / input helpers                                       */
/* ------------------------------------------------------------------ */

/** HTML-escape a value for output. */
function h($value)
{
    return htmlspecialchars((string) $value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

/** "$12.5" in the same style the old reports used. */
function money($value)
{
    return '<b>$</b>' . h(round((float) $value, 2));
}

/** Accept only YYYY-MM-DD (or empty string, which the stored procedures treat as "no limit"). */
function clean_date($value)
{
    $value = trim((string) $value);
    return preg_match('/^\d{4}-\d{2}-\d{2}$/', $value) ? $value : '';
}

/* ------------------------------------------------------------------ */
/*  Database helpers                                                   */
/* ------------------------------------------------------------------ */

/** First column of the first row, or $default when the query fails / is empty. */
function db_scalar($conn, $sql, $default = 0)
{
    $res = @mysqli_query($conn, $sql);
    if (!$res) {
        return $default;
    }
    $row = mysqli_fetch_row($res);
    return ($row && $row[0] !== null) ? $row[0] : $default;
}

/** All rows as associative arrays ([] when the query fails). */
function db_rows($conn, $sql)
{
    $out = array();
    $res = @mysqli_query($conn, $sql);
    if (!$res) {
        return $out;
    }
    while ($row = mysqli_fetch_assoc($res)) {
        $out[] = $row;
    }
    return $out;
}

/** After CALL procedure() MySQL leaves extra result sets open - drain them. */
function db_flush($conn)
{
    while ($conn->more_results()) {
        $conn->next_result();
        if ($extra = $conn->store_result()) {
            $extra->free();
        }
    }
}

/* ------------------------------------------------------------------ */
/*  Dashboard                                                          */
/* ------------------------------------------------------------------ */

/** Real numbers for the dashboard cards (replaces the old demo values). */
function dashboard_stats($conn)
{
    return array(
        'accounts_balance' => db_scalar($conn, 'SELECT SUM(balance) FROM accoun'),
        'customers'        => db_scalar($conn, 'SELECT COUNT(*) FROM customer'),
        'charged'          => db_scalar($conn, 'SELECT SUM(balance) FROM invoice'),
        'received'         => db_scalar($conn, 'SELECT SUM(amount) FROM receipt'),
        'invoices'         => db_scalar($conn, 'SELECT COUNT(*) FROM invoice'),
        'receipts'         => db_scalar($conn, 'SELECT COUNT(*) FROM receipt'),
        'payments'         => db_scalar($conn, 'SELECT COUNT(*) FROM payment'),
    );
}

/** Charged vs received per month for the last 12 months (for the Chart.js bar chart). */
function dashboard_monthly($conn)
{
    $months = array();
    $charged = db_rows($conn, "SELECT DATE_FORMAT(month_data,'%Y-%m') AS m, ROUND(SUM(balance),2) AS t
                               FROM invoice WHERE month_data IS NOT NULL GROUP BY m ORDER BY m DESC LIMIT 12");
    foreach ($charged as $r) {
        $months[$r['m']]['charged'] = (float) $r['t'];
    }
    $received = db_rows($conn, "SELECT DATE_FORMAT(month_date,'%Y-%m') AS m, ROUND(SUM(amount),2) AS t
                                FROM receipt WHERE month_date IS NOT NULL GROUP BY m ORDER BY m DESC LIMIT 12");
    foreach ($received as $r) {
        $months[$r['m']]['received'] = (float) $r['t'];
    }
    ksort($months);
    $months = array_slice($months, -12, null, true);

    $out = array('labels' => array(), 'charged' => array(), 'received' => array());
    foreach ($months as $m => $v) {
        $out['labels'][]   = $m;
        $out['charged'][]  = isset($v['charged']) ? $v['charged'] : 0;
        $out['received'][] = isset($v['received']) ? $v['received'] : 0;
    }
    return $out;
}

/* ------------------------------------------------------------------ */
/*  Professional Reports  (one engine for all four report types)       */
/* ------------------------------------------------------------------ */

/** The tabs shown on the dashboard. key => [title, icon, description] */
function report_catalog()
{
    return array(
        'customer' => array('Customer Statement', 'fa-user',     'All transactions of one customer'),
        'account'  => array('Account Statement',  'fa-wallet',   'All transactions of one account'),
        'balance'  => array('Balance Report',     'fa-balance-scale', 'All balance with zero or without'),
        'message'  => array('Message Report',     'fa-envelope', 'All charge, with or without resto'),
    );
}

/** Options for the select boxes. */
function report_options($conn, $what)
{
    switch ($what) {
        case 'customers':
            return db_rows($conn, 'SELECT cust_id AS id, CustomerName AS label FROM customer ORDER BY cust_id');
        case 'accounts':
            return db_rows($conn, 'SELECT acc_id AS id, acc_name AS label FROM accoun ORDER BY acc_id');
        case 'months':
            return db_rows($conn, 'SELECT month_data AS id, month_data AS label FROM invoice GROUP BY month_data ORDER BY month_data');
    }
    return array();
}

/** Header block that every report starts with. */
function report_heading($title, $subtitle = '')
{
    $html  = '<div class="text-center mb-3">';
    $html .= '<h3 class="mb-0">CEELKA OSMAN SALAD</h3>';
    $html .= '<h5 class="mb-0 text-uppercase">' . h($title) . '</h5>';
    if ($subtitle !== '') {
        $html .= '<h6 class="text-muted mb-0">' . h($subtitle) . '</h6>';
    }
    $html .= '<small class="text-muted">Generated ' . h(date('Y-m-d H:i')) . '</small>';
    $html .= '</div>';
    return $html;
}

function report_alert($message, $type = 'warning')
{
    return '<div class="alert alert-' . h($type) . '">' . h($message) . '</div>';
}

/**
 * Run a stored procedure and print a table.
 *   $headers  : list of column titles
 *   $moneyCols: column indexes shown as $amount
 *   $statement: true -> debit/credit statement (TOTAL row, blanks for 0, rounded)
 */
function report_table($conn, $sql, array $headers, $tableId, $title, array $options = array())
{
    $statement  = !empty($options['statement']);
    $totalLabel = isset($options['totalLabel']) ? $options['totalLabel'] : 'T O T A L';
    $moneyCols  = isset($options['moneyCols']) ? $options['moneyCols'] : array();

    $res = $conn->query($sql);
    if (!$res) {
        return report_alert('Report could not be loaded: ' . $conn->error, 'danger');
    }

    $html  = '<div class="report-buttons mb-2"></div>';
    $html .= '<div class="table-responsive">';
    $html .= '<table id="' . h($tableId) . '" class="table table-striped table-bordered report-table"'
           . ' data-org="CEELKA OSMAN SALAD"'
           . ' data-title="' . h($title) . '" data-mode="' . ($statement ? 'statement' : 'list') . '">';
    $html .= '<thead><tr>';
    foreach ($headers as $head) {
        $html .= '<th>' . h($head) . '</th>';
    }
    $html .= '</tr></thead><tbody>';

    $columns = count($headers);
    while ($row = $res->fetch_array()) {
        $html .= '<tr>';
        if ($statement) {
            $isTotal = ($row[0] == '' && $row[1] == 'TOTAL');
            $html .= '<td>' . ($isTotal ? h($totalLabel) : h($row[0])) . '</td>';
            $html .= '<td>' . ($isTotal ? '' : h($row[1])) . '</td>';
            $html .= '<td>' . ($row[2] == 0 ? '' : money($row[2])) . '</td>';
            $html .= '<td>' . ($row[3] == 0 ? '' : money($row[3])) . '</td>';
            $html .= '<td>' . money($row[4]) . '</td>';
        } else {
            for ($i = 0; $i < $columns; $i++) {
                $cell = isset($row[$i]) ? $row[$i] : '';
                $html .= '<td>' . (in_array($i, $moneyCols, true) ? '<b>$</b>' . h($cell) : h($cell)) . '</td>';
            }
        }
        $html .= '</tr>';
    }
    $html .= '</tbody></table></div>';

    $res->free();
    db_flush($conn);
    return $html;
}

/**
 * Build one report.  $in is normally $_POST.
 * Returns an HTML fragment (heading + table) - used by get/report.php.
 */
function run_report($conn, $type, array $in)
{
    $start   = clean_date(isset($in['start']) ? $in['start'] : '');
    $end     = clean_date(isset($in['end']) ? $in['end'] : '');
    $variant = isset($in['variant']) ? (string) $in['variant'] : '';
    $period  = ($start !== '' || $end !== '')
             ? 'Period: ' . ($start !== '' ? $start : 'beginning') . '  to  ' . ($end !== '' ? $end : 'today')
             : 'All dates';

    switch ($type) {

        /* ---- Customer statement ---------------------------------- */
        case 'customer':
            $id = isset($in['id']) ? (int) $in['id'] : 0;
            if ($id <= 0) {
                return report_alert('Please select a customer.');
            }
            $name = db_scalar($conn, "SELECT CustomerName FROM customer WHERE cust_id = $id", '');
            return report_heading('Customer Statement', trim($id . ' ' . $name) . '  |  ' . $period)
                 . report_table(
                     $conn,
                     "call Customer_statement_sp('$id','$start','$end')",
                     array('Date', 'Type', 'Debit', 'Credit', 'Balance'),
                     'rpt-customer-table',
                     'Customer Statement - ' . $name,
                     array('statement' => true, 'totalLabel' => 'T O T A L')
                 );

        /* ---- Account statement ----------------------------------- */
        case 'account':
            $id = isset($in['id']) ? (int) $in['id'] : 0;
            if ($id <= 0) {
                return report_alert('Please select an account.');
            }
            $name = db_scalar($conn, "SELECT acc_name FROM accoun WHERE acc_id = $id", '');
            return report_heading('Account Statement', $name . '  |  ' . $period)
                 . report_table(
                     $conn,
                     "call accoun_statement_sp('$id','$start','$end')",
                     array('Date', 'Type', 'Debit', 'Credit', 'Balance'),
                     'rpt-account-table',
                     'Account Statement - ' . $name,
                     array('statement' => true, 'totalLabel' => 'TOTAL Accoun')
                 );

        /* ---- Balance report -------------------------------------- */
        case 'balance':
            $withZero = ($variant === 'with_zero');
            return report_heading('Balance Report', $withZero ? 'Balance zero or less' : 'Balance greater than zero')
                 . report_table(
                     $conn,
                     $withZero ? 'call cust_balanceZeroAndLess_sp()' : 'call cust_balanceGreaterThanZero_sp()',
                     array('H-No.', 'Owner Name', 'Contact', 'Zone', 'Meter Cube', 'Balance'),
                     'rpt-balance-table',
                     'Balance Report',
                     array('moneyCols' => array(5))
                 );

        /* ---- Message report -------------------------------------- */
        case 'message':
            if ($start === '' || $end === '') {
                return report_alert('Please select the start date and the end date.');
            }
            if ($variant === 'without_resto') {
                return report_heading('Message Report - Without Resto', $period)
                     . report_table(
                         $conn,
                         "call messageWithoutResto_sp('$start','$end')",
                         array('Date', 'H-No.', 'Owner Name', 'Tell', 'Mc-Hore', 'Mc-Danbe', 'Farqi', 'Rate', 'Balance'),
                         'rpt-message-table',
                         'Message Report - Without Resto'
                     );
            }
            return report_heading('Message Report - With Resto', $period)
                 . report_table(
                     $conn,
                     "call messageWithResto_sp('$start','$end')",
                     array('Date', 'H-No.', 'Owner Name', 'Tell', 'Mc-Hore', 'Mc-Danbe', 'Farqi', 'Rate', 'Charge', 'Resto', 'Balance'),
                     'rpt-message-table',
                     'Message Report - With Resto'
                 );
    }

    return report_alert('Unknown report.', 'danger');
}
