<?php
class Reactor_Controller_Action_Admin extends Zend_Controller_Action
{
    public function init(){
    }

    public function preDispatch(){
        $user = $users->recreateUserSession();
        if($this->getRequest()->getActionName() != 'log-in' && !$user->isAllowed('adminPanel',null,false)){
            $this->_forward('log-in','index','admin');
            return true;
        }
    }
    public function postDispatch(){
        $user = new Reactor_User('admin_session');
        if(!self::$runOnlyOnce){
            Zend_Layout::getMvcInstance()->setLayout('administration');
            if($user->isAllowed('adminPanel',null,false)){
                $this->getResponse()->insert('leftMenu',$this->view->render('left-menu.phtml'));
            }
        }
        self::$runOnlyOnce = true;
    }
}
?>