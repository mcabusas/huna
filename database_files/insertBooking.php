<?php
    include('connect.php');
    
    
    $id = mysqli_real_escape_string($conn, $_POST['id']);
    $tid = mysqli_real_escape_string($conn, $_POST['tid']);
    $date = mysqli_real_escape_string($conn, $_POST['date']);
    $timeStart = mysqli_real_escape_string($conn, $_POST['timeStart']);
    $timeEnd = mysqli_real_escape_string($conn, $_POST['timeEnd']);
    $topic = mysqli_real_escape_string($conn, $_POST['topic']);
    $location = mysqli_real_escape_string($conn, $_POST['location']);
    $numberOfStudents = mysqli_real_escape_string($conn, $_POST['numberOfStudents']);
    $locationID = mysqli_real_escape_string($conn, $_POST['locationID']);
    
    $xml = new DOMDocument("1.0");
    $xml->preserveWhiteSpace = false;
    $xml->formatOutput = true;
    
    $q = "select rate from tutor where tutor_id = '$tid'";
    $rate = mysqli_query($conn, $q);
    
    $query = "INSERT INTO `booking`(`booking_id`, `tutor_id`, `student_id`, `booking_status`, `locationID`) VALUES (null, '$tid', '$id', 'Pending', '$locationID')";
                
                
    $check = mysqli_query($conn, $query);
    
    $json = array();
    if($check){
        $json['message']= 'Booking request successful';
        
        $lastid = mysqli_insert_id($conn);
        $json['x'] = $lastid;
        $json['xy'] = $location;
        
        
        $booking = $xml->createElement('booking');
        $xml->appendChild($booking);
        
        $student = $xml->createElement("student", $id);
        $booking->appendChild($student);
        
        $tutor = $xml->createElement("tutor", $tid);
        $booking->appendChild($tutor);
        
        $dateXML = $xml->createElement("date", $date);
        $booking->appendChild($dateXML);
        
        $timeStartXML = $xml->createElement("timestart", $timeStart);
        $booking->appendChild($timeStartXML);
        
        $timeEndXML = $xml->createElement("timeend", $timeEnd);
        $booking->appendChild($timeEndXML);
        
        $topicXML = $xml->createElement("topic", $topic);
        $booking->appendChild($topicXML);
        
        $locationXML = $xml->createElement("location", $location);
        $booking->appendChild($locationXML);
        
        $numOfStudentsXML = $xml->createElement("numberofstudents", $numberOfStudents);
        $booking->appendChild($numOfStudentsXML);
        $xml->save('bookings/'.$lastid.'.xml') or die("error");
        
    }else{
        $json['message'] = "Error requesting a tutoring session, please try again.";
    }
    
    
    echo json_encode($json);
    mysqli_close($conn);

?>