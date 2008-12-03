<?php

class Reactor_Form extends Zend_Form{

    protected function reconfigureElements(){
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
        try{
        $this->getElement('submit')->removeDecorator('Label');
        }
        catch (Zend_Form_Exception $e){
            #nothing here
        }
    }
}
?>