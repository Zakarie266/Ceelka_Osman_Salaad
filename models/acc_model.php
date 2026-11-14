<!-- insert Customer model -->
      <div class="modal fade" id="insert_accoun_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Accoun Registration Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="" method="post">
              <div class="card-body">
                <div class="form-group">
                    <label >Accoun No.</label>
                    <input type="text" class="form-control" name="accno" required="" placeholder="Enter Accoun Number">
                </div>
                <div class="form-group">
                    <label >Accoun Name</label>
                    <input type="text" class="form-control" name="acname" required="" placeholder="Enter Accoun Name">
                </div>
                <div class="form-group">
                    <label >Accoun Type</label>
                    <input type="text" class="form-control" name="actype" required="" placeholder="Enter Accoun Type">
                </div>
                <div class="form-group">
                    <label >Balance</label>
                    <input type="text" class="form-control" name="balance" required="" placeholder="Enter Balance">
                </div>
                <div class="form-group">
                   <label >Registration Date</label>
                   <input type="date" class="form-control" name="date" required="" >
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
      <div class="modal fade" id="edit_accoun_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Edit Accoun Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="" method="post">
              <div class="card-body">
                <div class="form-group">
                    <label >Accoun ID</label>
                    <input type="text"  class="form-control" name="acid"  id="acid" readonly>
                </div>
                <div class="form-group">
                    <label >Accoun No.</label>
                    <input type="text" class="form-control" name="accno" id="accno" required="" >
                </div>
                <div class="form-group">
                    <label >Accoun Name</label>
                    <input type="text" class="form-control" name="acname"  id="acname" required="">
                </div>
                <div class="form-group">
                    <label >Accoun Type</label>
                    <input type="text" class="form-control" name="actype"  id="actype" required="">
                </div>
                <div class="form-group">
                   <label >Balance</label>
                   <input type="text" class="form-control" name="balance"  id="balance"required="">
                </div>
                <div class="form-group">
                   <label >Registration Date</label>
                   <input type="date" class="form-control" name="date" id="date" required="" >
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


