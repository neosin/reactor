<?php
require_once 'Reactor/Controller/Action/Admin.php';
class Admin_IndexController extends Reactor_Controller_Action_Admin
{

	public function init(){
		parent::init();
	}

	public function preDispatch(){
		#be sure to disrupt all actions
		$result = parent::preDispatch();
		if($result){
			return true;
		}
	}

	public function indexAction(){

	}

	public function logInAction(){
	}
	public function logOutAction(){
	}
}
?>