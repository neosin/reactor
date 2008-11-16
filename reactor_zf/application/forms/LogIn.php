<?php
class Reactor_Form_LogIn extends Zend_Form{
    public function init(){
        $translate = Zend_Registry::get('Zend_Translate');
        $config = Zend_Registry::get('config');
        $this->setName('loginForm');
        $this->setTranslator($translate);
        $this->setMethod('post');
        $this->setAttrib('enctype','multipart/form-data');
        $this->setAction(Zend_Controller_Action_HelperBroker::getStaticHelper('url')->url(array('action'=>'log-in'),'admin'));
        $this->addElement('hash', 'no_csrf', array('salt' => 'unique'));
        $this->addElement('text','username',array(
		'required'=>true,
		'label'=>$translate->_('f_username'),
		'validators'=> array(
		'stringLength'=>array(
		'validator'=>'stringLength',
		'options' => array(
		'min'=>1,
		'max'=>999)
        ))
        ));
        $this->addElement('password','password',array(
		'required'=>true,
		'label'=>$translate->_('f_password'),
		'validators'=> array(
		'stringLength'=>array(
		'validator'=>'stringLength',
		'options' => array(
		'min'=>1,
		'max'=>999)
        ))
        ));
        $this->addElement('Button','submit',array(
        'label'=>$translate->_('f_sign_in'),
        'order'=>999,
        'type'=>'submit',
        'attribs'=>array(
        'style'=>'width:auto'
        )
        ));
        $this->setElementFilters(array(
        'stringTrim'
        ));

        $this->setElementDecorators(
        array(
        'ViewHelper',
        'Errors',
        array(
        'decorator' => array('formElement' => 'HtmlTag'), 
        'options' => array('class'=>'formElement')
        ),
        array('Label', array('requiredSuffix' => '*')),
        array(
        'decorator' => array('formRow'=>'HtmlTag'), 
        'options' => array('class'=>'formRow')
        )
        ));
        $this->getElement('submit')->removeDecorator('Label');
        $this->getElement('no_csrf')->removeDecorator('formElement')->removeDecorator('formRow');
    }
}
?>
