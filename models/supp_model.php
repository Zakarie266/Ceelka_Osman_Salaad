<!-- insert Customer model -->
      <div class="modal fade" id="insert_supplier_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Supplier Registration Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="" method="post">
              <div class="card-body">
                <div class="form-group">
                    <label >Supplier Name</label>
                    <input type="text" class="form-control" name="sname" required="" placeholder="Enter Fullname">
                </div>
                <div class="form-group">
                    <label >Contact</label>
                    <input type="text" class="form-control" name="contact" required="" placeholder="Enter Phone Number">
                </div>
                <div class="form-group">
                    <label >Zone</label>
                    <input type="text" class="form-control" name="zone" required="" placeholder="Enter Supplier Zone">
                </div>
                <div class="form-group">
                    <label >Balance</label>
                    <input type="text" class="form-control" name="balance" required="" placeholder="Enter Supplier Balance">
                </div>
                <div class="form-group">
                   <label >Reg Date</label>
                   <input type="date" class="form-control" name="date"  required="" >
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
      <div class="modal fade" id="edit_supplier_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Edit Supplier Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="" method="post">
              <div class="card-body">
                <div class="form-group">
                    <label >ID</label>
                    <input type="text"  class="form-control" name="sid"  id="sid" readonly>
                </div>
                <div class="form-group">
                    <label >Supplier Name</label>
                    <input type="text" class="form-control" name="sname"  id="sname" required="">
                </div>
                <div class="form-group">
                    <label >Contact</label>
                    <input type="text" class="form-control" name="cont"  id="cont" required="">
                </div>
                <div class="form-group">
                   <label >Zone</label>
                   <input type="text" class="form-control" name="zone"  id="zone">
                </div>
                <div class="form-group">
                    <label >Balance</label>
                    <input type="text" class="form-control" name="balance"  id="balance" >
                </div>
                <div class="form-group">
                   <label >Reg Date</label>
                   <input type="date" class="form-control" name="date"  id="date" required="">
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


