<?php

class Reactor_Image{
	
	public static function factory($type,$options){
	    switch ($type) {
	    	case 'GD':
	    	    include_once 'Reactor/Image/Adapter/GD.php';
	    	    return new Reactor_Image_Adapter_Gd($options);
	    	break;
	    	case 'Imagick':
	    	    include_once 'Reactor/Image/Adapter/Imagick.php';
	    	    return new Reactor_Image_Adapter_Imagick($options);
	    	    
	    	break;	    	
	    	default:
	    	    throw new Zend_Exception('No applicable adapter found');
	    	break;
	    }
	}
}

?>
