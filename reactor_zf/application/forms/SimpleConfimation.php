<?php
include_once 'Zend/Form.php';

class Reactor_Form_SimpleConfirmation extends Zend_Form{
	
	public function init(){
		$config = Zend_Registry::get('config');
        $this->setTranslator(Zend_Registry::get('Zend_Translate'));
        $this->setMethod('post');
        $this->setAttrib('enctype','multipart/form-data');
        $this->addElement('hash', 'no_csrf', array('salt' => 'unique'));
        
        $this->addElement('submit','yes',array(
        'label'=>'f_yes',
        'attribs'=>array(
        'style'=>'width:auto'
        )
        ));
        $this->setElementDecorators(
        array(
        'ViewHelper',
        'Errors'
        ));
	}
}
?>