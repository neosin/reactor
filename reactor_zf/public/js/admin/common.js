init = function (){
    dojo.query('#loadingJSResources').orphan();
    /* building top menu */
    dojo.query('#topMenu ul.section:not([class~="mainManagement"])').style('display','none');
    dojo.query('#topMenu .types li').forEach(function(elem){
    	dojo.connect(elem,'onclick',function(){
    		dojo.animateProperty({node:elem, duration:300, properties: {borderBottomColor:'#ffcc00',}}).play();
    		dojo.query('#topMenu .section.'+elem.className).style('display','block');
    		dojo.query('#topMenu .section:not([class~="'+ elem.className +'"])').style('display','none');
    		dojo.query('#topMenu .types li:not([class~="'+ elem.className +'"])').forEach(function(elem2){
    			if(elem2.style.borderBottomColor!='transparent'){
    			dojo.animateProperty({node:elem2, duration:300, properties: {borderBottomColor:'454545',},onEnd:function(){
        			elem2.style.borderBottomColor='transparent'}}
        		).play();
    			}
    		});
    	});
    });
}

dojo.addOnLoad(init);

