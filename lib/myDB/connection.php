<?php

    $dns = $dns = 'mysql:host=localhost;dbname=id12659108_huna';
    $user = 'id12659108_huna';
    $password = 'huna1234';

    try{
        $connection = new PDO($dns, $user, $password);
        echo "connected";
    }catch(PDOException $e){
        echo $e->getMessage();
        die('could not connect');

    }

?>
