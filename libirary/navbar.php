<nav class="main-header navbar navbar-expand navbar-white navbar-light">
    <!-- Left navbar links -->
    <ul class="navbar-nav">
      <li class="nav-item">
        <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
      </li>
      <li class="nav-item d-none d-sm-inline-block">
        <a href="index.php" class="nav-link">Home</a>
      </li>
      <li class="nav-item d-none d-sm-inline-block">
        <a href="VeiwCustomer.php"  class="nav-link">Customer</a>
      </li>
      <li class="nav-item d-none d-sm-inline-block">
        <a href="VeiwChargeAndReceipt.php" class="nav-link">Charge & Receipt</a>
      </li>
      <li class="nav-item d-none d-sm-inline-block">
        <a href="VeiwCharge.php" class="nav-link">Charge</a>
      </li>
      <li class="nav-item d-none d-sm-inline-block">
        <a href="VeiwReceive.php" class="nav-link">Receipt</a>
      </li>
      <li class="nav-item d-none d-sm-inline-block">
        <a href="VeiwPayment.php" class="nav-link">Payment</a>
      </li>
      <li class="nav-item d-none d-sm-inline-block">
        <a href="VeiwSalary.php" class="nav-link">Other Payment</a>
      </li>
      <li class="nav-item d-none d-sm-inline-block">
        <a href="index.php#report-customer" class="nav-link">Reports</a>
      </li>
      <li class="nav-item d-none d-sm-inline-block">
        <a href="Backup/backup.php" target="" class="nav-link">Backup</a>
      </li>
      <li class="nav-item d-none d-sm-inline-block">
        <a href="libirary/RestoreBackup.php" class="nav-link">Restore</a>
      </li>
      
  </ul>

    <!-- Right navbar links -->
    <ul class="navbar-nav ml-auto">
      <!-- Navbar Search -->
      <li class="nav-item d-none d-sm-inline-block">
        <a href="" target="" class="nav-link"><?php  echo $_SESSION['username']; ?></a>
      </li>
      <li class="nav-item">
        <a class="nav-link" data-widget="fullscreen" href="#" role="button">
          <i class="fas fa-expand-arrows-alt"></i>
        </a>
      </li>
      <li class="nav-item d-none d-sm-inline-block">
        <a href="logout.php" class="nav-link">Log out</a>
      </li>
      <li class="nav-item">
        <div class="user-panel d-none d-sm-inline-block">
          <div class="image" >
           <a href="logout.php"><img src="dist/img/OsmanSalad.png" class="img-circle elevation-2" alt="User Image " ></a>
          </div>
        </div>
        <div class="navbar-search-block">
          <form class="form-inline">
            <div class="input-group input-group-sm">

              <div class="input-group-append">
                
              </div>
            </div>
          </form>
        </div>
      </li>
    </ul>
  </nav>