<?php
    include('connect.php');
    
    $id = mysqli_real_escape_string($conn, $_GET['id']);
    $page = mysqli_real_escape_string($conn, $_GET['page']);
    
    if($page == 0){
        $query = "SELECT u.user_id, u.username, u.user_firstName, u.user_lastName, t.tutor_id, t.rate 
                FROM chat as c 
                INNER JOIN user as u 
                ON c.user2 = u.user_id 
                INNER JOIN tutor as t 
                ON t.user_id = c.user2
                WHERE c.user1 = '$id'";
    }else if($page == 1){
        $query = "SELECT u.user_id, u.username, u.user_firstName, u.user_lastName, t.tutor_id, t.rate 
            FROM chat as c 
            INNER JOIN user as u 
            ON c.user1 = u.user_id 
            INNER JOIN tutor as t 
            ON t.user_id = c.user1 
            WHERE c.user2 = '$id'";
    }
    
              
    $ret = mysqli_query($conn, $query);
        
    $json = array();
        
    if(mysqli_num_rows($ret) == 0){
        $json = null;
    }else{
        while($row = mysqli_fetch_assoc($ret)){
            $json[] = $row;
        }
    }
    
    echo json_encode($json);
    
    mysqli_close($conn);
    
    
    
?>