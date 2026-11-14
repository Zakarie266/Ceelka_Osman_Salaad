<!-- insert Customer model -->
      <div class="modal fade" id="insert_Salarypayment_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Salary Payment Registration Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form name="myform" action="" method="post">
              <div class="card-body">
                <div class="form-group">
                    <label >Employee Name</label>
                    <select class="form-control" name="eid" id="dropdown" required="" >
                    <option class="form-control" selected disabled>Select Employee Name</option>
                    <?php
                    $soo_aqri = mysqli_query($conn, "select emp_id,fullname from employees");
                    while ($row =  mysqli_fetch_array($soo_aqri)) {
                      echo "<option value='$row[emp_id]'>$row[fullname]</option>";
                     } 
                    ?>
                    </select>
                </div>
                <div class="form-group">
                    <label >Salary Pay</label>
                    <input type="text" class="form-control" name="salry" id="salry" readonly="" >
                </div>
                <div class="form-group">
                    <label >From Accoun</label>
                    <select class="form-control" name="fac" required="" >
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
                    <input type="date" class="form-control" name="dat"  required="" >
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
      <div class="modal fade" id="edit_salarypayment_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Edit Salary Payment Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="" method="post">
              <div class="card-body">
                <div class="form-group">
                    <label >Payment ID</label>
                    <input type="text"  class="form-control" name="spid"  id="spid" readonly>
                </div>
                <div class="form-group">
                    <label >Employee ID</label>
                    <input type="text" class="form-control" name="ename"  id="ename" readonly>
                </div>
                <div class="form-group">
                    <label >Salary Pay</label>
                    <input type="text" class="form-control" name="salary" id="salary" irequired=""  >
                </div>
                <div class="form-group">
                    <label >From Accoun</label>
                    <input type="text" class="form-control"  name="facc" id="facc" readonly  >
                </div>
                <div class="form-group">
                    <label >Payment Date</label>
                    <input type="date" class="form-control" name="date" id="date"   required="" >
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


