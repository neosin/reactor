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

$dbEngine = 'PDO_PGSQL';

$db = Zend_Db::factory('PDO_PGSQL',array('username' => "test",'password' => "test", 'dbname' => "reactor",'host' => "localhost"));
$db->query("SET NAMES 'UNICODE'");
Zend_Db_Table::setDefaultAdapter($db);

switch ($dbEngine) {
    case 'PDO_PGSQL':
        $sql = file_get_contents('../../postgresql-schema.sql');
        break;
    default:
        $sql = file_get_contents('../../mysql-schema.sql');
        break;
}

$queries = explode('--query--',$sql);

$results = array();
if (isset($_GET['install'])){
    foreach ($queries as $query){
        try {
        $db->query($query);
        array_push($results,'OK!');
        }
        catch(Zend_Exception $e){
            array_push($results,$e->getMessage());
        }
    }
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DB INSTALLER</title>
<style type="text/css">
body {
	background-color: #cecece;
	font-size: 12px;
	font-family: verdana;
}
.queryHolder{
border: 1px solid #aaaaaa;
background-color: #ffffff;
padding: 5px;
margin: 10px;
}
.response{
color: #ff0000;
}
.success{
color: #009900 !important;
font-weight: bold;
}
</style>
</head>
<body>
<h1 style="color: #ff0000">IT WIPES OUT YOUR DATABASE AND INSTALLS CLEAN
ONE !!!!</h1>
<a href="?install=true">CLICK TO INSTALL</a>
<?
if (isset($_GET['install'])):
$qTotal = count($queries);
for ($i=0; $i<$qTotal; $i++): ?>

<div class="queryHolder">
<div class="query"><?= $queries[$i]?></div>
<div class="response <? if($results[$i]=='OK!'){?>success<?}?>"><?= $results[$i]?></div>
</div>

<?
endfor;
endif;
?>
</body>
</html>