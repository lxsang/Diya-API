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

{ #category : #initialization }
DiyaLine >> draw [
	shader setUniform: #u_texture_type value: 1.
	OpenGL
		"enable: GL_LINE_SMOOTH;
		hint: GL_LINE_SMOOTH_HINT mode: GL_NICEST;"
		lineWidth: self borderWidth.
	super draw.
	OpenGL lineWidth: 1.0";
		disable: GL_LINE_SMOOTH".
]

{ #category : #initialization }
DiyaLine >> drawBorder [
	"do nothing"
]

{ #category : #initialization }
DiyaLine >> drawLines [
	self shouldNotBeCalled
]

{ #category : #accessing }
DiyaLine >> from [
	^ from
]

{ #category : #accessing }
DiyaLine >> from: anObject [
	from := anObject.
	self setDirty
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
]

{ #category : #accessing }
DiyaLine >> inner: aPoint [
		^false
]

{ #category : #accessing }
DiyaLine >> process [
	|extent|
	bbox := (Rectangle origin: from corner: to ).
	self position: bbox origin.
	extent := bbox extent.
	bbox := (Rectangle origin: 0@0 corner:  extent ).
	vbuffer
		at: 1  put: 0.0;
		at: 2  put: 0.0;
		at: 3  put: 0.0;
		at: 4  put: 0.0;
		
		at: 5  put: extent x asFloat;
		at: 6  put: extent y asFloat;
		at: 7  put: 0.0;
		at: 8  put: 0.0.
	^true
]

{ #category : #accessing }
DiyaLine >> to [
	^ to
]

{ #category : #accessing }
DiyaLine >> to: anObject [
	to := anObject.
	self setDirty
]
