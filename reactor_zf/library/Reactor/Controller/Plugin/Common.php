<?php
class Reactor_Controller_Plugin_Common extends Zend_Controller_Plugin_Abstract
{
	protected $view;
	public function routeStartup(Zend_Controller_Request_Abstract $request)
	{
	}

	public function routeShutdown(Zend_Controller_Request_Abstract $request)
	{
		$config = Zend_Registry::get('config');
		//this is the only place where i want to have another cache instance - for zend_db metadata we should use file cache
		Zend_Db_Table_Abstract::setDefaultMetadataCache(Zend_Registry::get('cache_files'));
		$db = Zend_Db::factory($config->setup->database->adapter,$config->setup->database->config->toArray());
		#TODO did they implement that in 1.7 or still we have to wait :/
		switch ($config->setup->database) {
			case 'PDO_PGSQL':
			$db->query("SET NAMES 'UNICODE'");
			break;
			case 'PDO_MYSQL':
			$db->query("SET NAMES 'utf8'");
			break;
			default:
				;
			break;
		}
		#start up the profiler if needed
		if($config->setup->database->profiler == true){
			$db->getProfiler()->setEnabled($config->setup->database->profiler);
		}
		Zend_Db_Table::setDefaultAdapter($db);
		#TODO database driven sessions - maybe we want to change that in future ? for better scaling ? 
		Zend_Session::setSaveHandler(new Zend_Session_SaveHandler_DbTable(array(
		'name' => 'session',
		'primary'=> 'id',
		'modifiedColumn' => 'modified',
		'dataColumn' => 'data',
		'lifetimeColumn' => 'lifetime')));
		//set up the view
		$viewRenderer = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer');
		$viewRenderer->init();
		$view = $viewRenderer->view;
		$view->addHelperPath('Reactor/View/Helper', 'Reactor_View_Helper');
		Zend_Dojo::enableView($view);
		$view->doctype('XHTML1_STRICT');
		$view->setEncoding('UTF-8');
		$view->request = $this->getRequest();
		$view->baseUrl = $this->getRequest()->getBaseUrl();
		$this->locale = new Zend_Locale($config->setup->defaultLocale);
		Zend_Registry::set('Zend_Locale', $this->locale);
		Zend_Translate::setCache(Zend_Registry::get('cache'));
		#TODO currently hardcoded
		Zend_Registry::set('Zend_Translate', new Zend_Translate('gettext', '../data/locales/en_GB/LC_MESSAGES/default.mo', 'en'));
		Zend_Registry::set('Users',new Users());
	}

	public function dispatchLoopStartup(Zend_Controller_Request_Abstract $request)
	{
	}

	public function preDispatch(Zend_Controller_Request_Abstract $request)
	{
	}

	public function postDispatch(Zend_Controller_Request_Abstract $request)
	{
	}

	public function dispatchLoopShutdown()
	{
	}
}
?>