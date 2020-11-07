<?php
    include('connect.php');
    
    $id = mysqli_real_escape_string($conn, $_GET['id']);
    $page = mysqli_real_escape_string($conn, $_GET['pageTutor']);
    $json = array();
    
    if($page == 1){
        $json['pageTutor'] = $page;
        $queryRet = "SELECT * from tutor WHERE tutor_id = '$id'";
    
        $query = mysqli_query($conn, $queryRet);
        if(mysqli_num_rows($query) == 0){
            $json['ERROR'] = "ERROR";
        }else{
            while($row = mysqli_fetch_assoc($query)){
                $json[] = $row;
            }
        }
    }else if($page == 2){
        $majors = mysqli_real_escape_string($conn, $_POST['majors']);
        $languages = mysqli_real_escape_string($conn, $_POST['lang']);
        $topics = mysqli_real_escape_string($conn, $_POST['topics']);
        
        
        if($majors == '[]' && $languages == '[]'){
            $query = "UPDATE `tutor` set topics = '$topics' WHERE tutor_id = '$id'";
            mysqli_query($conn, $query);
            
        }else if($majors == '[]' && $topics == '[]'){
            $query = "UPDATE `tutor` set languages = '$languages' WHERE tutor_id = '$id'";
        mysqli_query($conn, $query);
        }else if($languages == '[]' && $topics == '[]'){
            $query = "UPDATE `tutor` set majors = '$majors' WHERE tutor_id = '$id'";
            mysqli_query($conn, $query);
        }else if($majors == '[]'){
            $query = "UPDATE `tutor` set languages = '$languages', topics = '$topics' WHERE tutor_id = '$id'";
            mysqli_query($conn, $query);
        }else if($topics == '[]'){
            $query = "UPDATE `tutor` set majors = '$majors', languages = '$languages' WHERE tutor_id = '$id'";
            mysqli_query($conn, $query);
        }else if($languages == '[]'){
            $query = "UPDATE `tutor` set majors = '$majors', topics = '$topics' WHERE tutor_id = '$id'";
            mysqli_query($conn, $query);
        }else if($majors != '[]' && $languages != '[]' && $topics != '[]'){
            $query = "UPDATE `tutor`set majors = '$majors', languages = '$languages', topics = '$topics' WHERE tutor_id = '$id'";
            mysqli_query($conn, $query);
        }
        
        
        if(mysqli_affected_rows($conn) > 0){
            
        	$json['message'] = 'Your PROFILE SETTINGS has been updated';
        }
    }
    
    echo json_encode($json);
    
    
    mysqli_close($conn);
        
        
?>