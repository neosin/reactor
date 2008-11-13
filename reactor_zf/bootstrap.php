<?php
$xstart = microtime(true);
$root = realpath(dirname(__FILE__));
set_include_path($root.'/library' . PATH_SEPARATOR . '.' . PATH_SEPARATOR
. PATH_SEPARATOR . $root.'/application/'
. PATH_SEPARATOR . get_include_path());

// boost for opcode caches
include_once 'Zend/Acl.php';
include_once 'Zend/Acl/Role.php';
include_once 'Zend/Acl/Resource.php';
include_once 'Zend/Auth.php';
include_once 'Zend/Auth/Adapter/Interface.php';
include_once 'Zend/Auth/Storage/Session.php';
include_once 'Zend/Auth/Adapter/DbTable.php';
include_once 'Zend/Cache.php';
include_once 'Zend/Config/Ini.php';
include_once 'Zend/Controller/Front.php';
include_once 'Zend/Controller/Action.php';
include_once 'Zend/Db.php';
include_once 'Zend/Db/Table.php';
include_once 'Zend/Db/Table/Rowset.php';
include_once 'Zend/Db/Table/Row.php';
include_once 'Zend/Db/Table/Select.php';
include_once 'Zend/Dojo.php';
include_once 'Zend/Form.php';
include_once 'Zend/Form/SubForm.php';
include_once 'Zend/Layout.php';
include_once 'Zend/Locale.php';
include_once 'Zend/Paginator.php';
include_once 'Zend/Paginator/Adapter/DbSelect.php';
include_once 'Zend/View/Helper/PaginationControl.php';
include_once 'Zend/Registry.php';
include_once 'Zend/Session.php';
include_once 'Zend/Session/SaveHandler/DbTable.php';
include_once 'Zend/Translate.php';
include_once 'Reactor/Acl.php';
include_once 'Reactor/Controller/Plugin/Common.php';
include_once 'Reactor/DbTable.php';
include_once 'Reactor/Image.php';
include_once 'forms/SimpleConfimation.php';
include_once 'forms/LogIn.php';
#include_once 'models/Object.php';
#include_once 'models/Object/Foundation.php';
#include_once('models/Object/Document.php');
#include_once('models/Object/Gallery.php');
#include_once 'models/Role.php';
include_once 'models/Users.php';
include_once 'models/User.php';
include_once 'models/UsersRoles.php';

//shut down magic quotes
if (get_magic_quotes_gpc()) {
	function cb_stripslashes(&$value, $key) {
		$value = stripslashes($value);
	}
	array_walk_recursive($_GET, 'cb_stripslashes');
	array_walk_recursive($_POST, 'cb_stripslashes');
	array_walk_recursive($_COOKIE, 'cb_stripslashes');
	array_walk_recursive($_REQUEST, 'cb_stripslashes');
}

$cache = Zend_Cache::factory('Core', 'File' , array('automatic_serialization' => true, 'lifetime' => 60*5 ), array('cache_dir' =>'./data/cache'));
//$cache = Zend_Cache::factory('Core', 'Apc' , array('automatic_serialization' => true, 'lifetime' => 60*5 ));
//$cache->clean(Zend_Cache::CLEANING_MODE_ALL);
Zend_Registry::set('cache',$cache);
//configuration
if(!$config = $cache->load('configuration')){
	$config = new Zend_Config_Ini('./application/config/config.ini','site');
	$cache->save($config,'configuration');
}
//default date
date_default_timezone_set($config->setup->defaultTimezone);
//default paginator
Zend_Paginator::setDefaultScrollingStyle('Sliding');
Zend_View_Helper_PaginationControl::setDefaultViewPartial('default_pagination_control.phtml');
Zend_Registry::set('config',$config);
//error handling
if($config->setup->debug){
	error_reporting(E_ALL|E_STRICT);
}
else{
	error_reporting(0);
}
$frontController = Zend_Controller_Front::getInstance();
$frontController->addModuleDirectory($config->setup->frontController->moduleDirectory);
$router = $frontController->getRouter();
$router->addConfig($config->router,'routes');
$frontController->setRouter($router);
Zend_Controller_Action_HelperBroker::addPath('Reactor/Controller/Action/Helper', 'Reactor_Controller_Action_Helper');
Zend_Layout::startMvc($config->setup->layout->toArray());
$frontController->registerPlugin(new Reactor_Controller_Plugin_Common);
$frontController->dispatch();

if($config->setup->debug == 'true'){
	include 'Zend/Version.php';
	if($config->setup->database->profiler == 'true' && Zend_Db_Table::getDefaultAdapter()){
		$profiler = Zend_Db_Table::getDefaultAdapter()->getProfiler();
		$queries = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT | Zend_Db_Profiler::INSERT | Zend_Db_Profiler::UPDATE | Zend_Db_Profiler::DELETE | Zend_Db_Profiler::TRANSACTION);
		$i=0;
		if(!empty($queries)){
			foreach($queries as $query){
				echo '<div class="debug">'. ++$i.'. '. $query->getQuery() . '</div>';
			}
		}
		echo '<div class="debug>' . substr((microtime(true)-$xstart),0,5) . '| queries: '. $profiler->getTotalNumQueries() .'| total query time : '.substr($profiler->getTotalElapsedSecs(),0,5).'s, ZF version:<strong>'. Zend_Version::VERSION . '</strong></div>';
	}
	else{
		echo '<div class="debug">' . substr((microtime(true)-$xstart),0,5) . 's, ZF version: ,<strong>'. Zend_Version::VERSION . '</strong></div>';
	}
}
?>