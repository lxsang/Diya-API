Class {
	#name : #DiyaExampleApp,
	#superclass : #DiyaBaseApplication,
	#category : #'Diya-Applications'
}

{ #category : #accessing }
DiyaExampleApp >> cleanup [ 

]

{ #category : #accessing }
DiyaExampleApp >> defineStyleSheet [
	|fmgr style|
	fmgr := DiyaFontManager uniqueInstance.
	#(16 24) do:[:fontSize|
		Transcript show: 'Init font size ', fontSize asString, ' of ', fmgr defaultFamily; cr.
		style := fmgr style: fmgr defaultStyle   from: fmgr defaultFamily.
		style textureOf: fontSize.
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

{ #category : #accessing }
DiyaExampleApp >> main [

]

{ #category : #accessing }
DiyaExampleApp >> setup [
	|node node1 img ell label icon button texture|
	texture := DiyaImageTex new.
	"DiyaRendererContext uniqueInstance assets
		addAsset:
			((Form fromDisplay: ( Rectangle origin: 0@0 corner: 300@300 )) asDiyaTexture: 'display')."
	self defineStyleSheet.
	label := root addNode: (DiyaLabel new) at: 10@40.
	label extent: 250@24.
	label styleName:#text_icon_1.
	label icon: 16rF254.
	
	node1 := root addNode: (DiyaRectangle size:100@150 shader: DiyaExampleShader uniqueInstance) at: 300 @ 40.
	node1 rotation: 45.
	node1 scale: 2.0@2.0.
	node1 on: #(mousebuttondown fingerdown) do:[:e|
		label txt: 'RECT ', (node1 local: e mapped worldPosition) asIntegerPoint asString].
	
	img := root addNode: (DiyaImageView from:'mrsang.png') at: 10 @ 400.
	img styleName: #image_view.
	img extent:200@200.
	root on: #(mousebuttondown fingerdown) do:[:e|
		"change texture"
		|p|
		p := e mapped worldPosition.
		label txt: 'Mouse ', p asIntegerPoint asString.
		DiyaRendererContext uniqueInstance assets
			addAsset:(texture fromDisplay: (Rectangle origin: ((p x - 100) @ (p y - 100)) extent: 200@200 ) as: 'capture').
		img textureNamed: 'capture'.
		
	].
	
	node := root addNode: (DiyaRectangle new) at: 10@80.
	node styleName: #rect_view.
	node extent: 240@320.
	
	node := root addNode: (DiyaText data: String loremIpsum) at: 10@80.
	node extent: 240@320.
	node wordWrap: true.
	node styleName: #text_view.
	
	node := root addNode: (DiyaLine from: 10@10 to: 200@200).
	node styleName: #line_view.
		
	ell := root addNode: (DiyaEllipse rx:100  ry: 70) at: 120@300.
	ell scale: 1.2 @ 1.2.
	ell styleName: #ell_view.
	ell textureNamed:'mrsang.png'.
	ell addNode: (DiyaTimerNode timeout: 1000 / 6 do:[:n |
		n parent rotation: n parent rotation + 10.	
	] ).
	ell on: #(mousebuttondown fingerdown) do:[:e|
		label txt: 'Ellipse clicked', (ell local:e mapped worldPosition) asIntegerPoint asString].

	node := root addNode: (DiyaConvexPolygon points:{0@40. 150@190. 200@20. 100@0}) at: 250@60.
	node textureNamed: 'mrsang.png'.
	node styleName: #poly_view.
	
	icon := root addNode: (DiyaFontIcon data: #(16rF101 16rF155 16rF185 16rF21B 16rF298 16rF254)) at: 240@500.
	icon styleName: #text_icon_2.
	
	button := root addNode: (DiyaButton text: 'Click me !') at: 240@460.
	icon := DiyaFontIcon data: 16rF130.
	"icon := DiyaImageIcon from:  'mrsang.png'."
	icon addNode:(DiyaTimerNode timeout: 1000 / 12 do:[:n |
		n parent rotation: n parent rotation + 10 pivot: n parent extent / 2.	
	] ).
	button extent: 200@40.
	button icon: icon "'mrsang.png'".
	"button rotation: Float pi / 2.0."
	button styleName: #button_view.
	Transcript show: 'Application setup';cr.
	^ root 
]
