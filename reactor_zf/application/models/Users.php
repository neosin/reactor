<?php
class Users extends Zend_Db_Table{
    protected $_name            = 'users';
    protected $_rowClass        = 'user';

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
            $auth->getStorage()->write($userData);
        }
        return $this->recreateUserSession($sessionName);
    }

    public function recreateUserSession($sessionName = 'userSessionName'){
        $auth = Zend_Auth::getInstance();
        $auth->setStorage(new Zend_Auth_Storage_Session($sessionName));
        if($auth->getIdentity()){
            $userData = $auth->getStorage();
            $user = $this->createRow($userData->read());
        }
        else{
            $user = $this->createRow();
        }
        return $user;
    }
}
?>