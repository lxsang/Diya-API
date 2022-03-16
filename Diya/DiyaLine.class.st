Class {
	#name : #DiyaLine,
	#superclass : #Diya2DPrimShape,
	#instVars : [
		'from',
		'to'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'instance creation' }
DiyaLine class >> from: p1 to: p2 [
	^ self new 
			from: p1;
			to: p2;
			yourself
]

{ #category : #'instance creation' }
DiyaLine class >> from: p1 to: p2 shader:s [
	^ self new 
			from: p1;
			to: p2;
			shader: s;
			yourself
]

{ #category : #'instance creation' }
DiyaLine class >> points: points [
	^ self new
			points: points;
			yourself
]

{ #category : #accessing }
DiyaLine >> borderColor: c [
	color := c
]

{ #category : #initialization }
DiyaLine >> draw [
	OpenGL
		"enable: GL_LINE_SMOOTH;
		hint: GL_LINE_SMOOTH_HINT mode: GL_NICEST;"
		lineWidth: border.
	super draw.
	OpenGL lineWidth: 1.0";
		disable: GL_LINE_SMOOTH".
]

{ #category : #initialization }
DiyaLine >> drawBorder [
	"do nothing"
]

{ #category : #accessing }
DiyaLine >> from [
	^ from
]

{ #category : #accessing }
DiyaLine >> from: anObject [
	from := anObject.
	dirty := true.
]

{ #category : #initialization }
DiyaLine >> initialize [
	super initialize.
	translation  := nil.
	self from: 0@0.
	self to: 10@10.
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size:8.
	vbuffer autoRelease.
	type := GL_LINES.
	border := 1.0
]

{ #category : #accessing }
DiyaLine >> to [
	^ to
]

{ #category : #accessing }
DiyaLine >> to: anObject [
	to := anObject.
	dirty := true.
]

{ #category : #accessing }
DiyaLine >> update [
	|extent|
	translation = from ifFalse:[self position: from].
	bbox := (Rectangle origin: 0@0 corner: to - from ).
	extent := bbox extent.
	{
		0.0. 0.0. 0.0. 0.0.            
      extent x. extent y. 0.0. 0.0.
	} doWithIndex: [:e :i| vbuffer at: i put: e].
	^true
]
