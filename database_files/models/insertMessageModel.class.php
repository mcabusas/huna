<?php
    include('dbh.class.php');

    class Chatmodel extends Dbh{

        public function setMessage($user1, $user2, $messageContent){

            $xml = new DOMDocument("1.0");
            $xml->preserveWhiteSpace = false;
            $xml->formatOutput = true;

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


                $messages = $xml->createElement('messages');

                $message = $xml->createElement('message');
                $messages->appendChild($message);


                $userFromXML = $xml->createElement('userFrom', $user1);
                $message->appendChild($userFromXML);

                $userToXML = $xml->createElement('userTo', $user2);
                $message->appendChild($userToXML);

                $contentXML = $xml->createElement('content', $messageContent);
                $message->appendChild($contentXML);


                $xml->appendChild($messages);
                
            }else if($rowCount){

                $file = $rowCount['chat_id'];
                $xml->load('../../files/chats/' . $file . '.xml');

                $root = $xml->getElementsByTagName('messages')->item(0);

                $message = $xml->createElement('message');


                $root->appendChild($message);

                $userFromXML = $xml->createElement('userFrom', $user1);
                $message->appendChild($userFromXML);

                $userToXML = $xml->createElement('userTo', $user2);
                $message->appendChild($userToXML);

                $content = $xml->createElement('content', $messageContent);
                $message->appendChild($content);

                $root->appendChild($message);
            }

            $xml->save('../../files/chats/' . $file . '.xml') or die('error');

            $dbConn = null;

    }
}


?>