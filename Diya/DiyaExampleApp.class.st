Class {
	#name : #DiyaExampleApp,
	#superclass : #DiyaBaseApplication,
	#category : #'Diya-Applications'
}

{ #category : #accessing }
DiyaExampleApp >> cleanup [ 

]

{ #category : #accessing }
DiyaExampleApp >> defineNodes [
	|node2 node1 img ell label icon button texture loading|
	texture := DiyaImageTex new.
	label := node addNode: (DiyaLabel new) at: 10@40.
	label extent: 250@24.
	label styleName:#text_icon_1.
	label icon: 16rF254.
	
	node1 := node addNode: (DiyaRectangle size:100@150 shader: DiyaExampleShader uniqueInstance) at: 300 @ 40.
	node1 rotation: 45.
	node1 scale: 2.0@2.0.
	node1 on: #(mousebuttondown fingerdown) do:[:e|
		label txt: 'RECT ', (node1 local: e mapped worldPosition) asIntegerPoint asString].
	
	img := node addNode: (DiyaImageView from:'mrsang.png') at: 10 @ 400.
	img styleName: #image_view.
	img extent:200@200.
	node on: #(mousebuttondown fingerdown) do:[:e|
		"change texture"
		|p|
		p := e mapped worldPosition.
		label txt: 'Mouse ', p asIntegerPoint asString.
		DiyaRenderer assets
			addAsset:(texture fromDisplay: (Rectangle origin: ((p x - 100) @ (p y - 100)) extent: 200@200 ) as: 'capture').
		img textureNamed: 'capture'.
		
	].
	
	node2 := node addNode: (DiyaRectangle new) at: 10@80.
	node2 styleName: #rect_view.
	node2 extent: 240@320.
	
	node2 := node addNode: (DiyaText data: String loremIpsum) at: 10@80.
	node2 extent: 240@320.
	node2 wordWrap: true.
	node2 styleName: #text_view.
	
	node2 := node addNode: (DiyaLine from: 10@10 to: 200@200).
	node2 styleName: #line_view.
		
	ell := node addNode: (DiyaEllipse rx:100  ry: 70) at: 120@300.
	ell scale: 1.2 @ 1.2.
	ell styleName: #ell_view.
	"ell rotation: 30."
	ell textureNamed:'mrsang.png'.
	ell addNode: (DiyaTimerNode timeout: 1000 / 6 do:[:n |
		n parent rotation: n parent rotation + 10.	
	] ).
	ell on: #(mousebuttondown fingerdown) do:[:e|
		label txt: 'Ellipse clicked', (ell local:e mapped worldPosition) asIntegerPoint asString].

	node2 := node addNode: (DiyaConvexPolygon points:{0@40. 150@190. 200@20. 100@0}) at: 250@60.
	node2 textureNamed: 'mrsang.png'.
	node2 styleName: #poly_view.
	
	icon := node addNode: (DiyaFontIcon data: #(16rF101 16rF155 16rF185 16rF21B 16rF298 16rF254)) at: 240@500.
	icon styleName: #text_icon_2.
	
	button := node addNode: (DiyaButton text: 'Click me !') at: 240@460.
	icon := DiyaFontIcon data: 16rF130.
	"icon := DiyaImageIcon from:  'mrsang.png'."
	icon addNode:(DiyaTimerNode timeout: 1000 / 12 do:[:n |
		n parent rotation: n parent rotation + 10 pivot: n parent extent / 2.	
	] ).
	button extent: 200@40.
	button icon: icon "'mrsang.png'".
	"button rotation: Float pi / 2.0."
	button styleName: #button_view.
	
	loading := node addNode: (DiyaLoadingBar new) at: 240@550.
	loading extent: 200 @ 20.
	 
	loading addNode: (DiyaTimerNode timeout: 2000 do:[:n |
		|p|
		p := (n parent percent + 10).
		p > 100 ifTrue:[ p := 0].
		n parent percent: p.
	] ).


	loading := node addNode: (DiyaLoadingBar new) at: 240@580.
	loading extent: 200 @ 20.
	 
	loading addNode: (DiyaTimerNode timeout: 1000 do:[:n |
		|p|
		p := (n parent percent + 10).
		p > 100 ifTrue:[ p := 0].
		n parent percent: p.
	] ).
]

{ #category : #accessing }
DiyaExampleApp >> defineStyleSheet [
	|fmgr style|
	fmgr := DiyaFontManager uniqueInstance.
	#(16 18 24) do:[:fontSize|
		self stdlog: 'Init font size ', fontSize asString, ' of ', fmgr defaultFamily.
		style := fmgr style: fmgr defaultStyle   from: fmgr defaultFamily.
		(style textureOf: fontSize)" genPrintableASCII" .
	].
	DiyaUIThemesManager uniqueInstance currentTheme
		define: #text_icon_1 styles: { 
			#color -> Color orange.
			#fontSize -> 24.
			#bgColor -> Color transparent.
		};
		define: #text_icon_2 extend:#text_icon_1  styles: {
			#fontSize -> 16.
		 };
		define: #image_view styles: { 
			#color -> Color white.
			#border -> 1.
			#bgColor -> Color cyan.
			#borderColor -> Color red
		};
		define: #rect_view extend: #image_view styles: { 
			#bgColor -> Color transparent.
		};
		define: #text_view styles: { 
			#color -> Color orange.
			#fontSize -> 16.
			#bgColor -> Color transparent.
			#xAlign -> #center
		};
		define: #line_view styles: { 
			#color -> Color red.
			#border -> 4
		};
		define: #ell_view styles: { 
			#borderColor -> Color red.
			#color -> Color white.
			#border -> 2.
		};
		define: #poly_view styles: { 
			#borderColor -> Color red.
			#color -> Color green.
			#border -> 1.
			#bgColor -> Color transparent.
		};
		define: #button_view styles: { 
			#borderColor -> (Color r: 0.051 g: 0.051  b: 0.051).
			#color -> Color white.
			#bgColor -> (Color r: 0.1529 g: 0.1529  b: 0.1529).
			#border -> 1.
			#yAlign -> #middle.
			#xAlign -> #center
		}
]

{ #category : #initialization }
DiyaExampleApp >> initLoader [
	loader := DiyaDefaultAppLoader new.
]

{ #category : #accessing }
DiyaExampleApp >> onloaded: aBlock [
	loader job: [ self defineStyleSheet  ] name: 'Initializing themes...'.
	loader job: [
		self defineNodes.
		self node forceReload
	] name: 'Initializing UI elements...'.
	
	loader onloaded: aBlock
]
