Class {
	#name : #Diya2DPrimShape,
	#superclass : #Diya2DNode,
	#instVars : [
		'texture',
		'type',
		'bbox'
	],
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
Diya2DPrimShape >> border [
	^style get: #border
]

{ #category : #accessing }
Diya2DPrimShape >> borderColor [
	^style get: #borderColor
]

{ #category : #accessing }
Diya2DPrimShape >> borderColor: c [
	style set: #borderColor value: c.
]

{ #category : #accessing }
Diya2DPrimShape >> borderWidth: w [
	style set: #border value: w.
]

{ #category : #accessing }
Diya2DPrimShape >> boundingBox [ 
	^ bbox applyTf: self tf.
]

{ #category : #accessing }
Diya2DPrimShape >> color [
	self texture ifNotNil: [ ^ self style get: #color. ].
	^ self style get: #bgcolor.
]

{ #category : #accessing }
Diya2DPrimShape >> color: value [
	self texture ifNotNil: [ ^ self style set: #color value: value. ].
	^ self style set: #bgcolor value: value.
]

{ #category : #initialization }
Diya2DPrimShape >> draw [
	vbuffer ifNil: [ ^self ].
	"configure vao vbo for texture QUAD"
	self texture ifNotNil: [
		self texture setup.
		context texture0 setImage2D: self texture.
	context texture0 active. 	
	].
	context vao enableAttribute: 0.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:4 type: GL_FLOAT normalized: GL_FALSE stride: 16 pointer: nil .
	context vbo data: GL_ARRAY_BUFFER data: vbuffer usage: GL_STATIC_DRAW.
	OpenGL drawArrays: type first:0  count:((vbuffer size )>> 2 ).
	"reset value"
	self texture ifNotNil: [self texture drop.].
	self border > 0 ifTrue: [ self drawBorder ].
	context vao disableAttribute: 0.
]

{ #category : #initialization }
Diya2DPrimShape >> drawBorder [
	"Diya2DShader uniqueInstance use."
	shader setUniform: #u_color value: self borderColor  asGL4FArray;
	setUniform: #u_texture_type value: 0.
	OpenGL
		lineWidth: self border.
	self drawLines.
	OpenGL lineWidth: 1.0.
]

{ #category : #initialization }
Diya2DPrimShape >> drawLineAt: offset [
	OpenGL drawArrays: GL_LINES first:(offset)  count:2.
]

{ #category : #initialization }
Diya2DPrimShape >> drawLines [
	self subclassResponsibility 
]

{ #category : #accessing }
Diya2DPrimShape >> extent [
	^ bbox extent
]

{ #category : #initialization }
Diya2DPrimShape >> initialize [
	super initialize.
	texture := nil.
	children := nil.
	type := GL_TRIANGLES.
	bbox := Rectangle origin: 0@0 corner: 0@0.
]

{ #category : #'as yet unclassified' }
Diya2DPrimShape >> inner: aPoint [
	bbox ifNil: [ ^false ].
	^ bbox containsPoint: (self local: aPoint)
]

{ #category : #initialization }
Diya2DPrimShape >> setUpShader [
	super setUpShader.
	self shader
			setUniform: #u_color value: self color asGL4FArray;
			setUniform: #u_texture_type value:
				(self texture ifNil: [ 0 ] ifNotNil:[self texture format]).
]

{ #category : #accessing }
Diya2DPrimShape >> texture [
	^ texture
]

{ #category : #accessing }
Diya2DPrimShape >> texture: anObject [
	texture := anObject
]

{ #category : #accessing }
Diya2DPrimShape >> textureNamed: name [
	self texture: (context assets texture: name)
]
