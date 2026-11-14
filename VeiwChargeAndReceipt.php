<?php 
session_start();
include("conn.php");
$data = mysqli_query($conn,"SELECT month_data FROM `invoice` ORDER BY invo_id DESC LIMIT 1");
while ($ros = mysqli_fetch_array($data)) {
$tariikh = $ros[0];  
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
 
        if (elm["mcdanbe"].value != "" && elm["mchore"].value != "")
          {elm["farqi"].value = parseFloat(elm["mcdanbe"].value) - parseFloat(elm["mchore"].value);}
  }
   function mult(){
     var elm = document.forms["myform"];

        if (elm["farqi"].value != "" && elm["rate"].value != "")
          {elm["balance"].value = Math.round(parseFloat(elm["farqi"].value) * parseFloat(elm["rate"].value),'e2');
           elm["receipt"].value = Math.round(parseFloat(elm["farqi"].value) * parseFloat(elm["rate"].value),'e2');}
  }
    function rem(){
     var elm = document.forms["myform"];

    if (elm["amoun"].value != "" && elm["balance"].value != ""&& elm["receipt"].value != "" && elm["discoun"].value != "")
        {elm["remain"].value = parseFloat(elm["amoun"].value) + parseFloat(elm["balance"].value) - parseFloat(elm["receipt"].value) - parseFloat(elm["discoun"].value);}
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
  <script>
  $(function(){
       $('#dropdown').on('change',function(){

        var id = $(this).val();
        $.post('get/get_cust_mc.php',{id:$(this).val()},function(res){
        var res1 = res.split(",");

        $("#mchore").val($.trim(res1[0]));
       
               
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
         <h3 class="card-title">Charge Veiw Table</h3>
         <br>
  </div>
 <!-- /.card-header -->

    <div class="row md-2">
     <div class="col-md-8">
       <input type="hidden" name="ut" value="<?php $id= $_SESSION['id']; ?>">
     </div>
     <div class="col-md-2">
     </div>
     <div class="col-md-2">
      <br>
      <button type="button" class="btn btn-primary fas fa-edit" data-toggle="modal" data-target="#insert_receipt_modal">
       Create Receipt
      </button>
     </div>
    </div>
   <div class="card-body">
     <table id="example1" class="table table-bordered table-striped">
                  <thead>
                  <tr>
                    <th>Ch-No.</th>
                    <th>Customer Name</th>
                    <th>MC Hore</th>
                    <th>MC Danbe</th>
                    <th>Farqi</th>
                    <th>Rate</th>
                    <th>Balance</th>
                    <th>Month Date</th>

                    <th>Edit</th>
                    <th>Del</th>
                  </tr>
                  </thead>
                  <tbody>
                  <tr>
        <?php 
            if(isset($_POST["btnsave"]))
            {
              $cu = mysqli_real_escape_string($conn, $_POST['custname']);
              $mh = mysqli_real_escape_string($conn, $_POST['mchore']);
              $md = mysqli_real_escape_string($conn, $_POST['mcdanbe']);
              $fa = mysqli_real_escape_string($conn, $_POST['farqi']);
              $ra = mysqli_real_escape_string($conn, $_POST['rate']);
              $ba = mysqli_real_escape_string($conn, $_POST['balance']);
              $da = mysqli_real_escape_string($conn, $_POST['date']);

              $insert = mysqli_query($conn,"insert into invoice values('','$cu','$mh','$md','$fa','$ra','$ba','$da','$id')");

              echo "<script> alert('Insert Successfull ...!'); </script>";


            }
      ?> 
      <?php 
            if(isset($_POST["btnreceipt"]))
            {
              $cu = mysqli_real_escape_string($conn, $_POST['cname']);
              $mh = mysqli_real_escape_string($conn, $_POST['mchore']);
              $md = mysqli_real_escape_string($conn, $_POST['mcdanbe']);
              $fa = mysqli_real_escape_string($conn, $_POST['farqi']);
              $ra = mysqli_real_escape_string($conn, $_POST['rate']);
              $ba = mysqli_real_escape_string($conn, $_POST['balance']);
              $am = mysqli_real_escape_string($conn, $_POST['receipt']);
              $ds = mysqli_real_escape_string($conn, $_POST['discoun']);
              $rm = mysqli_real_escape_string($conn, $_POST['remain']);
              $tc = mysqli_real_escape_string($conn, $_POST['tac']);
              $da = mysqli_real_escape_string($conn, $_POST['date']);

              $insert = mysqli_query($conn,"insert into invoice values('','$cu','$mh','$md','$fa','$ra','$ba','$da','$id')");

              if(empty($_POST["receipt"])){
                echo "<script> alert('Insert Successfull ...!'); </script>";
              }
              else{
                $insert = mysqli_query($conn,"insert into receipt values('','$cu','$am','$ds','$rm','$tc','$da','$id')");
                echo "<script> alert('Insert Successfull ...!'); </script>";
              }
            }
      ?> 
      <?php 
            if(isset($_POST["btnedit"]))
            {
              $id = mysqli_real_escape_string($conn, $_POST['vid']);
              $cn = mysqli_real_escape_string($conn, $_POST['cid']);
              $mh = mysqli_real_escape_string($conn, $_POST['mhore']);
              $md = mysqli_real_escape_string($conn, $_POST['mdanbe']);
              $fa = mysqli_real_escape_string($conn, $_POST['farqi']);
              $ra = mysqli_real_escape_string($conn, $_POST['rate']);
              $ba = mysqli_real_escape_string($conn, $_POST['balance']);
              $da = mysqli_real_escape_string($conn, $_POST['date']);

              $update = mysqli_query($conn,"UPDATE invoice SET cust_id = '$cn', mchore = '$mh', mcdanbe ='$md', farqi = '$fa', rate ='$ra', balance = '$ba', month_data ='$da', user_id = '1' WHERE invo_id = '$id' ");

              echo "<script> alert('Updated Successfull ...!'); </script>";
               
               

            }


      ?>
                    <?php
                    if(isset($_GET['idd'])){
                      $id = $_GET['idd'];
                      $tir = mysqli_query($conn,"delete from invoice where invo_id = $id");
                    }
                    ?>
                    <?php 
                    $soo_daabac = mysqli_query($conn, "SELECT i.invo_id,concat(c.cust_id,' ',c.CustomerName),i.mchore,i.mcdanbe,i.farqi,i.rate,i.balance,i.month_data  FROM customer c JOIN invoice i ON c.cust_id=i.cust_id ORDER BY i.invo_id DESC LIMIT 6");
                    while ($res = mysqli_fetch_array($soo_daabac)) { ?>
                    <td><?php echo $res[0];  ?></td>
                    <td><?php echo $res[1];  ?></td>
                    <td><?php echo $res[2];  ?></td>
                    <td><?php echo $res[3];  ?></td>
                    <td><?php echo $res[4];  ?></td>
                    <td><?php echo $res[5];  ?></td>
                    <td><b>$</b><?php echo $res[6];  ?></td>
                    <td><?php echo $res[7];  ?></td>

                    <td>
                     <button type="button" alt="<?php echo $res['invo_id'];  ?>" class="btn btn-warning getedit" ><i class="fas fa-edit"></i></button>
                    </td>
                    <td>
                      <a href="VeiwChargeAndReceipt.php?idd=<?php echo $res['invo_id']; ?>" onclick='return confirm("Matireysa Xogtaan ?")' class="btn btn-danger"><i class="fas fa-trash"></i></a>
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
 <?php include("models/receipt_model.php"); ?> 
 <!-- jQuery --> 
 <?php include("libirary/script.php"); ?>

 
<script>
   $(document).ready(function(){
      $("body"). on('click', '.getedit', function(){
        var u_id = "u_id="+$(this).attr("alt");

        $.ajax({
         url:"get/get_invoice.php",
         method:"POST",
         data:u_id,            
         success:function(data){
              
          var res = data.split(",");
          $('#invid').val($.trim(res[0]));
          $('#cname').val(res[1]);
          $('#mhore').val(res[2]);            
          $('#mdanbe').val(res[3]);    
          $('#farqiga').val(res[4]);
          $('#rateka').val(res[5]);   
          $('#balancega').val(res[6]);            
          $('#dateka').val(res[7]);           
         
              

          $('#edit_invoice_modal').modal('show');
            }
          });
        });
       });     

</script>
</body>
</html>
