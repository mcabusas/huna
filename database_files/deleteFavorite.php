<?php
    include('connect.php');
    
    
    $id = mysqli_real_escape_string($conn, $_POST['id']);
    $tid = mysqli_real_escape_string($conn, $_POST['tid']);
    
    $query = "DELETE FROM `favorites`
            WHERE student_id = '$id' AND tutor_id = '$tid'
    ";
                
                
    $check = mysqli_query($conn, $query);
    
    $json = array();
    
    if($check){
        $json['message']= 'Tutor was deleted from your favorites.';
        
    }else{
        $json['message'] = "Error deleting tutor from your favorites, please try again.";
    }
    
    
    echo json_encode($json);
    mysqli_close($conn);

?>