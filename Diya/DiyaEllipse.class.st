Class {
	#name : #DiyaEllipse,
	#superclass : #Diya2DPrimShape,
	#instVars : [
		'rx',
		'ry'
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

{ #category : #initialization }
DiyaEllipse >> draw [
	OpenGL
		enable: GL_BLEND;
		blendFnWithSfactor: GL_SRC_ALPHA dfactor: GL_ONE_MINUS_SRC_ALPHA.
	super draw.
	OpenGL
		disable: GL_BLEND
]

{ #category : #initialization }
DiyaEllipse >> drawBorder [
	"do nothing"
]

{ #category : #initialization }
DiyaEllipse >> drawLines [
	self shouldNotBeCalled 
]

{ #category : #initialization }
DiyaEllipse >> initialize [
	super initialize.
	translation  := nil.
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size: 24.
	vbuffer autoRelease.
	shader := DiyaEllipseShader uniqueInstance.
]

{ #category : #initialization }
DiyaEllipse >> inner: aPoint [
	|dxy|
	dxy  := self local: aPoint.
	^ ((((dxy x) ** 2)/(rx**2)) + (((dxy y) ** 2) / (ry**2))) < 1.
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

{ #category : #initialization }
DiyaEllipse >> setUpShader [
	super setUpShader.
	self shader
		setUniform: #u_border value: border;
		setUniform: #u_border_color value: bcolor asGL4FArray;
		setUniform: #u_rx value: rx;
		setUniform: #u_ry value: ry.
]

{ #category : #accessing }
DiyaEllipse >> update [
	bbox := Rectangle origin: ((rx negated) @ (ry negated)) corner: (rx @ ry).
	{
		bbox origin x. bbox corner y. 0.0. 0.0.            
      bbox origin x. bbox origin y. 0.0. 1.0.
      bbox corner x. bbox origin y. 1.0. 1.0.

		bbox corner x. bbox origin y. 1.0. 1.0.
		bbox corner x. bbox corner y. 1.0. 0.0.
		bbox origin x. bbox corner y. 0.0. 0.0.      
	} doWithIndex: [:e :i| vbuffer at: i put: e].
	^true
]
