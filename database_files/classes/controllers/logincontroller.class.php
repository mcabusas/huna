<?php

	//this feeds to the dashboard model and the dashboardview(flutter)


include('../../models/loginmodel.class.php');

	class Logincontroller extends Loginmodel{

        private $username;

        private $password;

        public function __construct(){
            $this->username = isset($_POST['username']) ? $_POST['username'] : null;
            $this->password = isset($_POST['password']) ? $_POST['password'] : null;

        }

		public function login(){

            $userContent = $this->getUsers($this->username, md5($this->password));

            echo $userContent;
		}
    }
    
    $lc = new Logincontroller();
    $lc->login();

?>