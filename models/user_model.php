<!-- edit user model -->
      <div class="modal fade" id="edit_user_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Edit User Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="" method="post">
               <div class="card-body">
                <div class="form-group">
                    <label >User ID</label>
                    <input type="text"  class="form-control" name="uid"  id="uid" readonly>
                </div>
                <div class="form-group">
                    <label >Employee ID</label>
                    <input type="text"  class="form-control" name="eid"  id="eid" readonly>
                </div>
                <div class="form-group">
                    <label >Username</label>
                    <input type="text" class="form-control" name="uname"  id="uname" required="">
                </div>
                <div class="form-group">
                    <label >Password</label>
                    <input type="text" class="form-control" name="pass"  id="pass" required="">
                </div>
                <div class="form-group">
                   <label>User Type</label>
                        <select class="custom-select" name="utype" id="utype" required="">
                          <option selected disabled value="">Select User Type</option>
                          <option>Admin</option>
                          <option>Mannager</option>
                          <option>User</option>
                        </select>
                </div>
                <div class="form-group">
                   <label >Registered Date</label>
                   <input type="date" class="form-control" name="dat"  id="date">
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

<!-- insert user model -->
      <div class="modal fade" id="insert_user_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">User Registration Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="" method="post">
               <div class="card-body">
                <div class="form-group">
                    <label >Employee Name</label>
                    <select class="form-control" name="empname" required="" >
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
                    <label >Username</label>
                    <input type="text" class="form-control" name="username" required="" placeholder="Enter Username">
                </div>
                <div class="form-group">
                    <label >Password</label>
                    <input type="password" class="form-control" name="password" required="" placeholder="Enter Password">
                </div>
                <div class="form-group">
                    <label>User Type</label> 
                        <select class="custom-select" name="usertype" required="">
                          <option selected disabled value="">Select User Type</option>
                          <option>Admin</option>
                          <option>Mannager</option>
                          <option>User</option>
                        </select>
                </div>
                <div class="form-group">
                    <label >Registered Date</label>
                    <input type="date" class="form-control" name="date" required="" >
                </div>
                <!-- /.card-body -->

            <div class="modal-footer justify-content-between">
              <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              <button type="submit" name="btnregister" class="btn btn-primary">Register</button>
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