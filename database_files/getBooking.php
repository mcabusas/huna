<?php
    include('connect.php');
    
    $id = mysqli_real_escape_string($conn, $_GET['id']);
    $page = mysqli_real_escape_string($conn, $_GET['page']);
    
    if($page == 0){
        $query = "SELECT b.booking_id, b.tutor_id, b.student_id, u.username, u.user_firstName, u.user_lastName, t.rate, b.booking_status, b.date, b.pretest_id, p.pretest_status from        booking AS b
                INNER JOIN tutor as t
                on t.tutor_id = b.tutor_id
                INNER JOIN user as u
                on u.user_id = t.user_id
                INNER JOIN pretest as p
                on p.pretest_id = b.pretest_id
                WHERE b.student_id = '$id'
                AND
                p.pretest_status = '1'";
    }else if($page == 1){
        $query = "SELECT b.booking_id, u.username, u.user_firstName, u.user_lastName, t.rate, b.booking_status from        booking AS b
                INNER JOIN user as u
                on u.user_id = b.student_id
                INNER JOIN tutor as t
                on t.tutor_id = b.tutor_id
                WHERE b.tutor_id = '$id'";
    }
    
              
    $ret = mysqli_query($conn, $query);
        
    $json = array();
        
    if(mysqli_num_rows($ret) == 0){
        $json = null;
    }else{
        while($row = mysqli_fetch_assoc($ret)){
            $json[] = $row;
        }
        
        for($count = 0; $count < count($json); $count++){
            
            $xmlFile = file_get_contents('bookings/'.$json[$count]['booking_id'].'.xml');
            $newObj = simplexml_load_string($xmlFile);
                    
            $json[$count]['xmlData'] = $newObj;
            
        }
    }
    
    echo json_encode($json);
    
    mysqli_close($conn);
    
    
    
?>