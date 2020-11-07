<?php
    include('connect.php');
    
    $id = mysqli_real_escape_string($conn, $_GET['id']);
    
    $query = "SELECT u.user_firstName, u.user_lastName, u.username, t.tutor_id 
        FROM `favorites` as f 
        INNER JOIN tutor as t 
        ON f.tutor_id = t.tutor_id 
        INNER JOIN user as u 
        ON u.user_id = t.user_id 
        WHERE f.student_id = '$id'";
        
    $check = mysqli_query($conn, $query);
    $json = array();
    
    if(mysqli_num_rows($check) == 0){
        $json = "false";
    }else{
        while($row = mysqli_fetch_assoc($check)){
            $json[] = $row;
        }
    }
    
    echo json_encode($json);
    
    mysqli_close($conn);
    

?>