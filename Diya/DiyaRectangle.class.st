Class {
	#name : #DiyaRectangle,
	#superclass : #Diya2DNode,
	#instVars : [
		'size'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'as yet unclassified' }
DiyaRectangle class >> size: s [
	^(self new) size:s; yourself
]

{ #category : #'as yet unclassified' }
DiyaRectangle class >> size: size shader:s [
	^(self with:s) size: size; yourself
]

{ #category : #accessing }
DiyaRectangle >> initialize [
	super initialize.
	self size:10@10.
]

{ #category : #accessing }
DiyaRectangle >> render [
	|buffer|
	buffer := FFIExternalArray externalNewType: GLfloat size: 12.
	self transformDo:[:i :e|
		buffer at:i put:e
	].
	context vbo bind: GL_ARRAY_BUFFER.
	context vbo data: GL_ARRAY_BUFFER data:buffer usage: GL_STATIC_DRAW.
	shader use.
	shader setUniform: #u_time value: DiyaClock uniqueInstance elapsedTime asFloat.
	shader setUniform: #u_resolution value: { context resolution x. context resolution y }.
	context mouse ifNotNil: [
		"in shader, window origin is bottom left conor of the window
		the mouse position should be transformed to this coodinate"
		shader setUniform: #u_mouse value: { context mouse x. context resolution y - context mouse y }.
	].
	context vao enableAttribute: 0.
	context vbo bind: GL_ARRAY_BUFFER.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:3  type: GL_FLOAT normalized: GL_FALSE stride: 0 pointer: nil .
	OpenGL drawArrays: GL_QUADS first:0  count: 4.
	context vao disableAttribute: 0.
	buffer free.
]

{ #category : #accessing }
DiyaRectangle >> size [
	^ size
]

{ #category : #accessing }
DiyaRectangle >> size: anObject [
	size := anObject.
]

{ #category : #accessing }
DiyaRectangle >> transform [
	|origin topleft topright bottomright|
	origin := (self tf +* #(0.0 0.0 1.0)) asPoint asGLCoord.
	topleft := (self tf +* { 0.0. size y.1.0 }) asPoint asGLCoord.
	topright := (self tf +* { size x. size y.1.0 }) asPoint asGLCoord.
	bottomright := (self tf +* { size x. 0.0. 1.0 }) asPoint asGLCoord.
	^
	{ 
		origin x. origin y. 0.0.
		topleft x. topleft y. 0.0.
		topright x. topright y. 0.0.
		bottomright x. bottomright y. 0.0.
	}
]

{ #category : #accessing }
DiyaRectangle >> transformDo: block [
	|i|
	i := 1.
	self transform do:[:e| block value:i value:e. i := i+1].
]
