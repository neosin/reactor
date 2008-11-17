<?php
class Reactor_Controller_Action_Admin extends Zend_Controller_Action
{
    public function preDispatch(){
        $user = Zend_Registry::get('Reactor_User')->recreateUserSession('admin_session');
        if($this->getRequest()->getActionName() != 'log-in' && !$user->isAllowed(Reactor_Acl::ACCESS_ADMIN_SECTION,false)){
            $this->_forward('log-in','index','admin');
            return false;
        }
    }
}
?>