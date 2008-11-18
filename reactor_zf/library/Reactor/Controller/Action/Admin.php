<?php
class Reactor_Controller_Action_Admin extends Zend_Controller_Action
{
	static $postDispatchRunOnlyOnce = true;

	private function _checkAdminPanelPermission(){
		$user = Zend_Registry::get('Reactor_User')->recreateUserSession('admin_session');
		return $user->isAllowed(Reactor_Acl::ACCESS_ADMIN_SECTION,false);
	}

	public function preDispatch(){
		Zend_Layout::getMvcInstance()->setLayout('administration');
		if($this->getRequest()->getActionName() != 'log-in' && !$this->_checkAdminPanelPermission()){
			$this->_forward('log-in','index','admin');
			return false;
		}
	}

	public function postDispatch(){
		if($this->getRequest()->getActionName() != 'log-in' && $this->_checkAdminPanelPermission() && Reactor_Controller_Action_Admin::$postDispatchRunOnlyOnce){
			#this will populate all zend_layout fragments we may need
			$this->render('top-menu','topMenu',true);
			Reactor_Controller_Action_Admin::$postDispatchRunOnlyOnce = false;
		}
	}
}
?>