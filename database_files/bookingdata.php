<?php
    include('connect.php');
    
    $tid = mysqli_real_escape_string($conn, $_GET['tid']);
    
    $query = "SELECT * from user as u inner join tutor as t on u.user_id = t.user_id WHERE t.tutor_id = '$tid'";
    $check = mysqli_query($conn, $query);
    $json = array();
    
    if(mysqli_num_rows($check) == 0){
        $json['message'] = "there are no tutors";
    }else{
        while($row = mysqli_fetch_assoc($check)){
            $json[] = $row;
        }
    }
    
    echo json_encode($json);
    
    mysqli_close($conn);
    

?>