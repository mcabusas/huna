<?php
	
	include('dbh.class.php');

	class InsertPretestModel extends Dbh {

		public function createPretest($questions){

			$dbConn = $this->connect();

			$xml = new DOMDocument('1.0');
			$xml->preserveWhiteSpace = false;
			$xml->formatOutput = true;

			$file = null;
			$status = 0;

			

			// $json = json_encode(array('index'=>$questions));

			// $decode = json_decode($json);

			// echo $json;

			// $json = file_get_contents("http://192.168.1.8/api/menu.php?restaurant_id=" . $_GET['restaurant_id'] . "&hotel_id=" . $_GET['hotel_id']);

			$json = file_get_contents('http://192.168.0.33/huna/database_files/classes/controllers/insertPretestController.class.php?questions=' . $questions);
			$json_data = json_decode($json, true);	
			$test = $json_data['index']['question1'];
			echo json_encode(array('index'=>$test));

			// 	foreach($json_data as $key => $value){

			// 		$question = $json_data[$key]['question1'];


			// 		// $restomenu_id =  $json_data[$key]["restomenu_ID"];
			// 		// $hotel_id =  $json_data[$key]["hotel_ID"];
			// 		// $dishstyle_id =  $json_data[$key]["dishstyle_ID"];
			// 		// $category_id =  $json_data[$key]["category_ID"];
			// 		// $restaurant_id =  $json_data[$key]["restaurant_ID"];
			// 	}
			// 	echo json_encode($question);

			// [
			// 	0 = {
			// 		'question':'1',
			// 		'option1':'1',
			// 		'option2':'1',
			// 		'correctRadio':'2'
			// 	},
			// 	1 = {
			// 		'question':'2',
			// 		'option1':'1',
			// 		'option2':'1',
			// 		'correctRadio':'2'
			// 	}
			// ]

			

			// $query = 'INSERT INTO pretest(pretest_status) 
			// 			VALUES (:status)';

			// $stm = $dbConn->prepare($query);

			// $stm->bindParam(':status', $status);

			// $checker = $stm->execute();

			// if($checker){
			// 	$fileName = $dbConn->lastInsertId();

			// 	$questions = $xml->createElement('questions');

			// 	$
			








			// }else{
			// 	echo 'error';
			// }
			
		}
	}

?>