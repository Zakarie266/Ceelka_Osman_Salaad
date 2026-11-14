<?php

    error_reporting(0);

   include 'backup_function.php';

      
      $server = 'localhost';
      $username = 'root';
      $password = '';
      $dbname = 'water_billing_system';

      
      backDb($server, $username, $password, $dbname);

      exit();
    

?>
