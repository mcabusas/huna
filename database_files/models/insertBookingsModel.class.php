<?php

	include('dbh.class.php');

	class InsertBookingsModel extends Dbh{


		public function setBooking($id, $tid, $date, $timeStart, $timeEnd, $topic, $location, $numberOfStudents, $locationID){


			$xml = new DOMDocument("1.0");
            $xml->preserveWhiteSpace = false;
            $xml->formatOutput = true;

            $status = 'Pending';

			$dbConn = $this->connect();

			$insertQuery = "INSERT INTO booking (tutor_id, student_id, booking_status, locationID, bookingDate, timeStart, timeEnd) VALUES(:tid, :sid, :status, :locationID, :bookingDate, :timeStart ,:timeEnd)";

			
			$stm = $dbConn->prepare($insertQuery);

			$stm->bindParam(':tid', $tid);
			$stm->bindParam(':sid', $id);
			$stm->bindParam(':status', $status);
			$stm->bindParam(':locationID', $locationID);
			$stm->bindParam(':bookingDate', $date);
			$stm->bindParam(':timeStart', $timeStart);
			$stm->bindParam(':timeEnd', $timeEnd);

			$checker = $stm->execute();

			if($checker){
				$fileName = $dbConn->lastInsertId();

				$booking = $xml->createElement('bookings');

				$tutorIdXML = $xml->createElement('tutorID', $tid);
				$booking->appendChild($tutorIdXML);

				$studentIdXML = $xml->createElement('studentID', $id);
				$booking->appendChild($studentIdXML);

				$locationXML = $xml->createElement('location', $location);
				$booking->appendChild($locationXML);

				$bookingDate = $xml->createElement('date', $date);
				$booking->appendChild($bookingDate);

				$timeStartXML = $xml->createElement('timeStart', $timeStart);
				$booking->appendChild($timeStartXML);

				$timeEndXML = $xml->createElement('timeEnd', $timeEnd);
				$booking->appendChild($timeEndXML);

				$numberOfStudentsXML = $xml->createElement('numberOfStudents', $numberOfStudents);
				$booking->appendChild($numberOfStudentsXML);

				$xml->appendChild($booking);

				$xml->save('../../files/bookings/' . $fileName . '.xml') or die('error');

				echo json_encode('success');
			}else{
				echo json_encode('not successful');
			}

            $dbConn = null;






		}

	}

?>