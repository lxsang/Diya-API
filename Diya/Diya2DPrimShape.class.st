Class {
	#name : #Diya2DPrimShape,
	#superclass : #Diya2DNode,
	#instVars : [
		'texture'
	],
	#category : #'Diya-Graphics'
}

{ #category : #initialization }
Diya2DPrimShape >> draw [
	vbuffer ifNil: [ ^self ].
	self shader
		setUniform: #u_use_texture value:1.
	"configure vao vbo for texture QUAD"
	self texture ifNotNil: [
		self texture setup.
	context texture0 setImage2D: self texture.
	context texture0 active. 	
	].
	context vao enableAttribute: 0.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:4 type: GL_FLOAT normalized: GL_FALSE stride: 16 pointer: nil .
	context vbo data: GL_ARRAY_BUFFER data: vbuffer usage: GL_STATIC_DRAW.
	OpenGL drawArrays: GL_TRIANGLES first:0  count:nvertices.
	context vao disableAttribute: 0.
	"reset value"
	self texture ifNotNil: [self texture drop.].
]

{ #category : #initialization }
Diya2DPrimShape >> initialize [
	super initialize.
	texture := nil.
	children := nil
]

{ #category : #initialization }
Diya2DPrimShape >> setUpShader [
	super setUpShader.
	texture ifNotNil: [
		self shader
			setUniform: #u_use_texture value:1.
	].
]

{ #category : #accessing }
Diya2DPrimShape >> texture [
	^ texture
]

{ #category : #accessing }
Diya2DPrimShape >> texture: anObject [
	texture := anObject
]
