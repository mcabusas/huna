<?php
	include('dbh.class.php');


	class ReadMessagesModel extends Dbh {

		public function getMessages($chatRoom){

			$content = file_get_contents('../../files/chats/' . $chatRoom . '.xml');

			$newObj = simplexml_load_string($content);

			echo json_encode($newObj);
		}


	}


?>