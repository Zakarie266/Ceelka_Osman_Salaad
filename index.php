<?php
/**
 * index.php  -  Dashboard + Professional Reports in one page.
 * Report tabs are opened with index.php#report-customer | #report-account | #report-balance | #report-message
 */
require_once __DIR__ . '/conn.php';
require_once __DIR__ . '/libirary/functions.php';
require_login();

$stats     = dashboard_stats($conn);
$monthly   = dashboard_monthly($conn);
$reports   = report_catalog();
$customers = report_options($conn, 'customers');
$accounts  = report_options($conn, 'accounts');
$months    = report_options($conn, 'months');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <?php include(__DIR__ . "/libirary/head.php"); ?>
</head>
<body class="hold-transition sidebar-mini layout-fixed" background="./dist/img/ceelka_osman.jpg" style="background-repeat: round;  opacity: 0.9;" >
<div class="wrapper">

  <!-- Preloader -->
  <div class="preloader flex-column justify-content-center align-items-center">
    <img class="animation__shake" src="dist/img/OsmanSalad.png" alt="Ceelka Osman Salad" height="60" width="60">
  </div>

  <?php include(__DIR__ . "/libirary/navbar.php"); ?>
  <?php include(__DIR__ . "/libirary/sidebar.php"); ?>

  <div class="content-wrapper">
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Dashboard</h1>
          </div>
        </div>
      </div>
    </div>

    <section class="content">
      <div class="container-fluid">

        <!-- ============ DASHBOARD : key numbers ============ -->
        <div class="row">
          <div class="col-lg-3 col-6">
            <div class="small-box bg-info">
              <div class="inner">
                <h3><?php echo number_format((float) $stats['accounts_balance']); ?></h3>
                <p>Total Accouns Balance</p>
              </div>
              <div class="icon"><i class="fas fa-chart-pie"></i></div>
              <a href="VeiwAccoun.php" class="small-box-footer">More info <i class="fas fa-arrow-circle-right"></i></a>
            </div>
          </div>
          <div class="col-lg-3 col-6">
            <div class="small-box bg-success">
              <div class="inner">
                <h3><?php echo number_format((float) $stats['customers']); ?></h3>
                <p>Customers</p>
              </div>
              <div class="icon"><i class="fas fa-user-plus"></i></div>
              <a href="VeiwCustomer.php" class="small-box-footer">More info <i class="fas fa-arrow-circle-right"></i></a>
            </div>
          </div>
          <div class="col-lg-3 col-6">
            <div class="small-box bg-warning">
              <div class="inner">
                <h3><sup style="font-size: 20px">$</sup><?php echo number_format((float) $stats['charged']); ?></h3>
                <p>Total Charged</p>
              </div>
              <div class="icon"><i class="fas fa-money-bill-wave"></i></div>
              <a href="VeiwCharge.php" class="small-box-footer">More info <i class="fas fa-arrow-circle-right"></i></a>
            </div>
          </div>
          <div class="col-lg-3 col-6">
            <div class="small-box bg-danger">
              <div class="inner">
                <h3><sup style="font-size: 20px">$</sup><?php echo number_format((float) $stats['received']); ?></h3>
                <p>Total Received</p>
              </div>
              <div class="icon"><i class="fas fa-hand-holding-usd"></i></div>
              <a href="VeiwReceive.php" class="small-box-footer">More info <i class="fas fa-arrow-circle-right"></i></a>
            </div>
          </div>
        </div>

        <!-- ============ DASHBOARD : chart + company card ============ -->
        <div class="row">
          <div class="col-lg-8">
            <div class="card">
              <div class="card-header border-0">
                <h3 class="card-title"><i class="fas fa-chart-bar mr-1"></i> Charged vs Received (last 12 months)</h3>
              </div>
              <div class="card-body">
                <?php if (count($monthly['labels'])) { ?>
                <canvas id="monthlyChart" style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;"></canvas>
                <?php } else { ?>
                <p class="text-muted mb-0">No charge / receipt data yet.</p>
                <?php } ?>
              </div>
            </div>
          </div>
          <div class="col-lg-4">
            <div class="card card-widget widget-user shadow">
              <div class="widget-user-header bg-info">
                <h3 class="widget-user-username">CEELKA BIYAHA</h3>
                <h5 class="widget-user-desc">OSMAN SALAD</h5>
              </div>
              <div class="widget-user-image">
                <img class="img-circle elevation-2" src="dist/img/OsmanSalad.png" alt="Ceelka Osman Salad">
              </div>
              <div class="card-footer">
                <div class="row">
                  <div class="col-sm-4 border-right">
                    <div class="description-block">
                      <h5 class="description-header"><?php echo number_format((float) $stats['invoices']); ?></h5>
                      <span class="description-text">CHARGES</span>
                    </div>
                  </div>
                  <div class="col-sm-4 border-right">
                    <div class="description-block">
                      <h5 class="description-header"><?php echo number_format((float) $stats['receipts']); ?></h5>
                      <span class="description-text">RECEIPTS</span>
                    </div>
                  </div>
                  <div class="col-sm-4">
                    <div class="description-block">
                      <h5 class="description-header"><?php echo number_format((float) $stats['payments']); ?></h5>
                      <span class="description-text">PAYMENTS</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- ============ PROFESSIONAL REPORTS ============ -->
        <div class="row" id="reports">
          <div class="col-12">
            <div class="card card-primary card-outline card-outline-tabs">
              <div class="card-header p-0 border-bottom-0">
                <ul class="nav nav-tabs" id="report-tabs" role="tablist">
                  <?php $first = true; foreach ($reports as $key => $info) { ?>
                  <li class="nav-item">
                    <a class="nav-link<?php echo $first ? ' active' : ''; ?>" id="tab-<?php echo $key; ?>" data-toggle="pill"
                       href="#report-<?php echo $key; ?>" role="tab" aria-controls="report-<?php echo $key; ?>">
                      <i class="fas <?php echo $info[1]; ?> mr-1"></i> <?php echo h($info[0]); ?>
                    </a>
                  </li>
                  <?php $first = false; } ?>
                </ul>
              </div>
              <div class="card-body">
                <div class="tab-content">

                  <!-- Customer statement -->
                  <div class="tab-pane fade show active" id="report-customer" role="tabpanel">
                    <form class="report-form" data-report="customer" data-target="#result-customer">
                      <div class="row">
                        <div class="col-md-4 form-group">
                          <label>Customer :</label>
                          <select class="select2" name="id" style="width: 100%;">
                            <option value="">Select Customer Name</option>
                            <?php foreach ($customers as $r) { ?>
                            <option value="<?php echo h($r['id']); ?>"><?php echo h($r['id'] . ' ' . $r['label']); ?></option>
                            <?php } ?>
                          </select>
                        </div>
                        <div class="col-md-3 form-group"><label>Start Date:</label><input type="date" name="start" class="form-control"></div>
                        <div class="col-md-3 form-group"><label>End Date:</label><input type="date" name="end" class="form-control"></div>
                        <div class="col-md-2 form-group"><label>&nbsp;</label><button type="submit" class="btn btn-success btn-block"><i class="fa fa-search"></i> Search</button></div>
                      </div>
                    </form>
                    <div class="report-output" id="result-customer"></div>
                  </div>

                  <!-- Account statement -->
                  <div class="tab-pane fade" id="report-account" role="tabpanel">
                    <form class="report-form" data-report="account" data-target="#result-account">
                      <div class="row">
                        <div class="col-md-4 form-group">
                          <label>Accoun :</label>
                          <select class="select2" name="id" style="width: 100%;">
                            <option value="">Select Accoun</option>
                            <?php foreach ($accounts as $r) { ?>
                            <option value="<?php echo h($r['id']); ?>"><?php echo h($r['label']); ?></option>
                            <?php } ?>
                          </select>
                        </div>
                        <div class="col-md-3 form-group"><label>Start Date:</label><input type="date" name="start" class="form-control"></div>
                        <div class="col-md-3 form-group"><label>End Date:</label><input type="date" name="end" class="form-control"></div>
                        <div class="col-md-2 form-group"><label>&nbsp;</label><button type="submit" class="btn btn-success btn-block"><i class="fa fa-search"></i> Search</button></div>
                      </div>
                    </form>
                    <div class="report-output" id="result-account"></div>
                  </div>

                  <!-- Balance report -->
                  <div class="tab-pane fade" id="report-balance" role="tabpanel">
                    <form class="report-form" data-report="balance" data-target="#result-balance">
                      <div class="row">
                        <div class="col-md-3 form-group">
                          <button type="submit" data-variant="without_zero" class="btn btn-success btn-block">Without Zero</button>
                        </div>
                        <div class="col-md-3 form-group">
                          <button type="submit" data-variant="with_zero" class="btn btn-primary btn-block">With Zero</button>
                        </div>
                      </div>
                    </form>
                    <div class="report-output" id="result-balance"></div>
                  </div>

                  <!-- Message report -->
                  <div class="tab-pane fade" id="report-message" role="tabpanel">
                    <form class="report-form" data-report="message" data-target="#result-message">
                      <div class="row">
                        <div class="col-md-3 form-group">
                          <label>Start Date:</label>
                          <select class="select2" name="start" style="width: 100%;">
                            <option value="">Start Date</option>
                            <?php foreach ($months as $r) { ?>
                            <option value="<?php echo h($r['id']); ?>"><?php echo h($r['label']); ?></option>
                            <?php } ?>
                            <option value="<?php echo date("Y-m-d"); ?>">Today</option>
                          </select>
                        </div>
                        <div class="col-md-3 form-group">
                          <label>End Date:</label>
                          <select class="select2" name="end" style="width: 100%;">
                            <option value="">End Date</option>
                            <option value="<?php echo date("Y-m-d"); ?>">Today</option>
                            <?php foreach ($months as $r) { ?>
                            <option value="<?php echo h($r['id']); ?>"><?php echo h($r['label']); ?></option>
                            <?php } ?>
                          </select>
                        </div>
                        <div class="col-md-3 form-group"><label>&nbsp;</label><button type="submit" data-variant="with_resto" class="btn btn-success btn-block">With Resto</button></div>
                        <div class="col-md-3 form-group"><label>&nbsp;</label><button type="submit" data-variant="without_resto" class="btn btn-primary btn-block">Without Resto</button></div>
                      </div>
                    </form>
                    <div class="report-output" id="result-message"></div>
                  </div>

                </div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </section>
  </div>

  <?php include(__DIR__ . "/libirary/footer.php"); ?>

  <aside class="control-sidebar control-sidebar-dark"></aside>
