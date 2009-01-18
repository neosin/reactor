<?php
require_once 'Reactor/Controller/Action/Admin.php';
class Admin_ObjectsController extends Reactor_Controller_Action_Admin
{
	public function init(){
		parent::init();
		require_once 'models/Objects.php';
		require_once 'models/Object.php';
	}

	public function preDispatch(){
		#be sure to disrupt all actions
		if(parent::preDispatch() === false || $this->checkPanelPermission(Reactor_Acl::ACCESS_ADMIN_USERS_PANEL,true) === false){
			$this->_forward('index','index','admin');
			return false;
		}
	}

	public function indexAction(){
		 $objectsTable = new Objects();
		 #$objectsTable->createRowAsFirstChild(3,array('title'=>'nowy'));
		 #$objectsTable->createRowAfterNode(5,array('title'=>'nowy test'));
		 #$objectsTable->find(19)->current()->delete();
		 $this->view->tree = $objectsTable->fetchFullTree(); 
	}
}
?>