<?php
    include('connect.php');
    
    $id = mysqli_real_escape_string($conn, $_POST['id']);
    $rating = mysqli_real_escape_string($conn, $_POST['rating']);
    $content = mysqli_real_escape_string($conn, $_POST['content']);
    $dateToday = date('Y-m-d H:i:s');
    
    if($rating != "" && $content != ""){
        
        $query = "INSERT INTO `feedback`(`feedback_id`, `user_id`, `content`, `date`, `rating`) 
        VALUES (null, '$id', '$content', '$dateToday', '$rating')";
        
        $check = mysqli_query($conn, $query);
	    if($check){
	        echo json_encode('Feedback sent, thank you!');
	    }else{
	        echo json_encode('Please try again.');
	                
	    }
        
    }else{
        echo json_encode('please select a rating a input your feebback before pressing save');
    }
    
    
?>