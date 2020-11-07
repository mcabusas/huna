<?php
	include('../../models/getChatsModel.class.php');

	class GetChatsController extends GetChatsModel {

		private $id;
		private $flag;

		public function __construct(){
	        $this->id = isset($_GET['id']) ? $_GET['id'] : null;
	        $this->flag = isset($_GET['flag']) ? $_GET['flag'] : null;
	    }


		public function readChats(){
			$this->getChats($this->id, $this->flag);
		}
			
	}

$getChatsController = new GetChatsController();
$getChatsController->readChats();
	

?>