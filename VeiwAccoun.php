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
         <h3 class="card-title">Accoun Veiw Table</h3>
         <br>
  </div>
 <!-- /.card-header -->
  
    <div class="row md-2">
     <div class="col-md-10"></div>
     <div class="col-md-2">
      <br>
      <button type="button" class="btn btn-success fas fa-edit" data-toggle="modal" data-target="#insert_accoun_modal">
       Add Accoun
      </button>
     </div>
    </div>
   <div class="card-body">
     <table id="example1" class="table table-bordered table-striped">
                  <thead>
                  <tr>
                    <th>Accoun No.</th>
                    <th>Accoun Name</th>
                    <th>Accoun Type</th>
                    <th>Balance</th>
                    <th>Reg Date</th>

                    <th>Edit</th>
                    <th>Del</th>
                  </tr>
                  </thead>
                  <tbody>
                  <tr>
        <?php 
            if(isset($_POST["btnsave"]))
            {
              $an = mysqli_real_escape_string($conn, $_POST['accno']);
              $ac = mysqli_real_escape_string($conn, $_POST['acname']);
              $at = mysqli_real_escape_string($conn, $_POST['actype']);
              $ba = mysqli_real_escape_string($conn, $_POST['balance']);
              $da = mysqli_real_escape_string($conn, $_POST['date']);

              $insert = mysqli_query($conn,"insert into accoun values('','$an','$ac','$at','$ba','$da')");

              echo "<script> alert('Insert Successfull ...!'); </script>";


            }
      ?> 
      <?php 
            if(isset($_POST["btnedit"]))
            {
              $id = mysqli_real_escape_string($conn, $_POST['acid']);
              $an = mysqli_real_escape_string($conn, $_POST['accno']);
              $ac = mysqli_real_escape_string($conn, $_POST['acname']);
              $at = mysqli_real_escape_string($conn, $_POST['actype']);
              $ba = mysqli_real_escape_string($conn, $_POST['balance']);
              $da = mysqli_real_escape_string($conn, $_POST['date']);

              $update = mysqli_query($conn,"UPDATE accoun SET acc_no = '$an', acc_name = '$ac', acc_type = '$at', balance ='$ba',reg_date='$da' WHERE acc_id = '$id' ");

              echo "<script> alert('Updated Successfull ...!'); </script>";
               
               

            }


      ?>
                    <?php
                    if(isset($_GET['idd'])){
                      $id = $_GET['idd'];
                      $tir = mysqli_query($conn,"delete from customer where cust_id = $id");
                    }
                    ?>
                    <?php 
                    $soo_daabac = mysqli_query($conn, "SELECT * FROM accoun ");
                    while ($res = mysqli_fetch_array($soo_daabac)) { ?>
                    <td><?php echo $res[1];  ?></td>
                    <td><?php echo $res[2];  ?></td>
                    <td><?php echo $res[3];  ?></td>
                    <td><b>$</b><?php echo $res[4];  ?></td>
                    <td><?php echo $res[5];  ?></td>
                    

                    <td>
                     <button type="button" alt="<?php echo $res['acc_id'];  ?>" class="btn btn-warning getedit" ><i class="fas fa-edit"></i></button>
                    </td>
                    <td>
                      <a href="VeiwAccoun.php?idd=<?php echo $res['acc_id']; ?>" onclick='return confirm("Matireysa Xogtaan ?")' class="btn btn-danger"><i class="fas fa-trash"></i></a>
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
 <?php include("models/acc_model.php"); ?> 
 <!-- jQuery -->
 <?php include("libirary/script.php"); ?>

 
<script>
   $(document).ready(function(){
      $("body"). on('click', '.getedit', function(){
        var u_id = "u_id="+$(this).attr("alt");

        $.ajax({
         url:"get/get_accoun.php",
         method:"POST",
         data:u_id,            
         success:function(data){
              
          var res = data.split(",");
          $('#acid').val($.trim(res[0]));
          $('#accno').val(res[1]);
          $('#acname').val(res[2]);
          $('#actype').val(res[3]);            
          $('#balance').val(res[4]);             
          $('#date').val(res[5]); 
              

          $('#edit_accoun_modal').modal('show');
            }
          });
        });
       });     

</script>
</body>
</html>
