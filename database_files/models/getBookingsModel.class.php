<?php

	include('dbh.class.php');

	class GetBookingsModel extends Dbh {

		public function getBookings($id, $flag){
			echo $id;

			echo 'inside model';

		}

	}

?>