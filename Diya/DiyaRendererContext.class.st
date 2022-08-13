Class {
	#name : #DiyaRendererContext,
	#superclass : #DiyaSingleton,
	#instVars : [
		'mouse',
		'display',
		'vbo',
		'vao',
		'texture0',
		'projection',
		'assets',
		'window',
		'vbuffer',
		'voffset'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaRendererContext class >> bufferSize [
	^ 524288 "512Kb"
]

{ #category : #'instance creation' }
DiyaRendererContext class >> cleanUpInstance: singleton [
	singleton ifNil:[^self].
	singleton destroy
]

{ #category : #'instance creation' }
DiyaRendererContext class >> maxFloatBufferSize [
	^4096
]

{ #category : #accessing }
DiyaRendererContext >> assets [
	^ assets
]

{ #category : #accessing }
DiyaRendererContext >> assets: anObject [
	assets := anObject
]

{ #category : #accessing }
DiyaRendererContext >> destroy [
	self disableGLAttribute: 0.
	vbuffer free.
	vao delete.
	vbo delete.
	texture0 delete.
]

{ #category : #registration }
DiyaRendererContext >> disableGLAttribute: attribute [
	vao disableAttribute: attribute
]

{ #category : #accessing }
DiyaRendererContext >> display [
	^ display
]

{ #category : #accessing }
DiyaRendererContext >> display: anObject [
	display := anObject
]

{ #category : #registration }
DiyaRendererContext >> enableGLAttribute: attribute [
	vao enableAttribute: attribute.
]

{ #category : #accessing }
DiyaRendererContext >> initialize [
	super initialize.
	vbo := OpenGLVertexBuffer new.
	vao := OpenGLVertexArray new.
	texture0 := OpenGLTexture fromUnit: 0.
	vao bind.
	vbo bind: GL_ARRAY_BUFFER.
	projection := Array2D identity: 4.
	assets := AssetManager new.
	"allocate vbuffer"
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size: self class bufferSize.
	vbuffer autoRelease.
	voffset := 0.
	vbo data: GL_ARRAY_BUFFER data: vbuffer usage: GL_STREAM_DRAW.
	self enableGLAttribute: 0.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:4 type: GL_FLOAT normalized: GL_FALSE stride: 16 pointer: nil.
	
]

{ #category : #accessing }
DiyaRendererContext >> mouse [
	^ mouse
]

{ #category : #accessing }
DiyaRendererContext >> mouse: anObject [
	mouse := anObject
]

{ #category : #accessing }
DiyaRendererContext >> projection [
	^ projection
]

{ #category : #registration }
DiyaRendererContext >> resetBuffer [
	voffset := 0
]

{ #category : #accessing }
DiyaRendererContext >> resolution [
	^ (display w) @ (display h)
]

{ #category : #registration }
DiyaRendererContext >> setTexture: texture [
	texture setup.
	texture0 setImage2D: texture.
	texture0 active. 	
]

{ #category : #registration }
DiyaRendererContext >> submitData: data [
	|n|
	n := self voffset.
	voffset := voffset + (data size << 2).
	voffset > self class bufferSize ifTrue:[
		^ DiyaCoreAPIError signal: 'Out of video buffer memory'	
	].
	vbo subData: GL_ARRAY_BUFFER offset: n data: data.
	^ (n >> 4) 
	
]

{ #category : #accessing }
DiyaRendererContext >> texture0 [
	^ texture0
]

{ #category : #registration }
DiyaRendererContext >> useProjection: aClass [
	projection := aClass fromDisplay: self display
]

{ #category : #accessing }
DiyaRendererContext >> vao [
	^ vao
]

{ #category : #accessing }
DiyaRendererContext >> vbo [
	^ vbo
]

{ #category : #accessing }
DiyaRendererContext >> vbuffer [
	^ vbuffer
]

{ #category : #accessing }
DiyaRendererContext >> voffset [
	^ voffset
]

{ #category : #accessing }
DiyaRendererContext >> window [
	^ window
]

{ #category : #accessing }
DiyaRendererContext >> window: anObject [
	window := anObject
]
