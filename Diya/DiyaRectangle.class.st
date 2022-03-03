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
DiyaRectangle >> draw [
	self transformDo:[:i :e|
		context buffer at:i put:e
	].
	shader use.
	shader setUniform: #u_time value: DiyaClock uniqueInstance elapsedTime asFloat.
	shader setUniform: #u_projection value: context projection buffer.
	shader setUniform: #u_resolution value: { context resolution x. context resolution y }.
	context mouse ifNotNil: [
		"in shader, window origin is bottom left conor of the window
		the mouse position should be transformed to this coodinate"
		shader setUniform: #u_mouse value: { context mouse x. context resolution y - context mouse y }.
	].
	context vao enableAttribute: 0.
	context vbo bind: GL_ARRAY_BUFFER.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:3  type: GL_FLOAT normalized: GL_FALSE stride: 12 pointer: nil.
	context vbo subData: GL_ARRAY_BUFFER offset:0  data: context buffer.
	OpenGL drawArrays: GL_QUADS first:0  count: 4.
	context vao disableAttribute: 0.
]

{ #category : #accessing }
DiyaRectangle >> initialize [
	super initialize.
	self size:10@10.
	translation  := nil.
	children := nil
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
DiyaRectangle >> transformDo: block [
	|i|
	i := 1.
	(self gltf: { 0.0@0.0. 0.0@ (size y). size. (size x) @0. }) do:[:p|
			p   do: [ :e|
			block value:i value:e. i := i+1]].
]
