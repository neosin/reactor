init = function (){
    dojo.query('#loadingJSResources').orphan();
    /*building top menu*/
    dojo.query('#topMenu .section').style('display','none');
    dojo.query('#topMenu .types li').forEach(function(elem){
    	dojo.connect(elem,'onmouseover',function(){
    		dojo.animateProperty({node:elem, duration:200, properties: {borderBottomColor:'#ffcc00',}}).play();
    		dojo.query('#topMenu .section').style('display','none');
    		dojo.query('#topMenu .section.'+elem.className).style('display','block');
    	});
    	//TODO make the code more efficient and work only on mouseover
    	dojo.connect(elem,'onmouseout',function(){
    		dojo.animateProperty({node:elem, duration:200, properties: {borderBottomColor:'353535',},onEnd:function(){
    			elem.style.borderBottomColor='transparent'}}
    		).play();
    	});
    });
}

dojo.addOnLoad(init);

