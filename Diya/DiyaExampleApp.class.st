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
	DiyaUIThemesManager uniqueInstance currentTheme
		define: #text_icon_1 styles: { 
			#color -> Color orange.
			#fontSize -> 24.
			#bgColor -> Color transparent.
		};
		define: #image_view styles: { 
			#color -> (Color r: 1.0 g:1.0  b:1.0  alpha:1.0 ).
			#border -> 3.
			#bgColor -> Color cyan.
			#borderColor -> Color red
		};
		define: #text_view styles: { 
			#color -> Color green.
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
			#bgColor -> Color cyan.
			#border -> 3.
		};
		define: #poly_view styles: { 
			#borderColor -> Color red.
			#color -> Color green.
			#border -> 3.
		};
		define: #button_view styles: { 
			#borderColor -> Color red.
			#color -> Color white.
			#bgColor -> Color magenta.
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
	|node node1 ell label icon button|
	self defineStyleSheet.
	label := root addNode: (DiyaLabel new) at: 10@40.
	label extent: 250@24.
	label styleName:#text_icon_1.
	label icon: 16rF254.
	
	
	node1 := root addNode: (DiyaRectangle size:100@150 shader: DiyaExampleShader uniqueInstance) at: 300 @ 40.
	"node1 rotation: (Float pi / 8.0)."
	node1 scale: 1.2@1.2.
	node1 on: #(mousebuttondown fingerdown) do:[:e|
		label txt: 'Mouse ', (node1 local: e mapped worldPosition) asIntegerPoint asString].
	
	node := root addNode: (DiyaImageView from:'mrsang.png') at: 10 @ 400.
	node styleName: #image_view.
	node extent:200@200.
	
	node := root addNode: (DiyaRectangle new) at: 10@80.
	node styleName: #image_view.
	node extent: 240@320.
	
	node := root addNode: (DiyaText data: String loremIpsum) at: 10@80.
	node extent: 240@320.
	node wordWrap: true.
	node styleName: #text_view.
	
	node := root addNode: (DiyaLine from: 10@10 to: 200@200).
	node styleName: #line_view.
		
	ell := root addNode: (DiyaEllipse rx:100  ry: 70) at: 100@300.
	ell rotation: Float pi / 6.0.
	ell styleName: #ell_view.
	"node rotation: Float pi / 2.0."
	ell textureNamed:'mrsang.png'.
	ell on: #(mousebuttondown fingerdown) do:[:e|
		label txt: 'Ellipse clicked', (ell local:e mapped worldPosition) asIntegerPoint asString].

	node := root addNode: (DiyaConvexPolygon points:{250@100. 400@250. 450@80. 350@60}).
	node textureNamed: 'mrsang.png'.
	node styleName: #poly_view.
	
	icon := root addNode: (DiyaFontIcon data: #(16rF101 16rF155 16rF185 16rF21B 16rF298 16rF254)) at: 240@500.
	icon styleName: #text_icon_1 .
	
	button := root addNode: (DiyaButton text: 'Click me !') at: 240@460.
	button extent: 200@40.
	button icon:"16rF185"'mrsang.png'.
	button styleName: #button_view.
	^ root 
]
