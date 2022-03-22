Class {
	#name : #Diya2DNode,
	#superclass : #DiyaNode,
	#instVars : [
		'vbuffer'
	],
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
Diya2DNode >> boundingBox [ 
	|rec|
	children ifEmpty: [ ^ Rectangle origin: 0@0 corner: 0@0 ].
	rec := children first boundingBox.
	children do:[:c|
		rec = c ifFalse:[
			rec := rec merge: c boundingBox]
	].
	^rec
]

{ #category : #accessing }
Diya2DNode >> color [
	^ self style get: #color.
]

{ #category : #accessing }
Diya2DNode >> color: anObject [
	style set:#color value: anObject
]

{ #category : #accessing }
Diya2DNode >> draw [
	
]

{ #category : #accessing }
Diya2DNode >> extent [
	^ self boundingBox extent
]

{ #category : #accessing }
Diya2DNode >> height [
	^ self extent y
]

{ #category : #initialization }
Diya2DNode >> initialize [
	super initialize.
	translation := 0@0.
	scale := 1@1.
	rotation := 0.
	tf := Array2D identity: 3.
	shader := Diya2DShader uniqueInstance.
	vbuffer := nil.
]

{ #category : #'as yet unclassified' }
Diya2DNode >> inner: aPoint [
	^ self boundingBox containsPoint: (self local: aPoint)
]

{ #category : #accessing }
Diya2DNode >> local: aPoint [
	^((aPoint - (0@0 applyTf: self tf) )/ scale)
			rotateBy: rotation about: 0@0.
	
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
	translation = (0@0) ifFalse:[
		tf := tf +* (Array2D translateMatrix2D: translation)].
	"rotation"
	rotation = 0 ifFalse:[
		tf := tf +* (Array2D rotationMatrix2D: rotation )].
	"scale"
	scale = (1@1) ifFalse:[
		tf := tf +* (Array2D scaleMatrix2D: scale)].
	self parent ifNil: [ ^self ].
	self parent isRoot ifFalse: [tf := self parent tf +* tf ].
	children ifNotNil: [children do:[:c| c updateTF ]].
	
]

{ #category : #accessing }
Diya2DNode >> width [
	^ self extent x
]
