<?php
	
	include('../../models/getBookingsModel.class.php');

    class GetBookingsController extends GetBookingsModel{

    	private $id;
		private $flag;

		public function __construct(){
	        $this->id = isset($_GET['id']) ? $_GET['id'] : null;
	        $this->flag = isset($_GET['flag']) ? $_GET['flag'] : null;
	    }


		public function readBookings(){
			$this->getBookings($this->id, $this->flag);
		}
        
    }

    $gbc = new GetBookingsController();
    $gbc->readBookings();


?>