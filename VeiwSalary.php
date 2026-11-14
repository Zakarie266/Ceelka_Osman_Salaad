<?php 
session_start();
include("conn.php");
?>
<!DOCTYPE html>
<html lang="en">
<head>
 <?php include("libirary/head.php"); ?>
 <script src="plugins/jquery/jquery.min.js"></script>

 <script>
  $(function(){
       $('#dropdown').on('change',function(){

        var id = $(this).val();
        $.post('get/get_emp_bl.php',{id:$(this).val()},function(res){
        var res1 = res.split(",");

        $("#salry").val($.trim(res1[0]));
       
               
        });

        });
     });
</script>
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
         <h3 class="card-title">Salary Payment Veiw Table</h3>
         <br>
  </div>
 <!-- /.card-header -->
  
    <div class="row md-2">
     <div class="col-md-10"></div>
     <div class="col-md-2">
      <br>
      <button type="button" class="btn btn-success fas fa-edit" data-toggle="modal" data-target="#insert_Salarypayment_modal">
       Salary Payment
      </button>
     </div>
    </div>
   <div class="card-body">
     <table id="example1" class="table table-bordered table-striped">
                  <thead>
                  <tr>
                    <th>ID</th>
                    <th>Employee Name</th>
                    <th>Salary</th>
                    <th>From Accoun</th>
                    <th>Date</th>

                    <th>Edit</th>
                    <th>Del</th>
                  </tr>
                  </thead>
                  <tbody>
                  <tr>
        <?php 
            if(isset($_POST["btnsave"]))
            {
              $em = mysqli_real_escape_string($conn, $_POST['eid']);
              $sy = mysqli_real_escape_string($conn, $_POST['salry']);
              $fc = mysqli_real_escape_string($conn, $_POST['fac']);
              $dt = mysqli_real_escape_string($conn, $_POST['dat']);

              $insert = mysqli_query($conn,"INSERT INTO salarypayment VALUES(null,'$em','$sy','$fc','$dt',1)");

              echo "<script> alert('Insert Successfull ...!'); </script>";


            }
      ?> 
      <?php 
            if(isset($_POST["btnedit"]))
            {
              $id = mysqli_real_escape_string($conn, $_POST['spid']);
              $en = mysqli_real_escape_string($conn, $_POST['ename']);
              $sl = mysqli_real_escape_string($conn, $_POST['salary']);
              $ac = mysqli_real_escape_string($conn, $_POST['facc']);
              $da = mysqli_real_escape_string($conn, $_POST['date']);

              $update = mysqli_query($conn,"UPDATE salarypayment SET  salary = '$sl', from_acc ='$ac', month_date ='$da' WHERE sp_id = '$id' ");

              echo "<script> alert('Updated Successfull ...!'); </script>";
               
               

            }


      ?>
                    <?php
                    if(isset($_GET['idd'])){
                      $id = $_GET['idd'];
                      $tir = mysqli_query($conn,"delete from salarypayment where sp_id = $id");
                    }
                    ?>
                    <?php 
                    $soo_daabac = mysqli_query($conn, "SELECT s.sp_id,e.fullname,s.salary,a.acc_name,s.month_date FROM salarypayment s JOIN employees e ON s.emp_id=e.emp_id JOIN accoun a ON a.acc_id=s.from_acc");
                    while ($res = mysqli_fetch_array($soo_daabac)) { ?>
                    <td><?php echo $res[0];  ?></td>
                    <td><?php echo $res[1];  ?></td>
                    <td><b>$</b><?php echo $res[2];  ?></td>
                    <td><?php echo $res[3];  ?></td>
                    <td><?php echo $res[4];  ?></td>

                    <td>
                     <button type="button" alt="<?php echo $res['sp_id'];  ?>" class="btn btn-warning getedit" ><i class="fas fa-edit"></i></button>
                    </td>
                    <td>
                      <a href="VeiwSalary.php?idd=<?php echo $res['sp_id']; ?>" onclick='return confirm("Matireysa Xogtaan ?")' class="btn btn-danger"><i class="fas fa-trash"></i></a>
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
 <?php include("models/salarypaymen_model.php"); ?> 
 <!-- jQuery -->
 <?php include("libirary/script.php"); ?>

 
<script>
   $(document).ready(function(){
      $("body"). on('click', '.getedit', function(){
        var u_id = "u_id="+$(this).attr("alt");

        $.ajax({
         url:"get/get_salarypayment.php",
         method:"POST",
         data:u_id,            
         success:function(data){
              
          var res = data.split(",");
          $('#spid').val($.trim(res[0]));
          $('#ename').val(res[1]);
          $('#salary').val(res[2]);           
          $('#facc').val(res[3]);
          $('#date').val(res[4]); 
              

          $('#edit_salarypayment_modal').modal('show');
            }
          });
        });
       });     

</script>
</body>
</html>
