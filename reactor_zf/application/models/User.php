<?php
class User extends Zend_Db_Table_Row{
    public function clear($sessionName = 'userSessionName'){
        $auth = Zend_Auth::getInstance();
        $auth->setStorage(new Zend_Auth_Storage_Session($sessionName));
        $auth->clearIdentity();
        $this->getTable()->recreateUserSession($sessionName);
    }

    public function findUsersRoles(){
        #TODO add caching later
        $cache = Zend_Registry::get('cache_files');
        $usersRoles = $cache->load(md5(UNIQUE_HASH.'users_roles_'.$this->id));
        if($usersRoles === false) {
            $usersRoles = parent::findUsersRoles();
            $cache->save($usersRoles, md5(UNIQUE_HASH.'users_roles_'.$this->id), array('users_roles','user_data'));
        }
        return $usersRoles;
    }

    public function isAllowed($permissionName, $defaultDeniedMessage = true){
        return Reactor_Acl::isAllowed($this->findUsersRoles(),Reactor_Acl::ACCESS_ADMIN_SECTION,null,false);
    }
}
?>