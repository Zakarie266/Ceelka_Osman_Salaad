<!-- insert Customer model -->
      <div class="modal fade" id="insert_receive_modal">
        <div class="modal-dialog modal-xl">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Receive Payment Modal</h4>
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
                    <label ></label>
                    <input type="text" class="form-control" name="amoun" id="amount" readonly=""  >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Amount</label>
                    <input type="text" class="form-control" name="receip" id="receip" irequired=""  >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Discount</label>
                    <input type="text" class="form-control" name="discoun" id="discoun" value="0" onkeyup="subt()">
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
                     } 
                    ?>
                    </select>
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Receive Date</label>
                    <input type="date" class="form-control" name="date" value="<?php echo $tarikh ?>" required="" >
                </div>
                </div>
                <div class="col-lg-12">
                <!-- /.card-body -->

                <div class="modal-footer justify-content-between">
                   <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                   <button type="submit" name="btnsave" class="btn btn-primary">Save</button>
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
      <div class="modal fade" id="edit_receive_modal">
        <div class="modal-dialog modal-xl">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Edit Receive Payment Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
           <form class="frm" name="myform" action="" method="post">
            <div class="card-body">
              <div class="row">
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Receipt ID</label>
                    <input type="text"  class="form-control" name="rvid"  id="rvid" readonly>
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Customer ID</label>
                    <input type="text" class="form-control" name="cname"  id="cname" readonly>
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Amount</label>
                    <input type="text" class="form-control" name="amoun" id="amoun" irequired=""  >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Discount</label>
                    <input type="text" class="form-control" name="discount" id="discount" required="" >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Remainder</label>
                    <input type="text" class="form-control" name="remainn" id="remainn" required="" >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >To Accoun</label>
                    <input type="text" class="form-control"  name="tacc" id="tacc" readonly  >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Receive Date</label>
                    <input type="Date" class="form-control" name="data" id="data" required="" >
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


