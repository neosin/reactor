<?php
require_once 'Reactor/Controller/Action/Admin.php';
class Admin_UsersController extends Reactor_Controller_Action_Admin
{
    public function init(){
        parent::init();
        require_once 'forms/modules/admin/controllers/users/Browse.php';
        require_once 'models/Roles.php';
        require_once 'models/Role.php';
    }

    public function preDispatch(){
        #be sure to disrupt all actions
        if(parent::preDispatch() === false || $this->checkPanelPermission(Reactor_Acl::ACCESS_ADMIN_USERS_PANEL,true) === false){
            $this->_forward('index','index','admin');
            return false;
        }
    }

    public function indexAction(){
        $this->_forward('browse','users','admin');
    }

    public function browseAction(){
        $form = new Modules_Admin_Controllers_Users_Browse_Form();
        $cache = Zend_Registry::get('cache');
        $roles = $cache->load(md5(UNIQUE_HASH.'roles'));
        if($roles === false){
            $rolesTable = new Roles();
            $roles = $rolesTable->fetchAll();
            $cache->save($roles, md5(UNIQUE_HASH.'roles'));
        }
        foreach($roles as $role){
            if($role->id != 1){
                $form->getElement('role')->addMultiOption($role->id,$role->name);
            }
        }
        $router = $this->getFrontController()->getRouter();
        if($page = (int)$this->getRequest()->getParam('page')){
            $router->setGlobalParam('page', $page);
        }
        if($belongs = (int)$this->getRequest()->getParam('belongs')){
            $router->setGlobalParam('belongs', $belongs);
        }
        if($role = $this->getRequest()->getParam('role')){
            $router->setGlobalParam('role', $role);
        }
        if($order = $this->getRequest()->getParam('order')){
            $router->setGlobalParam('order', $order);
        }
        if($sort = $this->getRequest()->getParam('sort')){
            $router->setGlobalParam('sort', $sort);
        }
        $form->getElement('role')->setValue($role);
        $form->getElement('belongs')->setValue($belongs);

        $this->view->form = $form;
        $usersTable = new Users();
        #fetching the data from table
        $select = $usersTable->select()->from(array('u'=>'users'));
        $select->setIntegrityCheck(false);
        $select->where('u.id > ?',1);
        if($role){
            if($belongs){
                $select->join(array('ur'=>'users_roles'),'ur.user=u.id AND ur.role='.(int)$role);
            }
            else{
                $select->joinLeft(array('ur'=>'users_roles'),'ur.user=u.id AND ur.role='.(int)$role);
                $select->where('ur.role is null');
            }
        }
        switch ($sort) {
            case 'desc':
                $sort = 'DESC';
                break;
            default:
                $sort = 'ASC';
        }
        switch ($order) {
            case 'username':
                $select->order('u.email '.$sort);
                break;
            case 'email':
                $select->order('u.email '.$sort);
                break;
            case 'dateOfRegistration':
                $select->order('u.registered_timestamp '.$sort);
                break;
        }
        $this->view->usersPaginator = new Zend_Paginator(new Zend_Paginator_Adapter_DbSelect($select));
        $this->view->usersPaginator->setItemCountPerPage(50);
        $this->view->usersPaginator->setCurrentPageNumber($page);
    }
}
?>