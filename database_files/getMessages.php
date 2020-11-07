<?php
    
    include('connect.php');
    
    $id = mysqli_real_escape_string($conn, $_GET['id']);
    $tid = mysqli_real_escape_string($conn, $_GET['toId']);

    $query = "SELECT chat_id FROM `chat` WHERE (user1 = '$id' and user2 = '$tid') OR (user1 = '$tid' AND user2 = '$id')";

    $json = array();
    
    $ret = mysqli_query($conn, $query);
    
    if(mysqli_num_rows($ret) != 0){
        $row = mysqli_fetch_assoc($ret);
        $lastid = $row['chat_id'];
        
        $xmlFile = file_get_contents('chats/'.$lastid.'.xml');
        $newObj = simplexml_load_string($xmlFile);
        
        $jsonObject = json_encode($newObj);
        print_r($jsonObject);
        /*$xml = new DOMDocument();
        $xml->load('chats/'.$lastid.'.xml');
        
        $xmlElement = $xml->documentElement;
        foreach ($xmlElement->childNodes as $children){
            
            echo json_encode($children->nodeName. '='. $children->nodeValue);
        }*/
        
        
    }else if(mysqli_num_rows($ret) == 0){
        echo json_encode(null);
    }
    
    mysqli_close($conn);
?>