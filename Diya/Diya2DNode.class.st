Class {
	#name : #Diya2DNode,
	#superclass : #DiyaNode,
	#instVars : [
		'color',
		'vbuffer',
		'bbox'
	],
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
Diya2DNode >> boundingBox [ 
	^ bbox
]

{ #category : #accessing }
Diya2DNode >> color [
	^ color
]

{ #category : #accessing }
Diya2DNode >> color: anObject [
	color := anObject
]

{ #category : #accessing }
Diya2DNode >> extent [
	^ bbox extent
]

{ #category : #accessing }
Diya2DNode >> height [
	^ self extent y
]

{ #category : #initialization }
Diya2DNode >> initialize [
	super initialize.
	translation := 0@0.
	scale := 1.0@1.0.
	rotation := 0.0.
	tf := Array2D identity: 3.
	shader := Diya2DShader uniqueInstance.
	color := Color white.
	vbuffer := nil.
]

{ #category : #'as yet unclassified' }
Diya2DNode >> recFromBuffer [
	|maxX maxY minX minY x y|
	maxX := minX := vbuffer at: 1.
	maxY := minY := vbuffer at: 2.
	1 to: vbuffer size by: 4  do: [ :i|
		x := vbuffer at: i.
		y := vbuffer at: i + 1.
		maxX := maxX max: x.
		maxY := maxY max: y.
		minX := minX min: x.
		minY := minY min: y.
	].
	^ Rectangle origin: minX@minY corner: maxX @ maxY
]

{ #category : #initialization }
Diya2DNode >> setUpShader [
	super setUpShader.
	shader setUniform: #u_color value: self color asGL4FArray.
]

{ #category : #accessing }
Diya2DNode >> updateTF [
	tf := Array2D identity:3.
	"translation"
		tf := tf +* (Array2D rows: 3 columns: 3 contents: {
			1.0. 0.0. translation x.
			0.0. 1.0. translation y.
			0.0. 0.0. 1.0
		}).
	"rotation"
		tf := tf +* (Array2D rows: 3 columns: 3 contents:{
			rotation cos. (rotation sin) negated. 0.0.
			rotation sin. rotation cos. 0.0.
			0.0. 0.0. 1.0
		}).
	"scale"
		tf := tf +* (Array2D rows: 3 columns: 3 contents:{
			scale x. 0.0. 0.0.
			0.0. scale y. 0.0.
			0.0. 0.0. 1.0
		}).
	self parent isRoot ifFalse: [ tf := self parent tf +* tf ].
	children ifNotNil: [
		children do:[:c| c updateTF ]].
	
]

{ #category : #accessing }
Diya2DNode >> width [
	^ self extent x
]
