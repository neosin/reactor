<?php
class Reactor_Controller_Action_Admin extends Zend_Controller_Action
{
	static $postDispatchRunOnlyOnce = true;
	/**
	 * checks permissions to admin panel sections
	 * @return unknown_type
	 */
	protected function checkPanelPermission($permissionId = Reactor_Acl::ACCESS_ADMIN_SECTION,$userDeniedMessage = false){
		$user = Zend_Registry::get('Users')->recreateUserSession('admin_session');
		return $user->isAllowed($permissionId,$userDeniedMessage);
	}

	public function preDispatch(){
		Zend_Layout::getMvcInstance()->setLayout('administration');
		if($this->getRequest()->getActionName() != 'log-in' && !$this->checkPanelPermission()){
			$this->_forward('log-in','index','admin');
			return false;
		}
	}

	public function postDispatch(){
		if($this->getRequest()->getActionName() != 'log-in' && $this->checkPanelPermission() && self::$postDispatchRunOnlyOnce){
			#this will populate all zend_layout fragments we may need
			$this->render('top-menu','topMenu',true);
			self::$postDispatchRunOnlyOnce = false;
		}
	}
}
?>