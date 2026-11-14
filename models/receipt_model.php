<!-- insert Receipt Plus Charge model -->
      <div class="modal fade" id="insert_receipt_modal">
        <div class="modal-dialog modal-xl">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Create Sales Receipt Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button> 
            </div>
           <form class="frm" name="myform" action="" method="post">
            <div class="card-body">
              <div class="row">
                <div class="col-lg-6"> 
                <div class="form-group">
                    <label >Customer Name</label>
                    <select class="form-control" name="cname" id="dropdown" required="" >
                    <option class="form-control" selected disabled>Select Customer Name</option>
                    <?php
                    $soo_aqri = mysqli_query($conn, "select cust_id,CustomerName from customer");
                    while ($row =  mysqli_fetch_array($soo_aqri)) {
                      echo "<option value='$row[cust_id]'>$row[cust_id] $row[CustomerName]</option>";
                     } 
                    ?>
                    </select>
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Due Balance</label>
                    <input type="text" class="form-control" name="amoun" id="amount" readonly=""  >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >MC Hore</label>
                    <input type="text" class="form-control" name="mchore" id="mchore" irequired=""  >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >MC Danbe</label>
                    <input type="text" class="form-control" name="mcdanbe" id="mcdanbe" required="" onkeyup="subt()">
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Farqi</label>
                    <input type="text" class="form-control"  name="farqi" id="farqi" readonly="" >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Rate</label>
                    <input type="text" class="form-control" value="1.3"  name="rate" id="rate" required="" onkeyup="mult()" >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Balance</label>
                    <input type="text" class="form-control" name="balance" id="balance" readonly=""  >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Receipt</label>
                    <input type="text" class="form-control" name="receipt" id="receipt"   >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Discount</label>
                    <input type="text" class="form-control" name="discoun" value="0" id="discoun" onkeyup="rem()">
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Remainder</label>
                    <input type="text" class="form-control" name="remain" id="remain" readonly="" >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                <label >To Accoun</label>
                    <select class="form-control" name="tac" id="tac" required="" >
                    <?php
                    $soo_aqri = mysqli_query($conn, "select acc_id,acc_name from accoun");
                    while ($row =  mysqli_fetch_array($soo_aqri)) {
                      echo "<option value='$row[acc_id]'>$row[acc_name]</option>";
                     } ?>
                    </select>
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Month Date</label>
                    <input type="date" class="form-control" name="date" value="<?php echo $tariikh ?>" required="" >
                </div>
                </div>
                <div class="col-lg-12">
                <div class="modal-footer justify-content-between">
                  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                  <button type="submit" name="btnreceipt" class="btn btn-primary">Save</button>
                </div>
              </div>
              </div>
             </div>
          </form>
            
          </div>
          <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
      </div>
      <!-- /.modal fade -->
    </div>
<!-- ends -->

<!-- edit user model -->
      <div class="modal fade" id="edit_invoice_modal">
        <div class="modal-dialog modal-xl">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Edit Charge  Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
           <form class="frm" name="myform" action="" method="post">
            <div class="card-body">
              <div class="row">
                <div class="col-lg-6"> 
                <div class="form-group">
                    <label >Charge No.</label>
                    <input type="text"  class="form-control" name="vid" id="invid" readonly>
                </div>
                </div>
                <div class="col-lg-6"> 
                <div class="form-group">
                    <label >Guri No.</label>
                    <input type="text" class="form-control" name="cid" id="cname"  readonly>
                </div>
                </div>
                <div class="col-lg-6"> 
                <div class="form-group">
                    <label >MC Hore</label>
                    <input type="text" class="form-control" name="mhore" id="mhore" required="" >
                </div>
                </div>
                <div class="col-lg-6"> 
                <div class="form-group">
                    <label >MC Danbe</label>
                    <input type="text" class="form-control" name="mdanbe" id="mdanbe" required="" >
                </div>
                </div>
                <div class="col-lg-6"> 
                <div class="form-group">
                    <label >Farqi</label>
                    <input type="text" class="form-control" name="farqi" id="farqiga" required="" >
                </div>
                </div>
                <div class="col-lg-6"> 
                <div class="form-group">
                    <label >Rate</label>
                    <input type="text" class="form-control" name="rate" id="rateka" required="" >
                </div>
                </div>
                <div class="col-lg-6"> 
                <div class="form-group">
                    <label >Balance</label>
                    <input type="text" class="form-control" name="balance" id="balancega" required="" >
                </div>
                </div>
                <div class="col-lg-6"> 
                <div class="form-group">
                    <label >Month Date</label>
                    <input type="Date" class="form-control" name="date" id="dateka" required="" >
                </div>
                </div>
                <div class="col-lg-12"> 
                <!-- /.card-body -->

                <div class="modal-footer justify-content-between">
                  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                  <button type="submit" name="btnedit" class="btn btn-success">Update</button>
                </div>
              </div>
             </div>
          </form>
            
          </div>
          <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
      </div>
      <!-- /.modal fade -->
    </div>
<!-- ends -->