</div>

<?php include(__DIR__ . "/libirary/script.php"); ?>

<script>
$(function () {

  /* ---- select2 filters ---- */
  $('.select2').select2({ width: '100%' });

  /* ---- open the tab named in the link  (index.php#report-balance ...) ---- */
  function openTabFromHash() {
    var hash = window.location.hash;
    if (hash && hash.indexOf('#report-') === 0) {
      var tab = $('#report-tabs a[href="' + hash + '"]');
      if (tab.length) {
        tab.tab('show');
        $('html, body').animate({ scrollTop: $('#reports').offset().top - 70 }, 300);
      }
    }
  }
  openTabFromHash();
  $(window).on('hashchange', openTabFromHash);

  /* ---- run a report through get/report.php ---- */
  $('.report-form').on('click', 'button[data-variant]', function () {
    $(this).closest('form').data('variant', $(this).data('variant'));
  });

  $('.report-form').on('submit', function (e) {
    e.preventDefault();
    var $form   = $(this);
    var $target = $($form.data('target'));
    var payload = $form.serialize() + '&report=' + encodeURIComponent($form.data('report'));
    if ($form.data('variant')) { payload += '&variant=' + encodeURIComponent($form.data('variant')); }

    $target.html('<div class="text-center p-4"><i class="fas fa-spinner fa-spin"></i> Loading...</div>');

    $.post('get/report.php', payload)
      .done(function (html) {
        $target.html(html);
        $target.find('table.report-table').each(function () {
          var $t    = $(this);
          var orgName  = $t.data('org') || 'CEELKA OSMAN SALAD'; 
          var period   = $t.data('period') || '';
          var title = $t.data('title') || document.title;
          var list  = ($t.data('mode') === 'list');
          var table = $t.DataTable({
            responsive: true, autoWidth: false, lengthChange: false,
            ordering: list, paging: list, searching: list, info: list,
            buttons: [
              { extend: 'copy',  title: title }, { extend: 'csv',   title: title },
              { extend: 'excel', title: title }, { extend: 'pdf',   title: title },
              { extend: 'print', title: title }, 'colvis'
            ]
          });
          table.buttons().container().appendTo($target.find('.report-buttons'));
        });
      })
      .fail(function (xhr) {
        $target.html(xhr.responseText || '<div class="alert alert-danger">Report could not be loaded.</div>');
      });
  });

  /* ---- monthly chart ---- */
  <?php if (count($monthly['labels'])) { ?>
  if (typeof Chart !== 'undefined' && document.getElementById('monthlyChart')) {
    new Chart(document.getElementById('monthlyChart').getContext('2d'), {
      type: 'bar',
      data: {
        labels: <?php echo json_encode($monthly['labels']); ?>,
        datasets: [
          { label: 'Charged',  backgroundColor: 'rgba(255,193,7,0.85)',  data: <?php echo json_encode($monthly['charged']); ?> },
          { label: 'Received', backgroundColor: 'rgba(40,167,69,0.85)', data: <?php echo json_encode($monthly['received']); ?> }
        ]
      },
      options: {
        maintainAspectRatio: false, responsive: true,
        scales: { yAxes: [{ ticks: { beginAtZero: true } }] }
      }
    });
  }
  <?php } ?>
});
</script>
</body>
</html>
