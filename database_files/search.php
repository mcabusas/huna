<?php
    include('connect.php');
    
    $searchValue = mysqli_real_escape_string($conn, $_GET['search']);
    
    $query = "SELECT u.user_firstName, u.user_lastName, t.tutor_id FROM `tutor` AS t INNER JOIN user AS u ON t.user_id = u.user_id WHERE majors LIKE '%{$searchValue}%' OR topics LIKE '%{$searchValue}%' OR languages LIKE '%{$searchValue}%'";
    
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