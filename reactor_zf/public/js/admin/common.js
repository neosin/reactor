trOver = function (){
        dojo.query('td', this).style({
            backgroundColor: '#eeffdb'
        });
    }

trOut = function (){
        dojo.query('td', this).style({
            backgroundColor: ''
        });
    }

init = function (){
    dojo.query('#loadingJSResources').orphan();
    /* building top menu */
    topMenu = dojo.byId('topMenu');
    dojo.query('ul.section:not([class~="active"])',topMenu).style('display','none');
    dojo.query('ul.types li.active',topMenu).style('borderBottomColor','#ffcc00');
    dojo.query('.types li',topMenu).forEach(function(elem){
    	dojo.connect(elem,'onclick',function(){
    		dojo.animateProperty({node:elem, duration:300, properties: {borderBottomColor:'#ffcc00',}}).play();
    		dojo.query('.section[class~="'+elem.className +'"])',topMenu).style('display','block');
    		dojo.query('.section:not([class~="'+ elem.className +'"])',topMenu).style('display','none');
    		dojo.query('.types li:not([class~="'+ elem.className +'"])',topMenu).forEach(function(elem2){
    			if(elem2.style.borderBottomColor!='transparent'){
    			dojo.animateProperty({node:elem2, duration:300, properties: {borderBottomColor:'454545',},onEnd:function(){
        			elem2.style.borderBottomColor='transparent'}}
        		).play();
    			}
    		});
    	});
    });
    /* highlights for tables */
    dojo.query(".reactorTable tbody tr").onmouseenter(trOver).onmouseleave(trOut);
}

dojo.addOnLoad(init);

