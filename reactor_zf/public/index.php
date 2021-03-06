<?php
#change to something random
define("UNIQUE_HASH",'7v89vgh');

$xstart = microtime(true);
$root = realpath(dirname(__FILE__));
set_include_path($root.'/../library' . PATH_SEPARATOR . '.' . PATH_SEPARATOR
. PATH_SEPARATOR . $root.'/../application/'
. PATH_SEPARATOR . get_include_path());

include 'Zend/Loader.php';
Zend_Loader::registerAutoLoad();

$classFileIncCache = $root .  '/../data/cache/pluginLoaderCache.php';
if (file_exists($classFileIncCache)) {
    include_once $classFileIncCache;
}
Zend_Loader_PluginLoader::setIncludeFileCache($classFileIncCache);
include_once 'models/Users.php';
include_once 'models/User.php';
include_once 'forms/SimpleConfimation.php';
include_once 'forms/SignInForm.php';

#shut down magic quotes
if (get_magic_quotes_gpc()) {
	function cb_stripslashes(&$value, $key) {
		$value = stripslashes($value);
	}
	array_walk_recursive($_GET, 'cb_stripslashes');
	array_walk_recursive($_POST, 'cb_stripslashes');
	array_walk_recursive($_COOKIE, 'cb_stripslashes');
	array_walk_recursive($_REQUEST, 'cb_stripslashes');
}
try{
#normal file cache
$cache = Zend_Cache::factory('Core', 'File' , array('automatic_serialization' => true, 'lifetime' => 60*5 ), array('cache_dir' =>'../data/cache'));
#files is cache that will be used in case stuff that should not get cached into solutions that may use shared memory, for example zend_db metadata or acl( that needs tags ability)
Zend_Registry::set('cache_files',Zend_Cache::factory('Core', 'File' , array('automatic_serialization' => true, 'lifetime' => 60*10 ), array('cache_dir' =>'../data/cache/filecache')));
#$cache = Zend_Cache::factory('Core', 'Apc' , array('automatic_serialization' => true, 'lifetime' => 60*5 ));
#$cache->clean(Zend_Cache::CLEANING_MODE_ALL);
Zend_Registry::set('cache',$cache);
}
catch(Zend_Exception $e){
    die('Cache dirs are not writeable');
}

#configuration
if(!$config = $cache->load(UNIQUE_HASH.'configuration')){
	$config = new Zend_Config_Ini('../application/config/config.ini','site');
	$cache->save($config,UNIQUE_HASH.'configuration');
}
#setting random hash for things like unique cache identifiers (MANDATORY for servers with APC and multiple instances of software) 
#default date
date_default_timezone_set($config->setup->defaultTimezone);
#default paginator
Zend_Paginator::setDefaultScrollingStyle('Sliding');
Zend_View_Helper_PaginationControl::setDefaultViewPartial('default_pagination_control.phtml');
Zend_Registry::set('config',$config);
#error handling
if($config->setup->debug){
	error_reporting(E_ALL|E_STRICT);
	include_once 'Zend/Debug.php';
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