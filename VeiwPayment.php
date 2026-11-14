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
    function subt(){
     var elm = document.forms["myform"];

        if (elm["amoun"].value != "" && elm["paymen"].value != "" && elm["discoun"].value != "")
          {elm["remain"].value = Math.round(parseFloat(elm["amoun"].value) - parseFloat(elm["paymen"].value) - parseFloat(elm["discoun"].value),'e2');}
  }
 </script>
 <script>
  $(function(){
       $('#dropdown').on('change',function(){

        var id = $(this).val();
        $.post('get/get_supp_bl.php',{id:$(this).val()},function(res){
        var res1 = res.split(",");

        $("#amount").val($.trim(res1[0]));
       
               
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
         <h3 class="card-title">Payment Veiw Table</h3>
         <br>
  </div>
 <!-- /.card-header -->
  
    <div class="row md-2">
     <div class="col-md-10"></div>
     <div class="col-md-2">
      <br>
      <button type="button" class="btn btn-success fas fa-edit" data-toggle="modal" data-target="#insert_payment_modal">
       Add Payment
      </button>
     </div>
    </div>
   <div class="card-body">
     <table id="example1" class="table table-bordered table-striped">
                  <thead>
                  <tr>
                    <th>P-No.</th>
                    <th>Supplier Name</th>
                    <th>Amount</th>
                    <th>Discount</th>
                    <th>Remainder</th>
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
              $cn = mysqli_real_escape_string($conn, $_POST['sname']);
              $am = mysqli_real_escape_string($conn, $_POST['paymen']);
              $ds = mysqli_real_escape_string($conn, $_POST['discoun']);
              $rm = mysqli_real_escape_string($conn, $_POST['remain']);
              $fc = mysqli_real_escape_string($conn, $_POST['facc']);
              $da = mysqli_real_escape_string($conn, $_POST['date']);

              $insert = mysqli_query($conn,"insert into payment values('','$cn','$am','$ds','$rm','$fc','$da','1')");

              echo "<script> alert('Insert Successfull ...!'); </script>";


            }
      ?> 
      <?php 
            if(isset($_POST["btnedit"]))
            {
              $id = mysqli_real_escape_string($conn, $_POST['poid']);
              $am = mysqli_real_escape_string($conn, $_POST['amoun']);
              $ds = mysqli_real_escape_string($conn, $_POST['discoun']);
              $rm = mysqli_real_escape_string($conn, $_POST['remain']);
              $da = mysqli_real_escape_string($conn, $_POST['date']);

              $update = mysqli_query($conn,"UPDATE payment SET  amoun_pay = '$am', discount ='$ds', remainder = '$rm' month_date ='$da' WHERE po_id = '$id' ");

              echo "<script> alert('Updated Successfull ...!'); </script>";
               
               

            }


      ?>
                    <?php
                    if(isset($_GET['idd'])){
                      $id = $_GET['idd'];
                      $tir = mysqli_query($conn,"delete from payment where po_id = $id");
                    }
                    ?>
                    <?php 
                    $soo_daabac = mysqli_query($conn, "SELECT p.po_id,s.supp_name,p.amoun_pay,p.discount,p.remainder,a.acc_name,p.month_date FROM supplier s JOIN payment p ON s.supp_id=p.supp_id JOIN accoun a ON a.acc_id=p.from_acc");
                    while ($res = mysqli_fetch_array($soo_daabac)) { ?>
                    <td><?php echo $res[0];  ?></td>
                    <td><?php echo $res[1];  ?></td>
                    <td><b>$</b><?php echo $res[2];  ?></td>
                    <td><?php echo $res[3];  ?></td>
                    <td><?php echo $res[4];  ?></td>
                    <td><?php echo $res[5];  ?></td>
                    <td><?php echo $res[6];  ?></td>

                    <td>
                     <button type="button" alt="<?php echo $res['po_id'];  ?>" class="btn btn-warning getedit" ><i class="fas fa-edit"></i></button>
                    </td>
                    <td>
                      <a href="VeiwPayment.php?idd=<?php echo $res['po_id']; ?>" onclick='return confirm("Matireysa Xogtaan ?")' class="btn btn-danger"><i class="fas fa-trash"></i></a>
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
 <?php include("models/paymen_model.php"); ?> 
 <!-- jQuery -->
 <?php include("libirary/script.php"); ?>

 
<script>
   $(document).ready(function(){
      $("body"). on('click', '.getedit', function(){
        var u_id = "u_id="+$(this).attr("alt");

        $.ajax({
         url:"get/get_payment.php",
         method:"POST",
         data:u_id,            
         success:function(data){
              
          var res = data.split(",");
          $('#poid').val($.trim(res[0]));
          $('#sname').val(res[1]);
          $('#amoun').val(res[2]);            
          $('#discoun').val(res[3]);              
          $('#remain').val(res[4]);            
          $('#facc').val(res[5]);
          $('#date').val(res[6]); 
              

          $('#edit_payment_modal').modal('show');
            }
          });
        });
       });     

</script>
</body>
</html>
