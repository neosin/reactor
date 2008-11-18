<?php
class ErrorController extends Zend_Controller_Action
{

	public function errorAction(){
		$config = Zend_Registry::get('config');
		$this->_helper->layout->setLayout('error');
		Zend_Layout::getMvcInstance()->setLayout('error');
		$viewRenderer = new Zend_Controller_Action_Helper_ViewRenderer($this->view);
		Zend_Controller_Action_HelperBroker::addHelper($viewRenderer);
		$this->getResponse()->clearBody();
		include_once 'Zend/Log.php';
		include_once 'Zend/Log/Writer/Stream.php';
		$logger = new Zend_Log();
		$error = Zend_Controller_Action::_getParam('error_handler');
		$errorMsg = $error->exception->getMessage();
		try{
			$writer = new Zend_Log_Writer_Stream($config->setup->logfile);
			$logger->addWriter($writer);
			$logger->log($this->getRequest()->getRequestUri().' '.$errorMsg, Zend_Log::ERR);
			$this->view->errorMsg = $errorMsg;
		}
		catch (Zend_Exception $e){
			$this->view->errorMsg = 'oopsie, problem with writing log files ... WTF ?';
		}
	}
}
?>