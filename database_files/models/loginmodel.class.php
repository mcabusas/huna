<?php
    include('dbh.class.php');

    class Loginmodel extends Dbh{


        public function getUsers($user, $pass){

	    	$dbconn = $this->connect();

	    	$selectQuery = "SELECT * FROM `user` as u INNER JOIN tutor as t ON u.user_id = t.user_id WHERE u.username =:username AND u.user_password =:password";

	    	$retSelect = $dbconn->prepare($selectQuery);

	    	if($retSelect->execute(['username'=> $user, 'password'=> $pass])){
                return json_encode($retSelect->fetch());
            }else {
                return 0;
            }
        }

    }

?>