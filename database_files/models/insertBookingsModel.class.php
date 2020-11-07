<?php

	include('dbh.class.php');

	class InsertBookingsModel extends Dbh{


		public function setMessage($id, $tid, $date, $timeStart, $timeEnd, $topic, $location, $numberOfStudents, $locationID){

			$file = null;
			$dbConn = $this->connect();

			$jsonArray = Array(
				'id' => $id,
				'tid' => $tid,
				'date' => $date,
				'timeStart' => $timeStart,
				'timeEnd' => $timeEnd,
				'topic' => $topic,
				'location' => $location,
				'numberOfStudents' => $numberOfStudents,
				'locationID' => $locationID
			);

			echo json_encode($jsonArray);




		}

	}

?>