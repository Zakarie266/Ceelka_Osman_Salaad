<?php 
session_start();
include("conn.php");
$data = mysqli_query($conn,"SELECT month_date FROM `receipt` ORDER BY rv_id DESC LIMIT 1");
while ($ros = mysqli_fetch_array($data)) {
$tarikh = $ros[0];  
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
 <?php include("libirary/head.php"); ?>
 <script src="plugins/jquery/jquery.min.js"></script>
 <script>
    function subt(){
     var elm = document.forms["myform"];

        if (elm["amoun"].value != "" && elm["receip"].value != "" && elm["discoun"].value != "")
          {elm["remain"].value = parseFloat(elm["amoun"].value) - parseFloat(elm["receip"].value) - parseFloat(elm["discoun"].value);}
  }
 </script>
 <script>
  $(function(){
       $('#dropdown').on('change',function(){

        var id = $(this).val();
        $.post('get/get_cust_bl.php',{id:$(this).val()},function(res){
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
         <h3 class="card-title">Receipt Payment Veiw Table</h3>
         <br>
  </div>
 <!-- /.card-header -->
  
    <div class="row md-2">
     <div class="col-md-10"></div>
     <div class="col-md-2">
      <br>
      <button type="button" id="customer" class="btn btn-success fas fa-edit" data-toggle="modal" data-target="#insert_receive_modal">
       Add Receipt
      </button>
     </div>
    </div>
   <div class="card-body">
     <table id="example1" class="table table-bordered table-striped">
                  <thead>
                  <tr>
                    <th>R-No.</th>
                    <th>Customer Name</th>
                    <th>Amount</th>
                    <th>Discount</th>
                    <th>Remainder</th>
                    <th>To Accoun</th>
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
              $cn = mysqli_real_escape_string($conn, $_POST['cname']);
              $am = mysqli_real_escape_string($conn, $_POST['receip']);
              $ds = mysqli_real_escape_string($conn, $_POST['discoun']);
              $rm = mysqli_real_escape_string($conn, $_POST['remain']);
              $tc = mysqli_real_escape_string($conn, $_POST['tac']);
              $da = mysqli_real_escape_string($conn, $_POST['date']);

              $insert = mysqli_query($conn,"insert into receipt values('','$cn','$am','$ds','$rm','$tc','$da','1')");

              echo "<script> alert('Insert Successfull ...!'); </script>";


            }
      ?> 
      <?php 
            if(isset($_POST["btnedit"]))
            {
              $id = mysqli_real_escape_string($conn, $_POST['rvid']);
              $cn = mysqli_real_escape_string($conn, $_POST['cname']);
              $am = mysqli_real_escape_string($conn, $_POST['amoun']);
              $ds = mysqli_real_escape_string($conn, $_POST['discount']);
              $rm = mysqli_real_escape_string($conn, $_POST['remainn']);
              $ac = mysqli_real_escape_string($conn, $_POST['tacc']);
              $da = mysqli_real_escape_string($conn, $_POST['data']);

              $update = mysqli_query($conn,"UPDATE receipt SET cust_id = '$cn', amount = '$am', discount ='$ds', remainder = '$rm' , to_acc = '$ac', month_date ='$da', user_id ='1' WHERE rv_id = '$id' ");

              echo "<script> alert('Updated Successfull ...!'); </script>";
               
               

            }


      ?>
                    <?php
                    if(isset($_GET['idd'])){
                      $id = $_GET['idd'];
                      $tir = mysqli_query($conn,"delete from receipt where rv_id = $id");
                    }
                    ?>
                    <?php 
                    $soo_daabac = mysqli_query($conn, "SELECT r.rv_id,concat(c.cust_id,' ',c.CustomerName),r.amount,r.discount,r.remainder,a.acc_name,r.month_date FROM receipt r JOIN customer c ON r.cust_id=c.cust_id JOIN accoun a ON a.acc_id=r.to_acc ORDER BY r.rv_id DESC LIMIT 6 ");
                    while ($res = mysqli_fetch_array($soo_daabac)) { ?>
                    <td><?php echo $res[0];  ?></td>
                    <td><?php echo $res[1];  ?></td>
                    <td><b>$</b><?php echo $res[2];  ?></td>
                    <td><?php echo $res[3];  ?></td>
                    <td><?php echo $res[4];  ?></td>
                    <td><?php echo $res[5];  ?></td>
                    <td><?php echo $res[6];  ?></td>

                    <td>
                     <button type="button" alt="<?php echo $res['rv_id'];  ?>" class="btn btn-warning getedit" ><i class="fas fa-edit"></i></button>
                    </td>
                    <td>
                      <a href="VeiwReceive.php?idd=<?php echo $res['rv_id']; ?>" onclick='return confirm("Matireysa Xogtaan ?")' class="btn btn-danger"><i class="fas fa-trash"></i></a>
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
 <?php include("models/receive_model.php"); ?> 
 <!-- jQuery -->
 <?php include("libirary/script.php"); ?>

 
<script>
   $(document).ready(function(){
      $("body"). on('click', '.getedit', function(){
        var u_id = "u_id="+$(this).attr("alt");

        $.ajax({
         url:"get/get_receipt.php",
         method:"POST",
         data:u_id,            
         success:function(data){
              
          var res = data.split(",");
          $('#rvid').val($.trim(res[0]));
          $('#cname').val(res[1]);
          $('#amoun').val(res[2]);            
          $('#discount').val(res[3]);              
          $('#remainn').val(res[4]);            
          $('#tacc').val(res[5]);
          $('#data').val(res[6]); 
              

          $('#edit_receive_modal').modal('show');
            }
          });
        });
       });     

</script>
</body>
</html>
