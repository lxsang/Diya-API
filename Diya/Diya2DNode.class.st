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
	tf := MatrixTransform2x3 identity .
	shader := Diya2DShader uniqueInstance.
	vbuffer := nil.
]

{ #category : #accessing }
Diya2DNode >> inner: aPoint [
	^ self boundingBox containsPoint: (self local: aPoint)
]

{ #category : #accessing }
Diya2DNode >> local: aPoint [
	^((aPoint - (0@0 applyTf: self tf) )/ scale)
			rotateBy: rotation about: 0@0.
	
]

{ #category : #accessing }
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

{ #category : #accessing }
Diya2DNode >> updateTF [
	tf := MatrixTransform2x3 identity.
	"translation"
	tf setOffset: translation + pivot.
	"rotation"
	rotation = 0 ifFalse:[tf setAngle: rotation ].
	"translate back to pivot"
	pivot isZero ifFalse:[
		tf := tf composedWithLocal:
			(MatrixTransform2x3 identity
				setOffset: pivot negated;
				yourself)
	].
	scale isZero ifFalse: [
		tf := tf composedWithLocal:
			(MatrixTransform2x3 identity
				setScale: scale;
				yourself)
	].
	self parent ifNil: [ ^self ].
	self parent isRoot ifFalse: [tf := self parent tf composedWithLocal:  tf ].
	children ifNotNil: [children do:[:c| c updateTF ]].
	
]

{ #category : #accessing }
Diya2DNode >> width [
	^ self extent x
]
