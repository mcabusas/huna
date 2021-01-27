<?php
	
	include('dbh.class.php');

	class AcceptBookingModel extends Dbh {

		public function updateStatus($bookingId, $flag, $statusFlag){

			$dbConn = $this->connect();

				if($statusFlag == 1){
					$status = 'Accepted';
				}else if($statusFlag ==  0){
					$status = 'Declined';
				}

				$query = "UPDATE booking
					SET booking_status = :booking_status
					WHERE booking_id = :bookingId
					";

				$stm = $dbConn->prepare($query);

				$stm->bindParam(':booking_status', $status);
				$stm->bindParam(':bookingId', $bookingId);

				$checker = $stm->execute();

				if($checker){
					echo json_encode(1);
				}else{
					echo json_encode(0);
				}



			
		}
	}

?>