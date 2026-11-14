# Isbeddelada la sameeyay

## 1. Dashboard + Professional Reports oo la isku keenay
* `index.php` hadda waa Dashboard iyo Professional Reports hal bog ah.
  * 4 kaarar oo xog dhab ah (Accouns Balance, Customers, Total Charged, Total Received) - waxay bedeleen kuwii been abuurka ahaa (Bounce Rate 53%, 44, 65).
  * Chart: Charged vs Received (12-kii bilood ee ugu dambeeyay).
  * 4 tab oo report ah: Customer Statement, Account Statement, Balance Report, Message Report.
* Sidebar-ka: `Dashboard` + `Professional Reports` ayaa meel isku xigta ku jira; links-ku waxay u furmaan tab-ka saxda ah (`index.php#report-balance` ...).
* Navbar: waxaa lagu daray `Reports` iyo `Restore`.

## 2. Functions oo la isku daray (xariifyo la mid ah)
* `libirary/functions.php` (cusub): session guard, `h()`, `money()`, `db_scalar()`, `db_rows()`, `dashboard_stats()`, `report_table()`, `run_report()` ...
* `get/report.php` (cusub) wuxuu bedelay: `getCustReport.php`, `getAccReport.php` iyo 4-ta POST handler ee ku jiray bogagga report-ka.
* SQL-ka iyo stored procedures-ka reports-ka sidoodii ayay yihiin (`Customer_statement_sp`, `accoun_statement_sp`, `cust_balanceGreaterThanZero_sp()`, `cust_balanceZeroAndLess_sp()`, `messageWithResto_sp`, `messageWithoutResto_sp`).
* `libirary/head.php` iyo `libirary/script.php`: waa la nadiifiyay (jQuery, Bootstrap, FontAwesome, Google Font oo 2-3 jeer la soo celinayay hal mar ayaa hadda la soo rarayaa; AdminLTE JS hal mar).

## 3. Links la sixay
| Hore | Hadda |
|---|---|
| `js/jQuery.js` (5 bog; fileku waa `jquery.js` -> Linux ma helayo) | `plugins/jquery/jquery.min.js` |
| `plugins/style.css` (fileku waa `Style.css`) | file-ka waxaa loo beddelay `style.css` |
| `OsmanSalad.png` (root) | `dist/img/OsmanSalad.png` (hal nuqul) |
| `libirary/RestoreBackup.php` (lama wici jirin) | navbar -> `Restore` + login guard |
| `VeiwReport*`, `VeiwRep*`, `getCustReport`, `getAccReport` | `index.php#report-*` / `get/report.php` |

## 4. Files la tuuray (aan loo wicin)
* Bogagga AdminLTE demo: `docs/`, `pages/`, `build/`, `iframe*.html`, `index2.html`, `index3.html`, `starter.html`, `dist/js/pages/`, `dist/js/demo.js`, `dist/css/alt/`, `*.map`, `adminlte.css`, `adminlte.js` (waxaa la isticmaalayaa `adminlte.min.*`).
* Tooling: `package.json`, `package-lock.json`, `composer.json`, `Dockerfile`, `docker-compose.yml`, `.github/`, `.eslint*`, `.stylelint*`, `.babelrc.js`, `.browserslistrc`, `.bundlewatch.config.json`, `.editorconfig`, `.gitpod.yml`, `.lgtm.yml`, `.npmignore`, `.dockerignore`, `CODE_OF_CONDUCT.md`.
* Waxaa lagu bedelay Dashboard-ka cusub: `libirary/myprofile.php` (xog been ah: 41,410 Likes, 9B Follower...), `VeiwReportcust.php`, `VeiwRepHormud.php`, `VeiwRepBalance.php`, `VeiwReportAcc.php`, `getCustReport.php`, `getAccReport.php`.
* Aan la isticmaalin: `quiz.php`, `VeiwCust_rpt.php` (+ `saki.jpg`), `libirary/form.php`, `get/getaccounrpt.php`, `AnalyzeDatabase`, `BackupOsmanSalaad.sql` + `BackupBackupOsmanSalaad.sql` (2-ba madhan), `js/jquery.js` (nuqul).
* `plugins/`: 46 folder oo aan lagu isticmaalin ayaa la tuuray (hadda 14 haray). `dist/img/`: waxaa hadhay kuwa la isticmaalo oo kaliya (`OsmanSalad.png`, `ceelka_osman.jpg`); sawirrada kale (`biyaha_osman.jpg`, `biyo.jpg`, `photo1-4`, `Zaki.jpg` ...) rar-kii asalka ah ayay ku jiraan.
* `user mysql.txt` -> `Backup/login_users_procedures.sql` (waa SQL-ka `login_sp`, lagama maarmaan).
* `.git` waa la hayay: `git status` wuxuu ku tusayaa wax walba oo is beddelay.

## 5. Digniino (la arkay, lama beddelin)
* Bogagga `Veiw*.php` (marka laga reebo `index.php`) ma hubiyaan login-ka; qof URL-ka toos u qoray wuu gali karaa. Waxaa lagu daraa hal sadar: `require_once 'libirary/functions.php'; require_login();`.
* `Backup/water_billing_system.sql` wuxuu leeyahay `cust_balance*_sp(IN _from, IN _to)`, laakiin bogga Balance wuxuu u yeedhayay `cust_balance*_sp()` (0 argument). Waan ilaaliyay sida bogga u wici jiray; hubi in database-kaaga live-ka ah uu leeyahay nooca 0-argument.
* `libirary/RestoreBackup.php` wuxuu ku xirmaa database magac la'aan, wuxuuna isticmaalaa `exec('rm ...')` - hubi ka hor inta aanad isticmaalin.
* Passwords-ka waxaa lagu keydiyaa MD5 (`login_sp`), SQL-ka bogagga qaar wuxuu toos isticmaalaa `$_POST` (SQL injection) - waxaa fiican in la beddelo.

## 6. Hubin
* Link audit (include/href/src/action/$.post, case-sensitive): 0 jaban.
* PHP: lama orda (halkan PHP/MySQL ma jiraan) - kaliya bracket balance check ayaa la sameeyay. Fadlan tijaabi `index.php` XAMPP-kaaga.
