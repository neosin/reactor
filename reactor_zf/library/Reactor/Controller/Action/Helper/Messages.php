<?php
require_once 'Zend/Session.php';
require_once 'Zend/Session/Namespace.php';

/**
 * flash messaging service that preserves the message as long as its not retrieved or session cleared
 * @author ergo
 *
 */
class Reactor_Controller_Action_Helper_Messages extends Zend_Controller_Action_Helper_Abstract{

	private $_session;

	public function __construct($sessionName = 'messages'){
		$this->_session = new Zend_Session_Namespace('reactorMessagingServices');
	}

	public function postDispatch(){
	}

	public function __set($type,$message){
		if(isset($this->_session->$type)){
			array_push($this->_session->$type,$message);
		}
		else{
			$this->_session->$type = array();
			array_push($this->_session->$type,$message);
		}
		return $this;
	}
	/**
	 * returns the number of specific type messages
	 * @param $type string
	 * @return integer
	 */
	public function hasMessages($type=null){
		$types = (array)$this->_session->getIterator();
		$keys = array_keys($types);
		while ($key = current($keys)){
			if(count($key)){
				return true;
			}
			next($keys);
		}
		return false;
	}

	public function __get($type){
		if(isset($this->_session->$type)){
			$messages = $this->_session->$type;
			$this->_session->$type = array();
			return (array)$messages;
		}
		return array();
	}
	/**
	 * returns all messages in array
	 * @return array
	 */
	public function getMessages(){
		$messages = (array)$this->_session->getIterator();
		$this->clearMessages();
		return $messages;
	}
	/**
	 * clears all messages instantly
	 * 
	 */
	public function clearMessages(){
		$types = (array)$this->_session->getIterator();
		$keys = array_keys($types);
		while ($key = current($keys)){
			unset($this->_session->$key);
			next($keys);
		}
	}
	/**
	 * returns total count of stored messages
	 * @return integer
	 */
	public function count(){
		$total = 0;
		$types = (array)$this->_session->getIterator();
		$keys = array_keys($types);
		while ($key = current($keys)){
			$total = $total + count($this->_session->$key);
			next($keys);
		}
		return $total;
	}
}
