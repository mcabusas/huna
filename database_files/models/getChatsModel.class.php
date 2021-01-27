<?php
	include('dbh.class.php');

	class GetChatsModel extends Dbh{

		public function getChats($id, $flag){
			$dbConn = $this->connect();

			if($flag == 0){

	            $selectQuery = "SELECT c.chat_id, u.user_id, u.username, u.user_firstName, u.user_lastName, t.tutor_id, t.rate
	            FROM chat AS c
	            INNER JOIN user as u
	            on c.user2 = u.user_id
	            INNER JOIN tutor as t
	            ON t.user_id - c.user2
	            WHERE c.user1 =:id
	            ";
	            
			}else if($flag == 1){

				$selectQuery = "SELECT c.chat_id, u.user_id, u.username, u.user_firstName, u.user_lastName, t.tutor_id, t.rate 
	            FROM chat as c 
	            INNER JOIN user as u 
	            ON c.user1 = u.user_id 
	            INNER JOIN tutor as t 
	            ON t.user_id = c.user1 
	            WHERE c.user2 =:id
	            ";
			}

			$retSelect = $dbConn->prepare($selectQuery);

	        $retSelect->execute(['id' => $id]);

	        $retVal = $retSelect->fetchAll();

	        if(count($retVal) > 0){

	        	echo json_encode($retVal);

	        }else {
	        	echo json_encode(null);
	        }

	        //print_r($retVal);
		}

	}

		
	
	

?>