<?php
include  ('dbh.class.php');
class Test extends Dbh{

    public function getTutors(){
        $q = "SELECT * FROM user";
        $stmt =  $this->connect()->query($q);
        $ret = $stmt->fetchAll();
        return $ret;
    }
}


$test = new Test();
$r = $test->getTutors();
echo json_encode($r[2]['username']);