<?php
class User extends Zend_Db_Table_Row{
    
    /**
     * clears the user session and signs him out
     * @param $sessionName (string)session identifier
     * @return User
     */
    public function clear($sessionName = 'userSessionName'){
        $auth = Zend_Auth::getInstance();
        $auth->setStorage(new Zend_Auth_Storage_Session($sessionName));
        $auth->clearIdentity();
        $this->getTable()->recreateUserSession($sessionName);
    }
    
    /**
     * fetches roles that user belongs to
     * @return Zend_Db_Rowset
     */
    public function findUsersRoles(){
        #TODO add caching later
        $cache = Zend_Registry::get('cache_files');
        $usersRoles = $cache->load(md5(UNIQUE_HASH.'users_roles_'.$this->id));
        if($usersRoles === false) {
            $select = $this->getTable()->select()
            ->setIntegrityCheck(false)
            ->from(array('ur'=>'users_roles'),array())
            ->join(array('r'=>'roles'),'r.id = ur.role')
            ->where('ur.user =?',$this->id);
            $usersRoles = $this->getTable()->fetchAll($select);
            $cache->save($usersRoles, md5(UNIQUE_HASH.'users_roles_'.$this->id), array('users_roles','user_data'));
        }
        return $usersRoles;
    }
    
    /**
     * checks permission to admin panel section
     * @param $permissionName (integer)permission type identifier
     * @param $defaultDeniedMessage (boolean)to add default denied message to flash messanger
     * @return boolean result
     */
    public function isAllowed($permissionName, $defaultDeniedMessage = true){
        return Reactor_Acl::isAllowed($this->findUsersRoles(),Reactor_Acl::ACCESS_ADMIN_SECTION,null,false);
    }
}
?>