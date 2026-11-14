<!-- edit user model -->
      <div class="modal fade" id="insert_employee_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Employee Registration Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="" method="post">
              <div class="card-body">
                <div class="form-group">
                    <label >Employee Name</label>
                    <input type="text" class="form-control" name="ename" required="" placeholder="Enter Fullname">
                </div>
                <div class="form-group">
                    <label >Contact</label>
                    <input type="text" class="form-control" name="contact" required="" placeholder="Enter Phone Number">
                </div>
                <div class="form-group">
                    <label >Position</label>
                    <input type="text" class="form-control" name="position" required="" placeholder="Enter Position">
                </div>
                <div class="form-group">
                   <label>Gender</label>
                        <select class="custom-select" name="gender" required="">
                          <option selected disabled value="">Select Gender</option>
                          <option>Male</option>
                          <option>Female</option>
                        </select>
                </div>
                <div class="form-group">
                    <label >Birthdate</label>
                    <input type="date" class="form-control" name="birthdate" required="" >
                </div>
                <div class="form-group">
                    <label >Salary</label>
                    <input type="text" class="form-control" name="salary" required="" placeholder="Enter Salary">
                </div>
                <!-- /.card-body -->

                <div class="modal-footer justify-content-between">
                  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                  <button type="submit" name="savebtn" class="btn btn-primary">Save</button>
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
      <div class="modal fade" id="edit_employee_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Edit Employee Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="" method="post">
              <div class="card-body">
                <div class="form-group">
                    <label >Employee ID</label>
                    <input type="text"  class="form-control" name="eid"  id="eid" readonly>
                </div>
                <div class="form-group">
                    <label >Employee Name</label>
                    <input type="text" class="form-control" name="ename" id="ename" required="" >
                </div>
                <div class="form-group">
                    <label >Contact</label>
                    <input type="text" class="form-control" name="contact" id="cont" required="">
                </div>
                <div class="form-group">
                    <label >Position</label>
                    <input type="text" class="form-control" name="position" id="position" required="" >
                </div>
                <div class="form-group">
                   <label>Gender</label>
                        <select class="custom-select" name="gender" id="gender" required="">
                          <option selected disabled value="">Select Gender</option>
                          <option>Male</option>
                          <option>Female</option>
                        </select>
                </div>
                <div class="form-group">
                    <label >Birthdate</label>
                    <input type="date" class="form-control" name="birthdate" id="birthdate" required="" >
                </div>
                <div class="form-group">
                    <label >Salary</label>
                    <input type="text" class="form-control" name="salary" id="salary" required="" >
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

