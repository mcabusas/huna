<?php
	
	include('../../models/setBookingStatusModel.class.php');

	class AcceptBookingController extends AcceptBookingModel {

		private $bookingID;
		private $flag;
		private $statusFlag;

		public function __construct(){
            $this->bookingID = isset($_POST['booking_id']) ? $_POST['booking_id'] : null;
            $this->flag = isset($_POST['flag']) ? $_POST['flag'] : null;
            $this->statusFlag = isset($_POST['statusFlag']) ? $_POST['statusFlag'] : null;
        }

        public function setStatus(){
        	$this->updateStatus($this->bookingID, $this->flag, $this->statusFlag);
        }
	}

	$acb = new AcceptBookingController();

	$acb->setStatus();

?>