<?php
    include('connect.php');
    
    
    $selectedIndex = mysqli_real_escape_string($conn, $_POST['selectedIndex']);
    $id = mysqli_real_escape_string($conn,$_POST['id']);
    
    $currentPassword = mysqli_real_escape_string($conn,$_POST['currentPassword']);
    $currentPassword = md5($currentPassword);
    $query = "SELECT user_password from user WHERE user_id = '$id'";
    	
    	
    $oldPass = mysqli_query($conn, $query);
    $row = mysqli_fetch_assoc($oldPass);
    $oldPassword = $row['user_password'];
    $json = array();
    
    if($selectedIndex == 0){
        $settingsValue = mysqli_real_escape_string($conn,$_POST['settingsValue']);
        $email = mysqli_real_escape_string($conn,$_POST['email']);
    	$newPassword = mysqli_real_escape_string($conn,$_POST['password']);
    	$confirmPass = mysqli_real_escape_string($conn,$_POST['confirm']);
    	$homeAddress = mysqli_real_escape_string($conn,$_POST['homeAddress']);
    	$city = mysqli_real_escape_string($conn,$_POST['city']);
    	$country = mysqli_real_escape_string($conn,$_POST['country']);
    	$contactNumber = mysqli_real_escape_string($conn,$_POST['contactNumber']);
    	$zipCode = mysqli_real_escape_string($conn,$_POST['zipCode']);
    	$emergencyFirst = mysqli_real_escape_string($conn,$_POST['emergencyFirst']);
    	$emergencyLast = mysqli_real_escape_string($conn,$_POST['emergencyLast']);
    	$emergencyNumber = mysqli_real_escape_string($conn,$_POST['emergencyNumber']);
    	$emergencyRelation = mysqli_real_escape_string($conn,$_POST['emergencyRelation']);
    	
    	$newPassword = md5($newPassword);
    	$confirmPass = md5($confirmPass);
    	
    	$json['index'] = $selectedIndex;
    	
    	if($currentPassword == $oldPassword){
    	    $json['value'] = 1;
    	    $json['setVal'] = $settingsValue;
    	    
    	    if($settingsValue == 1){
    	        if($newPassword != $confirmPass){
        	       $json['message'] = 'passwords dont match';
        	   }else{ 
        	       if(isset($email)){
        	           $acctQuery = "UPDATE user SET user_password = '$newPassword', user_email = '$email' WHERE user_id = '$id'";
        	           $ret = mysqli_query($conn, $acctQuery);
        	           if(mysqli_affected_rows($conn) > 0){
        	               $json['message'] = 'Your email and password has been updated';
        	           }
        	       }
    	        }
    	        
    	    }else if($settingsValue == 2){
    	        $acctQuery = "UPDATE user SET user_homeAddress = '$homeAddress', user_city = '$city', user_zipCode = '$zipCode', user_country = '$country', user_contactNo = '$contactNumber' WHERE user_id = '$id'";
        	    $ret = mysqli_query($conn, $acctQuery);
        	    if(mysqli_affected_rows($conn) > 0){
        	        $json['message'] = 'Your Personal Data has been updated';
        	    }
    	        
    	    }else if($settingsValue == 3){
    	        $acctQuery = "UPDATE user SET emergency_firstName = '$emergencyFirst', emergency_lastName = '$emergencyLast', emergency_contactNo = '$emergencyNumber', emergency_relation = '$emergencyRelation' WHERE user_id = '$id'";
        	    $ret = mysqli_query($conn, $acctQuery);
        	    if(mysqli_affected_rows($conn) > 0){
        	        $json['message'] = 'Your In Case of Emergency has been updated';
        	    }
    	    }
    	    
    	   
    	   
    	}else{
    	    $json['value'] = 0;
    	}
    }else if($selectedIndex == 1){
        if($currentPassword == $oldPassword){
            $newRate = mysqli_real_escape_string($conn,$_POST['newRate']);
            $tutorID = mysqli_real_escape_string($conn,$_POST['tutorID']);
            $json['newRate'] = $newRate;
            $baseQuery = "UPDATE tutor SET rate = '$newRate' WHERE tutor_id = '$tutorID'";
            mysqli_query($conn, $baseQuery);
            if(mysqli_affected_rows($conn) > 0){
                    $json['value'] = 1;
        	        $json['message'] = 'Your Base Rate has been updated';
        	    }
        }else{
            $json['value'] = 0;
            $json['message'] = 'Your password is incorrect, please try again.';
        }
    }
        
    
	
	echo json_encode($json);
	
	
	mysqli_close($conn);

?>