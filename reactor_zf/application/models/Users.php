<?php
class Users extends Zend_Db_Table{
    protected $_name            = 'users';
    protected $_rowClass        = 'user';
    
    /**
     * authenticates user against database
     * @param $username (string) username
     * @param $password (string) md5'd password string 
     * @param $sessionName (string)session namespace identifier
     * @return User
     */
    public function authUser($username, $password, $sessionName = 'userSessionName'){
        $auth = Zend_Auth::getInstance();
        $auth->setStorage(new Zend_Auth_Storage_Session($sessionName));
        $authAdapter = new Zend_Auth_Adapter_DbTable(Zend_Db_Table::getDefaultAdapter(), 'users', 'username', 'password');
        $authAdapter->setTableName('users');
        $authAdapter->setIdentityColumn('username');
        $authAdapter->setCredentialColumn('password');
        $authAdapter->setIdentity($username);
        $authAdapter->setCredential($password);
        $result = $authAdapter->authenticate();
        if($result->isValid()){
            $userData = (array)$authAdapter->getResultRowObject();
        }
        else{
            $userData = $this->find(1)->current()->toArray();
        }
        $auth->getStorage()->write($userData);
        return $this->recreateUserSession($sessionName);
    }
    
    /**
     * recreates user object from session identifier
     * @param $sessionName (string)session namespace identifier
     * @return User
     */
    public function recreateUserSession($sessionName = 'userSessionName'){
        $auth = Zend_Auth::getInstance();
        $auth->setStorage(new Zend_Auth_Storage_Session($sessionName));
        
        if($userData = $auth->getIdentity()){
            $user = $this->createRow($userData);
        }
        else{
            $user = $this->find(1)->current();
            $auth->getStorage()->write($user->toArray());
        }
        if($user->id < 1){
            $user->setReadOnly(true);
        }
        return $user;
    }
}
?>