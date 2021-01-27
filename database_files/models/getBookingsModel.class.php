<?php

	include('dbh.class.php');

	class GetBookingsModel extends Dbh {

		public function getBookings($id, $flag){

			$dbConn = $this->connect();
			$json = array();
			
			if($flag == 0){
				$query = "SELECT b.booking_id, b.tutor_id, b.student_id, u.username, u.user_firstName, u.user_lastName, t.rate, b.booking_status, b.bookingDate 
					from booking AS b 
					INNER JOIN tutor as t 
					on t.tutor_id = b.tutor_id 
					INNER JOIN user as u 
					on u.user_id = t.user_id WHERE b.student_id = :id";
			}else if($flag == 1){
				$query = "SELECT b.booking_id, u.username, u.user_firstName, u.user_lastName, t.rate, b.booking_status from booking AS b
                INNER JOIN user as u
                on u.user_id = b.student_id
                INNER JOIN tutor as t
                on t.tutor_id = b.tutor_id
                WHERE b.tutor_id = :id";
			}


				$querySelect = $dbConn->prepare($query);
				$querySelect->execute(['id'=> $id]);

				if($querySelect->rowCount() == 0){
					
					$json =  null;

				}else{
					
					//$json = $querySelect->fetch();

					while($row = $querySelect->fetch()){
						$json[] = $row;
					}

					for($count = 0; $count < count($json); $count++){

						$xmlFile = file_get_contents('../../files/bookings/' . $json[$count]['booking_id'] . '.xml');
						$jsonObj = simplexml_load_string($xmlFile);

						$json[$count]['xmlData'] = $jsonObj;

					}

				}

				echo json_encode($json);

		}

	}

?>