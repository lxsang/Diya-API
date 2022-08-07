Class {
	#name : #DiyaExampleApp,
	#superclass : #DiyaBaseApplication,
	#category : #'Diya-Applications'
}

{ #category : #accessing }
DiyaExampleApp >> cleanup [ 

]

{ #category : #accessing }
DiyaExampleApp >> main [

]

{ #category : #accessing }
DiyaExampleApp >> setup [
	|node node1 ell label icon button|
	label := root addNode: (DiyaLabel new) at: 10@40.
	label extent: 250@24.
	label color: Color orange.
	label iconSize: 24.
	label icon: 16rF254.
	
	
	node1 := root addNode: (DiyaRectangle size:100@150 shader: DiyaExampleShader uniqueInstance) at: 300 @ 40.
	"node1 rotation: (Float pi / 8.0)."
	node1 scale: 1.2@1.2.
	node1 on: #(mousebuttondown fingerdown) do:[:e|
		label txt: 'Mouse ', (node1 local: e mapped worldPosition) asIntegerPoint asString].
	
	node := root addNode: (DiyaImageView from:'mrsang.png') at: 10 @ 400.
	node color: (Color r: 1.0 g:1.0  b:1.0  alpha:1.0 ).
	node borderWidth:1.
	node bgColor: Color cyan.
	node borderColor: Color red.
	node borderWidth: 3.0.
	node extent:200@200.
	
	node := root addNode: (DiyaRectangle new) at: 10@80.
	node borderWidth: 1.
	node extent: 240@320.
	
	node := root addNode: (DiyaText data: String loremIpsum) at: 10@80.
	node extent: 240@320.
	node wordWrap: true.
	node fontSize: 16.
	node bgColor: Color transparent.
	node align: #center.
	
	node := root addNode: (DiyaLine from: 10@10 to: 200@200).
	node color: (Color red).
	node borderWidth: 2.0.
		
	ell := root addNode: (DiyaEllipse rx:100  ry: 70) at: 100@300.
	ell borderColor: Color red.
	ell color: Color white.
	ell bgColor: Color cyan.
	ell rotation: Float pi / 6.0.
	ell borderWidth: 3.0.
	"node rotation: Float pi / 2.0."
	ell textureNamed:'mrsang.png'.
	ell on: #(mousebuttondown fingerdown) do:[:e|
		label txt: 'Ellipse clicked', (ell local:e mapped worldPosition) asIntegerPoint asString].

	node := root addNode: (DiyaConvexPolygon points:{250@100. 400@250. 450@80. 350@60}).
	node color: Color green.
	node borderColor: Color red.
	node textureNamed: 'mrsang.png'.
	node borderWidth: 3.0.
	
	icon := root addNode: (DiyaFontIcon data: #(16rF101 16rF155 16rF185 16rF21B 16rF298 16rF254)) at: 240@500.
	icon fontSize: 24.
	icon bgColor: Color transparent.
	icon color: (Color r: 209/255 g: 66/255  b:245/255 ).
	
	button := root addNode: (DiyaButton text: 'Click me !') at: 240@460.
	button extent: 200@40.
	button icon:16rF185"'mrsang.png'".
	button iconSize: 24.
	^ root 
]
