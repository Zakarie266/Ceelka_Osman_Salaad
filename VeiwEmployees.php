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
         <h3 class="card-title">Employee Veiw Table</h3>
         <br>
  </div>
 <!-- /.card-header -->
  
    <div class="row md-2">
     <div class="col-md-10"></div>
     <div class="col-md-2">
      <br>
      <button type="button" class="btn btn-success fas fa-edit" data-toggle="modal" data-target="#insert_employee_modal">
       Add Employee
      </button>
     </div>
    </div>
   <div class="card-body">
     <table id="example1" class="table table-bordered table-striped">
                  <thead>
                  <tr>
                    <th>ID</th>
                    <th>Employee Name</th>
                    <th>Contact</th>
                    <th>Position</th>
                    <th>Gender</th>
                    <th>Register Date</th>
                    <th>Salary</th>

                    <th>Edit</th>
                    <th>Del</th>
                  </tr>
                  </thead>
                  <tbody>
                  <tr>
       <?php 
           if (isset($_POST["savebtn"])) {
               $en = mysqli_real_escape_string($conn, $_POST['ename']);
               $ct = mysqli_real_escape_string($conn, $_POST['contact']);
               $pn = mysqli_real_escape_string($conn, $_POST['position']);
               $gr = mysqli_real_escape_string($conn, $_POST['gender']);
               $bd = mysqli_real_escape_string($conn, $_POST['birthdate']);
               $sl = mysqli_real_escape_string($conn, $_POST['salary']);

               $insert = mysqli_query($conn, "insert into employees values('','$en','$ct','$pn','$gr','$bd','$sl')");

               echo "<script> alert('Insert Successfully'); </script>";
           }

      ?>
      <?php 
            if(isset($_POST["btnedit"]))
            {
               $id = mysqli_real_escape_string($conn, $_POST['eid']);
               $en = mysqli_real_escape_string($conn, $_POST['ename']);
               $ct = mysqli_real_escape_string($conn, $_POST['contact']);
               $pn = mysqli_real_escape_string($conn, $_POST['position']);
               $gr = mysqli_real_escape_string($conn, $_POST['gender']);
               $bd = mysqli_real_escape_string($conn, $_POST['birthdate']);
               $sl = mysqli_real_escape_string($conn, $_POST['salary']);

              $update = mysqli_query($conn,"UPDATE employees SET fullname = '$en', contact = '$ct', position ='$pn', gender = '$gr', birthdate ='$bd', salary ='$sl' WHERE emp_id = '$id' ");

              echo "<script> alert('Updated Successfull ...!'); </script>";
               
               

            }


      ?>
                    <?php
                    if(isset($_GET['idd'])){
                      $id = $_GET['idd'];
                      $tir = mysqli_query($conn,"delete from employees where emp_id = $id");
                    }
                    ?>
                    <?php 
                    $soo_daabac = mysqli_query($conn, "SELECT * FROM employees ");
                    while ($res = mysqli_fetch_array($soo_daabac)) { ?>
                    <td><?php echo $res[0];  ?></td>
                    <td><?php echo $res[1];  ?></td>
                    <td><?php echo $res[2];  ?></td>
                    <td><?php echo $res[3];  ?></td>
                    <td><?php echo $res[4];  ?></td>
                    <td><?php echo $res[5];  ?></td>
                    <td><?php echo $res[6];  ?></td>

                    <td>
                     <button type="button" alt="<?php echo $res['emp_id'];  ?>" class="btn btn-warning getedit" ><i class="fas fa-edit"></i></button>
                    </td>
                    <td>
                      <a href="VeiwEmployees.php?idd=<?php echo $res['emp_id']; ?>" onclick='return confirm("Matireysa Xogtaan ?")' class="btn btn-danger"><i class="fas fa-trash"></i></a>
                    </td>
                  </tr>
                   <?php 
                     }
                    ?>
                  </tbody>
                </table>
   </div> 
   <!-- /.card-body -->
  </div> 
  <!-- /.content -->
  </div> 
  <!-- /.content-wrapper -->

  <!-- Control Sidebar -->
  <aside class="control-sidebar control-sidebar-dark">
    <!-- Control sidebar content goes here -->
  </aside>
  <!-- /.control-sidebar -->
  </div>
  
 <!-- ./wrapper -->
 <?php include("libirary/footer.php"); ?>
 <?php include("models/emp_model.php"); ?> 
 <!-- jQuery -->
 <?php include("libirary/script.php"); ?>

 
<script>
   $(document).ready(function(){
      $("body"). on('click', '.getedit', function(){
        var u_id = "u_id="+$(this).attr("alt");

        $.ajax({
         url:"get/get_employees.php",
         method:"POST",
         data:u_id,            
         success:function(data){
              
          var res = data.split(",");
          $('#eid').val($.trim(res[0]));
          $('#ename').val(res[1]);
          $('#cont').val(res[2]);            
          $('#position').val(res[3]);    
          $('#gender').val(res[4]);
          $('#birthdate').val(res[5]);            
          $('#salary').val(res[6]);            
         
              

          $('#edit_employee_modal').modal('show');
            }
          });
        });
       });     

</script>
</body>
</html>
