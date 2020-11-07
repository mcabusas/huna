<?php
    
    include ('connect.php');
    
    
    $id = mysqli_real_escape_string($conn, $_GET['id']);
    $page = mysqli_real_escape_string($conn, $_GET['page']);
    //$selectedIndex = mysqli_real_escape_string($conn, $_GET['selectedIndex']);
    
    $json = array();
    
    if($page == 'tutor'){
        $queryTutorRet = "SELECT content from `reviews_tutor` WHERE review_to = '$id'";
        $query = mysqli_query($conn, $queryTutorRet);
        if(mysqli_num_rows($query) > 0){
            while($row = mysqli_fetch_assoc($query)){
                $json[] = $row;
            }
        }else{
            $json['content'] = "You currently have no reviews.";
        }
        /*if(mysqli_num_rows($query) == 0){
            break;
        }else{
            while($row = mysqli_fetch_assoc($query)){
                $json[] = $row;
            }
        }*/
        
        
    }/*else if($page == 'student'){
        
        $queryRet = "SELECT content FROM `feedback` as f INNER JOIN user as u ON f.user_id = u.user_id WHERE  f.user_id= '$id'";
        $query = mysqli_query($conn, $queryRet);
        if(mysqli_num_rows($query) == 0){
            $json['content'] = "You currently have no reviews";
        }else{
            while($row = mysqli_fetch_assoc($query)){
                $json[] = $row;
            }
        }
    }*/
    
    echo json_encode($json);
    
    
    
    
    mysqli_close($conn);

?>