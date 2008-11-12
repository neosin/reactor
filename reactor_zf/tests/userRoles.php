<?php
//sample test
$root = realpath(dirname(__FILE__));
set_include_path($root.'/../library' . PATH_SEPARATOR . '.' . PATH_SEPARATOR
. PATH_SEPARATOR . $root.'/../application'
. PATH_SEPARATOR . get_include_path());

include_once 'Zend/Acl.php';
include_once 'Zend/Acl/Role.php';
include_once 'Zend/Acl/Resource.php';
include_once 'Zend/Auth.php';
include_once 'Zend/Auth/Adapter/Interface.php';
include_once 'Zend/Auth/Storage/Session.php';
include_once 'Zend/Auth/Adapter/DbTable.php';
include_once 'Zend/Db.php';
include_once 'Zend/Db/Table.php';
include_once 'Zend/Db/Table/Rowset.php';
include_once 'Zend/Db/Table/Row.php';
include_once 'Zend/Db/Table/Select.php';

include_once 'models/Users.php';
include_once 'models/User.php';
include_once 'models/UsersRoles.php';

$db = Zend_Db::factory('PDO_PGSQL',array('username' => "test",'password' => "test", 'dbname' => "reactor",'host' => "localhost"));
$db->query("SET NAMES 'UNICODE'");
Zend_Db_Table::setDefaultAdapter($db);

$users = new Users();
$user = $users->recreateUserSession();
$user = $users->authUser('admin', md5('nekmus14'));
#$user->clear();
?>
<pre>
<?php 
var_dump($user->findUsersRoles());
?>
</pre>