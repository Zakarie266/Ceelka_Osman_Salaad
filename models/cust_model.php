<!-- insert Customer model -->
      <div class="modal fade" id="insert_customer_modal">
        <div class="modal-dialog modal-xl">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Customer Registration Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
           <form class="frm" name="myform" action="" method="post">
            <div class="card-body">
              <div class="row">
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Guri No.</label>
                    <input type="text" class="form-control" name="gurin"  placeholder="Enter Home No.">
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Customer Name</label>
                    <input type="text" class="form-control" name="custname" required="" placeholder="Enter Customer Name">
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Contact</label>
                    <input type="text" class="form-control" name="contact" value="61" required="" placeholder="Enter Phone Number">
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Zone</label>
                    <input type="text" class="form-control" name="zone" value="Deriska Ceelka" required="" placeholder="Enter Customer Zone">
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                   <label >Meter Cube</label>
                   <input type="text" class="form-control" name="mcube" value="0" required="" placeholder="Enter Customer Meter Cube" >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                   <label >Fee</label>
                   <input type="text" class="form-control" name="fee" value="0" required=""  placeholder="Enter Customer Fee" >
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                   <label >Registration Date</label>
                   <input type="date" class="form-control" name="date" value="<?php echo date('Y-m-d');  ?>" required="" >
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
      <div class="modal fade" id="edit_customer_modal">
        <div class="modal-dialog modal-xl">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">Edit Customer Modal</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
           <form class="frm" name="myform" action="" method="post">
            <div class="card-body">
              <div class="row">
                <div class="col-lg-6">
                <span id="gurin"></span>
                <div class="form-group">
                    <label >Guri No.</label>
                    <input type="text" class="form-control" name="guri"  id="guri" readonly="">
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Customer Name</label>
                    <input type="text" class="form-control" name="cname"  id="cname" required="">
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                    <label >Contact</label>
                    <input type="text" class="form-control" name="cont"  id="cont" required="">
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                   <label >Zone</label>
                   <input type="text" class="form-control" name="zone"  id="zone"required="">
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                   <label >Meter Cube</label>
                   <input type="text" class="form-control" name="mcube"  id="mcube" required="">
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                   <label >Fee</label>
                   <input type="text" class="form-control" name="fee"  id="fee" required="">
                </div>
                </div>
                <div class="col-lg-6">
                <div class="form-group">
                   <label >Registration Date</label>
                   <input type="date" class="form-control" name="date" id="date" required="" >
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


