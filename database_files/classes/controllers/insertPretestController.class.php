<?php
	
	include('../../models/insertPretestModel.class.php');

	class InsertPretestController extends InsertPretestModel {
		private $pretestObj;

        public function __construct(){
            $this->pretestObj = isset($_GET['questions']) ? $_GET['questions'] : null;
        }

        public function setPretest(){
        	$this->createPretest($this->pretestObj);
        }
	}

	$ipc = new InsertPretestController();
	$ipc->setPretest();
?>