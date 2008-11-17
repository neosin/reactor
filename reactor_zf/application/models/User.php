<?php
class User extends Zend_Db_Table_Row{
    public function clear($sessionName = 'userSessionName'){
        $auth = Zend_Auth::getInstance();
        $auth->setStorage(new Zend_Auth_Storage_Session($sessionName));
        $auth->clearIdentity();
        $this->setFromArray($this->getTable()->createRow()->toArray());
    }
    
    public function findUsersRoles(){
        #TODO add caching later
        return parent::findUsersRoles();
    }
    
    public function isAllowed($permissionName, $defaultDeniedMessage = true){
        return Reactor_Acl::isAllowed($this->findUsersRoles(),Reactor_Acl::ACCESS_ADMIN_SECTION,null,false);
    }
}
?>