Class {
	#name : #SimpleDiyaRenderer,
	#superclass : #DiyaRenderer,
	#instVars : [
		'vertexBuffer',
		'arrayBuffer',
		'bufferData',
		'shader'
	],
	#category : #'Diya-Graphics'
}

{ #category : #deleting }
SimpleDiyaRenderer >> destroy [ 
	vertexBuffer delete.
	arrayBuffer delete.
	GLSimpleShader reset.
]

{ #category : #initialization }
SimpleDiyaRenderer >> initialize [
	super initialize.
	vertexBuffer := OpenGLVertexBuffer new.
	arrayBuffer := OpenGLVertexArray new.
	bufferData := FFIExternalArray externalNewType: GLfloat size: 12.
	bufferData autoRelease.
	shader := GLSimpleShader uniqueInstance.
	
]

{ #category : #deleting }
SimpleDiyaRenderer >> render [ 
	OpenGL clearColorR: 1.0 G: 0  B: 1.0  A:0.
	OpenGL clear: GL_COLOR_BUFFER_BIT.
	shader use.
	shader setUniform: #u_time value: DiyaClock uniqueInstance elapsedTime asFloat.
	shader setUniform: #u_resolution value: { context resolution x. context resolution y }.
	context mouse ifNotNil: [
		"in shader, window origin is bottom left conor of the window
		the mouse position should be transformed to this coodinate"
		shader setUniform: #u_mouse value: { context mouse x. context resolution y - context mouse y }.
	].
 
	arrayBuffer enableAttribute: 0.
	vertexBuffer bind: GL_ARRAY_BUFFER.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:3  type: GL_FLOAT normalized: GL_FALSE stride: 0 pointer: nil .
	OpenGL drawArrays: GL_QUADS first:0  count: 4.
	arrayBuffer disableAttribute: 0.
]

{ #category : #deleting }
SimpleDiyaRenderer >> setup [ 
bufferData
		at: 1 put: -1.0;
		at: 2 put: -1.0;
		at: 3 put: 0;
		at: 4 put: 1.0;
		at: 5 put: -1.0;
		at: 6 put: 0;
		at: 7 put: 1.0;
		at: 8 put: 1.0;
		at: 9 put: 0;
		at: 10 put: -1.0;
		at: 11 put: 1.0;
		at: 12 put: 0.
	arrayBuffer 	bind.
	vertexBuffer bind: GL_ARRAY_BUFFER.
	vertexBuffer data: GL_ARRAY_BUFFER data:bufferData  usage: GL_STATIC_DRAW.
]
