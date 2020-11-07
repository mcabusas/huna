<?php
    include('dbh.class.php');

    class Dashboardmodel extends Dbh {

        public function getTutors(){
            $content = file_get_contents('../../files/tutors.json');

            return $content;
        }

    }


?>