
<?php 

$conn = mysqli_connect(
	"DATABASE_HOST",
	"u682984824_va8Qg",
	"@Zaki2526",
	"u682984824_WMBVe");

if (!$conn) {
	die("Connection Error ".mysqli_connect_error());
}

$conn->query("SET time_zone = 'Africa/Nairobi'");
$conn->query("SET sql_mode = ''");

?>