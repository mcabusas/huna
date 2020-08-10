<?php
	include 'connection.php';
	
	$user = $_POST['username'];
	$password = $_POST['password'];

	$queryRet = $connection->query("SELECT * FROM  user WHERE username = '".$user."'and user_password = '".$password."'");

	$ret = array();

	while($fetchData = $queryRet->fetch()){
		$ret[] = $fetchData;
	}

	//echo json_encode($ret);

?>

<?php
	include 'connection.php';

	$json = file_get_contents('php://input');

	$obj = json_decode($json,true);

	$email = $obj['email'];
 	$password = $obj['password'];

 	$queryRet = ("SELECT * FROM  user WHERE username = '".$user."'and user_password = '".$password."'");

 	$check = mysqli_fetch_array(mysqli_query($connection,$queryRet));
 	if(isset($check)){
		
		 // Successfully Login Message.
		 $onLoginSuccess = 'Login Matched';
		 
		 // Converting the message into JSON format.
		 $SuccessMSG = json_encode($onLoginSuccess);
		 
		 // Echo the message.
		 echo $SuccessMSG ; 
	 
	 }
	 
	 else{
	 
		 // If Email and Password did not Matched.
		$InvalidMSG = 'Invalid Username or Password Please Try Again' ;
		 
		// Converting the message into JSON format.
		$InvalidMSGJSon = json_encode($InvalidMSG);
		 
		// Echo the message.
		 echo $InvalidMSGJSon ;
	 
	 }


?>


