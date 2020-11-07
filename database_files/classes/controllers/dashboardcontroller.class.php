<?php

	//this feeds to the dashboard model and the dashboardview(flutter)


include('../../models/dashboardmodel.class.php');

	class Dashboardcontroller extends Dashboardmodel{

		public function showTutors(){
			$result = $this->getTutors();
			echo ($result);
		}
	}


	$view = new Dashboardcontroller();
	$view->showTutors();

?>