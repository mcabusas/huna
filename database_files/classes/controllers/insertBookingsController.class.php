<?php
	
	include('../../models/insertBookingsModel.class.php');

	class InsertBookingsController extends InsertBookingsModel{

		private $id;
		private $tid;
		private $date;
		private $timeStart;
		private $timeEnd;
		private $topic;
		private $location;
		private $numberOfStudents;
		private $locationID;

		 public function __construct(){
            $this->id = isset($_POST['id']) ? $_POST['id'] : null;
            $this->tid = isset($_POST['tid']) ? $_POST['tid'] : null;
            $this->date = isset($_POST['date']) ? $_POST['date'] : null;
            $this->timeStart = isset($_POST['timeStart']) ? $_POST['timeStart'] : null;
            $this->timeEnd = isset($_POST['timeEnd']) ? $_POST['timeEnd'] : null;
            $this->topic = isset($_POST['topic']) ? $_POST['topic'] : null;
            $this->numberOfStudents = isset($_POST['numberOfStudents']) ? $_POST['numberOfStudents'] : null;
            $this->location = isset($_POST['location']) ? $_POST['location'] : null;
            $this->locationID = isset($_POST['locationID']) ? $_POST['locationID'] : null;
        }

        public function insertBooking(){
        	$this->setBooking($this->id, $this->tid, $this->date, $this->timeStart, $this->timeEnd, $this->topic, $this->location, $this->numberOfStudents, $this->locationID);
        }


	}

	$ibc = new InsertBookingsController();
	$ibc->insertBooking();


	

?>