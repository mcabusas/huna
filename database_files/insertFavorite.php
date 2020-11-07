<?php
    include('connect.php');
    
    
    $id = mysqli_real_escape_string($conn, $_POST['id']);
    $tid = mysqli_real_escape_string($conn, $_POST['tid']);
    
    $query = "INSERT INTO `favorites`(`favorites_id`, `student_id`, `tutor_id`) VALUES (null, '$id', '$tid')";
                
                
    $check = mysqli_query($conn, $query);
    
    $json = array();
    
    if($check){
        $json['message']= 'Tutor was added to your favorites.';
        
    }else{
        $json['message'] = "Error adding tutor to your favorites, please try again.";
    }
    
    
    echo json_encode($json);
    mysqli_close($conn);

?>