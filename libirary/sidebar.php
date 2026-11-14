
<aside class="main-sidebar sidebar-dark-primary elevation-4">

    <a href="index.php" class="brand-link">
      <img src="dist/img/OsmanSalad.png" alt="AdminLTE Logo" class="brand-image img-circle elevation-3" style="opacity: .8">
      <span class="brand-text font-weight-light">Ceelka Osman Salad</span>
    </a>
    <!-- Sidebar -->
    <div class="sidebar">
      <!-- Sidebar user panel (optional) -->
      <div class="user-panel mt-3 pb-3 mb-3 d-flex">
        <div class="image">
          <img src="dist/img/OsmanSalad.png" class="img-circle elevation-2" alt="User Image">
        </div>
        <div class="info">
          <a href="index.php" class="d-block"><?php  echo $_SESSION['username']; echo " | "; echo $_SESSION['UserType']; ?></a>
        </div>
      </div>

      <!-- Sidebar Menu -->
      <nav class="mt-2">
        <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
          <!-- Add icons to the links using the .nav-icon class
               with font-awesome or any other icon font library -->
          <!-- Dashboard -->
          <li class="nav-item">
            <a href="index.php" class="nav-link">
              <i class="nav-icon fas fa-tachometer-alt"></i>
              <p>Dashboard</p>
            </a>
          </li>

          <!-- Professional Reports (tabs on the dashboard page) -->
          <li class="nav-item">
            <a href="index.php#report-customer" class="nav-link">
              <i class="nav-icon fas fa-chair"></i>
              <p>
                Reports
                <i class="fas fa-angle-left right"></i>
                <span class="badge badge-info right">4</span>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="index.php#report-customer" class="nav-link">
                  <i class="fas fa-list nav-icon"></i>
                  <p>Customer Report</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="index.php#report-message" class="nav-link">
                  <i class="fas fa-list nav-icon"></i>
                  <p>Message Report</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="index.php#report-balance" class="nav-link">
                  <i class="fas fa-list nav-icon"></i>
                  <p>Balance Report</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="index.php#report-account" class="nav-link">
                  <i class="fas fa-list nav-icon"></i>
                  <p>Accoun Report</p>
                </a>
              </li>
            </ul>
          </li>
          <!-- ends   -->

    <!-- Admin Area   -->
    
      <li class="nav-item" >
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-toolbox"></i>
              <p>
                Admin Area
                <i class="fas fa-angle-left right"></i>
                <span class="badge badge-info right">1</span>
              </p>
            </a>

            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="VeiwUser.php" class="nav-link">
                  <i class="fas fa-user nav-icon"></i>
                  <p>Users Veiw</p>
                </a>
              </li>

            </ul>
          </li>
          <!-- ends   -->

          <!-- Transaction Area   -->
          
      <li class="nav-item">
            <a href="#" class="nav-link ">
              <i class="nav-icon fas fa-briefcase"></i>
              <p>
                Transaction Area
                <i class="fas fa-angle-left right"></i>
                <span class="badge badge-info right">6</span>
              </p>
            </a>

            <ul class="nav nav-treeview">

              <li class="nav-item">
                <a href="VeiwCustomer.php" class="nav-link">
                  <i class="fas fa-portrait nav-icon"></i>
                  <p>Customer Veiw </p>
                </a>
              </li>

              <li class="nav-item">
                <a href="VeiwCharge.php" class="nav-link">
                  <i class="fas fa-money-bill-wave nav-icon"></i>
                  <p>Charge</p>
                </a>
              </li>

              <li class="nav-item">
                <a href="VeiwChargeAndReceipt.php" class="nav-link">
                  <i class="fas fa-money-bill-wave nav-icon"></i>
                  <p>Charge & Receipt </p>
                </a>
              </li>

              <li class="nav-item">
                <a href="VeiwReceive.php" class="nav-link">
                  <i class="fas fa-hand-holding-usd nav-icon"></i>
                  <p>Receipt Veiw </p>
                </a>
              </li>

              <li class="nav-item">
                <a href="VeiwAccoun.php" class="nav-link">
                  <i class="fas fa-shopping-bag nav-icon"></i>
                  <p>Accoun Veiw </p>
                </a>
              </li>

              <li class="nav-item">
                <a href="VeiwSupplier.php" class="nav-link">
                  <i class="fas fa-clipboard-list nav-icon"></i>
                  <p>Supplier Veiw </p>
                </a>
              </li>

              <li class="nav-item">
                <a href="VeiwPayment.php" class="nav-link">
                  <i class="fas fa-money-bill-wave nav-icon"></i>
                  <p>Payment Veiw </p>
                </a>
              </li>

            </ul>

          </li>
          <!-- ends   -->

          <!-- Employee Area   -->
      <li class="nav-item" >
            <a href="#" class="nav-link ">
              <i class="nav-icon fas fa-users"></i>
              <p>
                Employee Area
                <i class="fas fa-angle-left right"></i>
                <span class="badge badge-info right">2</span>
              </p>
            </a>

            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="VeiwEmployees.php" class="nav-link">
                  <i class="fas fa-user nav-icon"></i>
                  <p>Employee Veiw </p>
                </a>
              </li>
              
               <li class="nav-item">
                <a href="VeiwSalary.php" class="nav-link">
                  <i class="fas fa-money-bill-wave nav-icon"></i>
                  <p>Salary Payment </p>
                </a>
              </li>

            </ul>
          </li>
          <!-- ends   -->
       </ul>
      </nav>
      <!-- /.sidebar-menu -->
    </div>
    <!-- /.sidebar -->
  </aside>
