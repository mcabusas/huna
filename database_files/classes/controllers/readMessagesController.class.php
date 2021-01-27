<?php
	
	include('../../models/readMessagesModel.class.php');

	class ReadMessagesController extends ReadMessagesModel {

		private $chatRoom;

        public function __construct(){
            $this->chatRoom = isset($_GET['chatRoom']) ? $_GET['chatRoom'] : null;
        }

        public function readMessages(){

        	echo ($this->getMessages($this->chatRoom));


        }
	}

	$rmc = new ReadMessagesController();
	$rmc->readMessages();

?>