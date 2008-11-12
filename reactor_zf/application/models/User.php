<?php
class User extends Zend_Db_Table_Row{
    public function clear($sessionName = 'userSessionName'){
        $auth = Zend_Auth::getInstance();
        $auth->setStorage(new Zend_Auth_Storage_Session($sessionName));
        $auth->clearIdentity();
        $this->setFromArray($this->getTable()->createRow()->toArray());
    }
    
    public function findUsersRoles(){
        if($this->id == null){
            return array();
        }
        parent::findUsersRoles();
    }
    
    public function isAllowed(){
        #stub
    }
}
?>