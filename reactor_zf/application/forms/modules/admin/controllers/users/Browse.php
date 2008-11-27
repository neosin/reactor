<?php
class Modules_Admin_Controllers_Users_Browse_Form extends Reactor_Form{
    function init(){
        $translate = Zend_Registry::get('Zend_Translate');
        $this->setName('loginForm');
        $this->setTranslator($translate);
        $this->setMethod('post');
        $this->setAttrib('enctype','multipart/form-data');
        $this->addElement('Select','role',array(
        'label'=>$translate->translate('role'),
        'attribs'=>array(
        'style'=>'width:auto'
        )
        ));
        $this->addElement('Radio','belongs',array(
        'label'=>$translate->translate('usersBelongToRole'),
        'multiOptions'=>array(1=>$translate->translate('yes'),0=>$translate->translate('no')),
        'attribs'=>array(
        'style'=>'width:auto'
        )
        ));
        $this->addElement('Button','submit',array(
        'label'=>$translate->translate('search'),
        'order'=>999,
        'type'=>'submit',
        'attribs'=>array(
        'style'=>'width:auto'
        )
        ));
        $this->reconfigureElements();
    }
}
?>