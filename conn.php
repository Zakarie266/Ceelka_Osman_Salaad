
<?php 

$conn = mysqli_connect("localhost","root","","water_billing_system");

if (!$conn) {
	die("Connection Error ".mysqli_connect_error());
}

$conn->query("SET time_zone = 'Africa/Nairobi'");
$conn->query("SET sql_mode = ''");

?>