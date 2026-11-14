# Ceelka Biyaha Osman Salad - Water Billing System

PHP + MySQL + AdminLTE 3. Open `login.php` after importing the database.

## Setup
1. Create database `water_billing_system` and import `Backup/water_billing_system.sql`
   (tables, data and the report stored procedures).
2. Import `Backup/login_users_procedures.sql` (`login_sp`, `users_sp`).
3. Check the connection in `conn.php`.
4. Browse to `login.php`.

## Structure
```
index.php                 Dashboard + Professional Reports (4 report tabs)
login.php / check_login.php / logout.php / conn.php
Veiw*.php                 Users, Customer, Charge, Receipt, Accoun, Supplier, Payment, Employees, Salary
libirary/                 head, navbar, sidebar, footer, script  (shared layout)
                          functions.php  (shared helpers + the report engine)
                          RestoreBackup.php
get/                      AJAX endpoints  (get/report.php = all reports)
models/                   modal forms used by the Veiw*.php pages
Backup/                   backup.php, backup_function.php, SQL files
dist/  plugins/           AdminLTE + only the plugins that are really used
```
Report tabs can be opened directly: `index.php#report-customer`, `#report-account`,
`#report-balance`, `#report-message`.

AdminLTE is MIT licensed - see `LICENSE`.
