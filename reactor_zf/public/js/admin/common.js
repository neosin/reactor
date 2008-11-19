init = function (){
    dojo.query('#loadingJSResources').orphan();
    /*building top menu
    
	cp1 = new dijit.layout.ContentPane({title: ''});
	cp1.domNode.innerHTML = "Contents of Tab 1";
	
	tc = new dijit.layout.TabContainer({style:'height:40px;'}, dojo.byId('topMenu'));
	tc.addChild(cp1);
	*/
}

dojo.addOnLoad(init);

