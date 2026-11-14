<?php
session_start();
require("conn.php");
extract($_POST); 
$sql = "call login_sp('$username','$password')";
$ress = $conn->query($sql);
if($ress) {
$msg = $ress->fetch_array();
if($msg['error']){
header("location: login.php?error=$msg[0]");
}else{
foreach($msg as $key => $val){ 
$_SESSION[$key] = $val; 
}
header("location: index.php");
}
}else{
echo $conn->error; 
}
?>