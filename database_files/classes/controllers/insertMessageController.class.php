<?php

	//this feeds to the insertMessage model and the insertMessageview(flutter)


include('../../models/insertMessageModel.class.php');

	class Chatcontroller extends Chatmodel{

        private $user1;
        private $user2;
        private $message;

        public function __construct(){
            $this->user1 = isset($_POST['id_from']) ? $_POST['id_from'] : null;
            $this->user2 = isset($_POST['userid_to']) ? $_POST['userid_to'] : null;
            $this->message = isset($_POST['message']) ? $_POST['message'] : null;

        }

		public function insertMessage(){
            $this->setMessage($this->user1, $this->user2, $this->message);
		}
    }
    
    $lc = new Chatcontroller();
    $lc->insertMessage();

?>