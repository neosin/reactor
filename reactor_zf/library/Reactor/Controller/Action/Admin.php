<?php
class Reactor_Controller_Action_Admin extends Zend_Controller_Action
{
    public function preDispatch(){
        $users = new Users();
        $user = $users->recreateUserSession();
        if($this->getRequest()->getActionName() != 'log-in' && !$user->isAllowed(Reactor_Acl::ACCESS_ADMIN_SECTION,null,false)){
            $this->_forward('log-in','index','admin');
            return true;
        }
    }
}
?>