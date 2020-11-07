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

            $userContent = $this->getUsers();
            $assocContent = json_decode($userContent);

            foreach($assocContent as $user){
                if($user->username == $this->username and $user->user_password == md5($this->password)){
                    $viewData =  json_encode($user);
                }else {
                    $viewData = "ERROR";
                }
            }
			echo $viewData;
		}
    }
    
    $lc = new Logincontroller();
    $lc->login();

?>