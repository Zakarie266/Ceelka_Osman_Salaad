<!-- insert Customer model -->
      <div class="modal fade" id="insert_payment_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Payment Registration Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form name="myform" action="" method="post">
              <div class="card-body">
                <div class="form-group">
                    <label >Supplier Name</label>
                    <select class="form-control" name="sname" id="dropdown" required="" >
                    <option class="form-control" selected disabled>Select Supplier Name</option>
                    <?php
                    $soo_aqri = mysqli_query($conn, "select supp_id,supp_name from supplier");
                    while ($row =  mysqli_fetch_array($soo_aqri)) {
                      echo "<option value='$row[supp_id]'>$row[supp_name]</option>";
                     } 
                    ?>
                    </select>
                </div>
                <div class="form-group">
                    <label ></label>
                    <input type="text" class="form-control" name="amoun" id="amount" readonly=""  >
                </div>
                <div class="form-group">
                    <label >Amount</label>
                    <input type="text" class="form-control" name="paymen" id="paymen" irequired=""  >
                </div>
                <div class="form-group">
                    <label >Discount</label>
                    <input type="text" class="form-control" name="discoun" id="discoun" required="" onkeyup="subt()">
                </div>
                <div class="form-group">
                    <label >Remainder</label>
                    <input type="text" class="form-control" name="remain" id="remain" readonly="" >
                </div>
                <div class="form-group">
                    <label >From Accoun</label>
                    <select class="form-control" name="facc" id="facc" required="" >
                    <option class="form-control" selected disabled>Select Accoun Name</option>
                    <?php
                    $soo_aqri = mysqli_query($conn, "select acc_id,acc_name from accoun");
                    while ($row =  mysqli_fetch_array($soo_aqri)) {
                      echo "<option value='$row[acc_id]'>$row[acc_name]</option>";
                     } 
                    ?>
                    </select>
                </div>
                <div class="form-group">
                    <label >Payment Date</label>
                    <input type="Date" class="form-control" name="date"  required="" >
                </div>
                <!-- /.card-body -->

                <div class="modal-footer justify-content-between">
                   <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                   <button type="submit" name="btnsave" class="btn btn-primary">Save</button>
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
      <div class="modal fade" id="edit_payment_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Edit Receipt Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="" method="post">
              <div class="card-body">
                <div class="form-group">
                    <label >Payment ID</label>
                    <input type="text"  class="form-control" name="poid"  id="poid" readonly>
                </div>
                <div class="form-group">
                    <label >Supplier ID</label>
                    <input type="text" class="form-control" name="sname"  id="sname" readonly>
                </div>
                <div class="form-group">
                    <label >Amount</label>
                    <input type="text" class="form-control" name="amoun" id="amoun" irequired=""  >
                </div>
                <div class="form-group">
                    <label >Discount</label>
                    <input type="text" class="form-control" name="discoun" id="discoun" required="" >
                </div>
                <div class="form-group">
                    <label >Remainder</label>
                    <input type="text" class="form-control" name="remain" id="remain" required="" >
                </div>
                <div class="form-group">
                    <label >From Accoun</label>
                    <input type="text" class="form-control"  name="facc" id="facc" readonly  >
                </div>
                <div class="form-group">
                    <label >Payment Date</label>
                    <input type="Date" class="form-control" name="date"  required="" >
                </div>
                <!-- /.card-body -->

                <div class="modal-footer justify-content-between">
                  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                  <button type="submit" name="btnedit" class="btn btn-success">Update</button>
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


