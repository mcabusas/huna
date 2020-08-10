<?php
	include('connection.php');


	$username = $_POST['username'];
	$email = $_POST['email'];

	$checkSQL = "SELECT * from  user WHERE user_email = '$email'";

	$check = mysqli_fetch_array(mysqli_query($conn, $checkSQL));

	if(isset($check)){
		echo json_encode('Email already exist.');
	}else{
		$query = "INSERT INTO user (user, user_email) values ('$username, $email')";

		if(mysqli_query($conn, $query)){
			echo json_encode('Registration Successful');
		}else{
			echo 'Try Again';
		}
	}

	mysqli_close($conn);


?>

