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
Diya2DPrimShape >> borderWidth [
	^ self ? #border
]

{ #category : #accessing }
Diya2DPrimShape >> boundingBox [ 
	^ self tf localBoundsToGlobal: bbox.
]

{ #category : #initialization }
Diya2DPrimShape >> draw [
	vbuffer ifNil: [ ^self ].
	OpenGL
		enable: GL_CULL_FACE;
		enable: GL_BLEND;
		blendFnWithSfactor: GL_SRC_ALPHA dfactor: GL_ONE_MINUS_SRC_ALPHA.
	"configure vao vbo for texture QUAD"
	self texture ifNotNil: [
		self texture setup.
		context useTexture: self texture.	
	].
	context submitData: vbuffer.
	OpenGL drawArrays: type first:0  count:((vbuffer size )>> 2 ).
	"reset value"
	self texture ifNotNil: [self texture drop.].
	self borderWidth > 0 ifTrue: [ self drawBorder ].
	OpenGL
		disable: GL_CULL_FACE;
		disable: GL_BLEND.
]

{ #category : #initialization }
Diya2DPrimShape >> drawBorder [
	"Diya2DShader uniqueInstance use."
	shader setUniform: #u_color value: (self ? #borderColor)  asGL4FArray;
	setUniform: #u_texture_type value: 1.
	OpenGL
		lineWidth: self borderWidth.
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
	type := GL_TRIANGLES.
	bbox := Rectangle origin: 0@0 corner: 0@0.
]

{ #category : #accessing }
Diya2DPrimShape >> inner: aPoint [
	bbox ifNil: [ ^false ].
	^ bbox containsPoint: (self local: aPoint)
]

{ #category : #initialization }
Diya2DPrimShape >> setUpShader [
	super setUpShader.
	self shader
			setUniform: #u_color value: (self ? #color) asGL4FArray;
			setUniform: #u_bg_color value: (self ? #bgColor) asGL4FArray.
	self texture ifNotNil: [
			self shader
				setUniform: #u_texture value: self texture unit;
				setUniform: #u_texture_type value: self texture format.
		]
		ifNil:
		[
			self shader setUniform: #u_texture_type value: 0.
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

{ #category : #accessing }
Diya2DPrimShape >> textureNamed: name [
	self texture: (context assets texture: name)
]
