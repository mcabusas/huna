<?php
    //include('../../dbh.class.php');

    class Loginmodel {

        public function getUsers(){
            $content = file_get_contents('../../files/users.json');

            return $content;
        }

    }


?>