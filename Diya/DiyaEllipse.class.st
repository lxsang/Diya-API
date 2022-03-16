Class {
	#name : #DiyaEllipse,
	#superclass : #Diya2DPrimShape,
	#instVars : [
		'rx',
		'ry',
		'delta'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'as yet unclassified' }
DiyaEllipse class >> rx: rx ry: ry [
	^self new rx: rx;
		ry: ry;
		yourself
]

{ #category : #'as yet unclassified' }
DiyaEllipse class >> rx: rx ry: ry shader: s [
	^self new rx: rx;
		ry: ry;
		shader: s;
		yourself
]

{ #category : #accessing }
DiyaEllipse >> delta [
	^ delta
]

{ #category : #accessing }
DiyaEllipse >> delta: anObject [
	delta := anObject
]

{ #category : #initialization }
DiyaEllipse >> drawLines [
	0 to: (vbuffer size >> 2) by: 3 do:[: i|
		self drawLineAt: i
	].
]

{ #category : #initialization }
DiyaEllipse >> initialize [
	super initialize.
	translation  := nil.
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size:4332.
	vbuffer autoRelease.
]

{ #category : #accessing }
DiyaEllipse >> rx [
	^ rx
]

{ #category : #accessing }
DiyaEllipse >> rx: anObject [
	rx := anObject.
	dirty := true.
]

{ #category : #accessing }
DiyaEllipse >> ry [
	^ ry
]

{ #category : #accessing }
DiyaEllipse >> ry: anObject [
	ry := anObject.
	dirty := true
]

{ #category : #accessing }
DiyaEllipse >> update [
	|theta c s x y index t|
	bbox := Rectangle origin: ((rx negated) @ (ry negated)) / 2.0 corner: (rx @ ry) / 2.0.
	theta := 2.0 * (Float pi) / 360.0.
	c := theta cos.
	s := theta sin.
	x := 1.
	y := 0.
	index := 1.
	0 to: 360 do:[:a|
		vbuffer
			at: index + 4 put: x * rx;
			at: index + 5 put: y * ry;
			at: index + 6 put: 0.0;
			at: index + 7 put: 0.0.
		t := x.
		x := (c * x) - (s * y).
      y := (s * t) + (c * y).
		vbuffer
			at: index  put: x*rx;
			at: index + 1 put: y*ry;
			at: index + 2 put: 0.0;
			at: index + 3 put: 0.0;
			
			at: index + 8 put: 0.0;
			at: index + 9 put: 0.0;
			at: index + 10 put: 0.0;
			at: index + 11 put: 0.0.
			index := index + 12.
	].
	^true
]
