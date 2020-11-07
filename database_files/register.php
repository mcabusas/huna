<?php
	include('connect.php');


	$username = mysqli_real_escape_string($conn, $_POST['username']);
	$email = mysqli_real_escape_string($conn,$_POST['email']);
	$password = mysqli_real_escape_string($conn,$_POST['password']);
	$confirmPass = mysqli_real_escape_string($conn,$_POST['confirm']);
	$firstName = mysqli_real_escape_string($conn,$_POST['firstName']);
	$lastName = mysqli_real_escape_string($conn,$_POST['lastName']);
	$homeAddress = mysqli_real_escape_string($conn,$_POST['homeAddress']);
	$city = mysqli_real_escape_string($conn,$_POST['city']);
	$country = mysqli_real_escape_string($conn,$_POST['country']);
	$contactNumber = mysqli_real_escape_string($conn,$_POST['contactNumber']);
	$zipCode = mysqli_real_escape_string($conn,$_POST['zipCode']);
	$emergencyFirst = mysqli_real_escape_string($conn,$_POST['emergencyFirst']);
	$emergencyLast = mysqli_real_escape_string($conn,$_POST['emergencyLast']);
	$emergencyNumber = mysqli_real_escape_string($conn,$_POST['emergencyNumber']);
	$emergencyRelation = mysqli_real_escape_string($conn,$_POST['emergencyRelation']);
	$date = mysqli_real_escape_string($conn,$_POST['date']);
	$dateToday = date('Y-m-d H:i:s');
	
	
	
	$checkSQL = "SELECT * from  user WHERE user_email = '$email'";
	

	$check = mysqli_query($conn, $checkSQL);
	
	

	if(mysqli_num_rows($check) > 0){
		echo json_encode('Email already exist.');
	}else{
	    
	    if($password!=$confirmPass){
	        echo json_encode('passwords dont match.');
	    }else{
	        $password = md5($password);
	        
	        
	        $query = "
	        INSERT INTO `user`(`user_id`, `user_type`, `username`, `user_password`, `user_email`, `user_firstName`, `user_lastName`, `dateCreate`, `user_DOB`, `user_homeAddress`, `user_city`, `user_country`, `user_zipCode`, `user_contactNo`, `user_photo`, `account_type`, `emergency_firstName`, `emergency_lastName`, `emergency_contactNo`, `emergency_relation`) VALUES (null, 'Student', '$username', '$password', '$email', '$firstName', '$lastName', now() , '$date', '$homeAddress', '$city', '$country', '$zipCode', '$contactNumber', 'null', 'Active', '$emergencyFirst', '$emergencyLast','$emergencyNumber', '$emergencyRelation')";
	            
	            $check = mysqli_query($conn, $query);
	            if($check){
	                echo json_encode('Successful Registration.');
	                echo json_encode($date);
	            }else{
	                echo json_encode('Please try again.');
	                echo $dateToday;
	            }
	    }
	    
	}
	
	

	mysqli_close($conn);


?>

