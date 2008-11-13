dependencies = {
	layers: [
		{
			name: "dojo.js",
		        dependencies: [
				"dojo.fx",
				"dojo.NodeList-fx",
				"dojo.fx.easing",
				"dijit.Tooltip"
				    ]
		},
		{
			name: "dojo-layout.js",
			dependencies: [
				"dijit.layout.AccordionContainer",
				"dijit.layout.AccordionPane",
				"dijit.layout.ContentPane",
				"dijit.layout.TabContainer",
				"dijit.layout.SplitContainer",
				"dojox.layout.GridContainer",
				"dojox.layout.ResizeHandle",
				"dojox.layout.ToggleSplitter"
			]
		},
		{
			name: "dojo-ui.js",
			dependencies: [
				"dojo.dnd",
				"dijit.Dialog",
				"dijit.Editor",
				"dijit.form.DateTextBox",
				"dijit.form.FilteringSelect",
				"dojox.form.Rating",
				"dijit.form.Slider",
				"dojox.grid.DataGrid",
				"dojox.image.Badge",
				"dojox.widget.Calendar",
				"dojox.widget.ColorPicker",
				"dojox.widget.Dialog",
			]
		},
		{
			name: "dojo-charting.js",
			dependencies: [												    
				"dojox.charting.widget.Chart2D",
				"dojox.charting.widget.Sparkline",
				"dojox.charting.widget.Legend",
				"dojox.charting.themes.PlotKit.orange",
				"dojox.charting.themes.PlotKit.blue",
				"dojox.charting.themes.PlotKit.green",
				"dojox.charting.action2d.Highlight",
				"dojox.charting.action2d.Magnify",
				"dojox.charting.action2d.MoveSlice",
				"dojox.charting.action2d.Shake",
				"dojox.charting.action2d.Tooltip",
				"dojox.charting.Chart3D",
				"dojox.charting.plot3d.Bars",
				"dojox.charting.plot3d.Cylinders"
			]
		},
	],

	prefixes: [
		[ "dijit", "../dijit" ],
		[ "dojox", "../dojox" ]
	]
};
