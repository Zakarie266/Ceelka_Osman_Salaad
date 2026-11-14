<?php 
session_start();
include("conn.php"); 
?>
<!DOCTYPE html>
<html lang="en">
<head>
 <?php include("libirary/head.php"); ?>
</head>
<body class="hold-transition sidebar-mini layout-fixed">

 <div class="wrapper">
  <!-- Preloader -->
  

  <!-- Navbar -->
  <?php include("libirary/navbar.php"); ?>
  <!-- /.navbar -->

  <!-- Main Sidebar Container -->
  <?php include("libirary/sidebar.php");  ?>

  <!-- Sidebar Menu -->

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
  <div class="card">
       <div class="card-header">
         <h3 class="card-title">User Veiw Table</h3>
         <br>
  </div>
 <!-- /.card-header -->
  
    <div class="row md-2">
     <div class="col-md-10"></div>
     <div class="col-md-2">
      <br>
      <button type="button" class="btn btn-success fas fa-edit" data-toggle="modal" data-target="#insert_user_modal">
       Add User
      </button>
     </div>
    </div>
   <div class="card-body">
    <table id="example1" class="table table-bordered table-striped">
      <thead>
       <tr>
           <th>ID</th>
           <th>Name</th>
           <th>Username</th>
           <th>Password</th>
           <th>User Type</th>
           <th>Register Date</th>

           <th>Edit</th>
           <th>Del</th>
      </tr>
    </thead>
      <tbody>
       <tr> 
          <?php 
            if(isset($_POST["btnregister"]))
            {
              $em = mysqli_real_escape_string($conn, $_POST['empname']);
              $un = mysqli_real_escape_string($conn, $_POST['username']);
              $pa = mysqli_real_escape_string($conn, $_POST['password']);
              $ut = mysqli_real_escape_string($conn, $_POST['usertype']);
              $da = mysqli_real_escape_string($conn, $_POST['date']);

              $insert = mysqli_query($conn,"call users_sp('$em','$un','$pa','$ut','$da')");

              echo "<script> alert('Insert Successfull ...!'); </script>";


            }
      ?> 
      <?php 
            if(isset($_POST["btnedit"]))
            {
              $id = mysqli_real_escape_string($conn, $_POST['uid']);
              $un = mysqli_real_escape_string($conn, $_POST['uname']);
              $pa = mysqli_real_escape_string($conn, $_POST['pass']);
              $ut = mysqli_real_escape_string($conn, $_POST['utype']);
              $da = mysqli_real_escape_string($conn, $_POST['dat']);

              $update = mysqli_query($conn,"UPDATE users SET username = '$un', password = MD5('$pa'), Role ='$ut', user_date = '$da' WHERE user_id = '$id' ");

              echo "<script> alert('Updated Successfull ...!'); </script>";
               
               

            }


      ?>
       <?php
        if(isset($_GET['id_user'])){
         $id = $_GET['id_user'];
         $tir = mysqli_query($conn,"delete from users where user_id = $id");

        }
        ?>
        
         <?php 

                    $soo_daabac = mysqli_query($conn, "SELECT u.user_id,e.fullname,u.username,u.password,u.Role, u.user_date FROM users u JOIN employees e ON u.user_id = e.emp_id");
                    while ($res = mysqli_fetch_array($soo_daabac)) { ?>
                    <td><?php echo $res[0];  ?></td>
                    <td><?php echo $res[1];  ?></td>
                    <td><?php echo $res[2];  ?></td>
                    <td><?php echo $res[3];  ?></td>
                    <td><?php echo $res[4];  ?></td>
                    <td><?php echo $res[5];  ?></td>

         <td>
          <button type="button" alt="<?php echo $res['user_id'];  ?>" class="btn btn-warning getedit" ><i class="fas fa-edit"></i></button>
        </td>
         <td>
          <a href="VeiwUser.php?id_user=<?php echo $res['user_id']; ?>" onclick='return confirm("Matireysa Xogtaan ?")' class="btn btn-danger" ><i class="fas fa-trash"></i></a>
        </td>
      </tr>
        <?php 
       }
       ?>
     </tbody>
     </table>
   </div> <!-- /.card-body -->
  </div> <!-- /.content -->
      
  </div> <!-- /.content-wrapper -->

  <!-- Control Sidebar -->
  <aside class="control-sidebar control-sidebar-dark">
    <!-- Control sidebar content goes here -->
  </aside>
  <!-- /.control-sidebar -->
  </div>
 <!-- ./wrapper -->
 <?php include("libirary/footer.php"); ?>
 <?php include("models/user_model.php"); ?> 
 <!-- jQuery -->
 <?php include("libirary/script.php"); ?>

 
<script>
   $(document).ready(function(){
      $("body"). on('click', '.getedit', function(){
        var u_id = "u_id="+$(this).attr("alt");

        $.ajax({
         url:"get/get_user.php",
         method:"POST",
         data:u_id,            
         success:function(data){
              
          var res = data.split(",");
          $('#uid').val($.trim(res[0]));
          $('#eid').val(res[1]);
          $('#uname').val(res[2]);
          $('#pass').val(res[3]);
          $('#utype').val(res[4]);            
          $('#date').val(res[5]);              
         
              

          $('#edit_user_modal').modal('show');
            }
          });
        });
       });     

</script>
</body>
</html>
