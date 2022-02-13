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
	shader delete.
	GLSimpleShader reset.
]

{ #category : #initialization }
SimpleDiyaRenderer >> initialize [ 
	vertexBuffer := OpenGLVertexBuffer new.
	arrayBuffer := OpenGLVertexArray new.
	bufferData := FFIExternalArray externalNewType: GLfloat size: 9.
	bufferData autoRelease.
	shader := GLSimpleShader uniqueInstance.
	
]

{ #category : #deleting }
SimpleDiyaRenderer >> render [ 
	OpenGL clearColorR: 1.0 G: 0  B: 1.0  A:0.
	OpenGL clear: GL_COLOR_BUFFER_BIT.
	shader use.
	arrayBuffer enableAttribute: 0.
	vertexBuffer bind: GL_ARRAY_BUFFER.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:3  type: GL_FLOAT normalized: GL_FALSE stride: 0 pointer: nil .
	OpenGL drawArrays: GL_TRIANGLES first:0  count: 3.
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
		at: 7 put: 0;
		at: 8 put: 1.0;
		at: 9 put: 0.
	arrayBuffer 	bind.
	vertexBuffer bind: GL_ARRAY_BUFFER.
	vertexBuffer data: GL_ARRAY_BUFFER data:bufferData  usage: GL_STATIC_DRAW.
	shader compile.
]
