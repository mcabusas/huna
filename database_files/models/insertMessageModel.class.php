<?php
    include('dbh.class.php');

    class Chatmodel extends Dbh{

        public function setMessage($user1, $user2, $message){

            $jsonArray = Array(
                    'user_from'=> $user1,
                    'user_to'=> $user2,
                    'message'=> $message
                );

            $file = null;

            $dbConn = $this->connect();

            $selectQuery = "SELECT chat_id from chat 
            WHERE user1 =:u1  AND user2 =:u2
            OR
            user1 =:u2 AND user2=:u1
            ";

            $retSelect = $dbConn->prepare($selectQuery);

            $retSelect->execute(['u1'=> $user1, 'u2'=>$user2]);

            $rowCount = $retSelect->fetch();

            if(!$rowCount){
                $insertQuery = "INSERT INTO chat(user1, user2) VALUES(?, ?)";

                $stm = $dbConn->prepare($insertQuery);

                $stm->bindParam(1, $user1);
                $stm->bindParam(2, $user2);
                $stm->execute();
                $file = $dbConn->lastInsertId();
                $jsonObj = json_encode($jsonArray, JSON_PRETTY_PRINT);
                file_put_contents('../../files/chats/' . $file . '.json', $jsonObj);
                
            }else if($rowCount){
                
                $existingFile = file_get_contents('../../files/chats/' . $rowCount['chat_id'] . '.json');
                $tempContent = json_decode($existingFile);
                array_push($tempContent, $jsonArray);
                $jsonObj = json_encode($tempContent, JSON_PRETTY_PRINT);
                file_put_contents('../../files/chats/' . $rowCount['chat_id'] . '.json', $jsonObj);

            }

            $dbConn = null;

    }
}


?>