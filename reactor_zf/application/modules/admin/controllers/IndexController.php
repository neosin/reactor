<?php
require_once 'Reactor/Controller/Action/Admin.php';
class Admin_IndexController extends Reactor_Controller_Action_Admin
{

    public function init(){
        parent::init();
    }

    public function preDispatch(){
        #be sure to disrupt all actions
        if(parent::preDispatch() === false){
            return false;
        }
    }

    public function indexAction(){
        Zend_Layout::getMvcInstance()->enableLayout();
        $this->render('index','default');
    }

    public function logInAction(){
        $users = Zend_Registry::get('Reactor_User');
        $user = $users->recreateUserSession('admin_session');
        //we dont need/want default admin layout here lets just render view for login screen
        Zend_Layout::getMvcInstance()->disableLayout();
        $signInForm = new Reactor_Form_LogIn();
        $this->view->signInForm = $signInForm;
        if($formValues = $this->getRequest()->getPost()){
            if($signInForm->isValid($formValues)){
                $user = $users->authUser(
                $signInForm->getValue('username'),
                md5($signInForm->getValue('password')),
            'admin_session');
                if($user->id > 0){
                }
            }
            $_POST = null;
            $this->getHelper('Messages')->operations = Zend_Registry::get('Zend_Translate')->_('o_signed_in');
            $this->_forward('index','index','admin');
        }
    }

    public function logOutAction(){
        $user = Zend_Registry::get('Reactor_User')->recreateUserSession('admin_session');
        $user->clear('admin_session');
        $this->_forward('index','index','admin');
    }
}
?>