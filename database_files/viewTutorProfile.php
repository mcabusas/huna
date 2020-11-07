<?php
    include('connect.php');
    
    $id = mysqli_real_escape_string($conn, $_GET['id']);
    
    $query = "SELECT majors, languages, topics FROM `tutor` AS t INNER JOIN user AS u ON t.user_id = u.user_id WHERE t.tutor_id = '$id'";
    
    $ret = mysqli_query($conn, $query);
    $json = array();
    if(mysqli_num_rows($ret) == 0){
        $json['message'] = "ERROR";
    }else{
        while($row = mysqli_fetch_assoc($ret)){
            $json[] = $row;
        }
    }
    
    echo json_encode($json);
    
    mysqli_close($conn);
?>