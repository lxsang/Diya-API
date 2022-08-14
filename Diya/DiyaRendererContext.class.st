Class {
	#name : #DiyaRendererContext,
	#superclass : #DiyaSingleton,
	#instVars : [
		'mouse',
		'display',
		'vbo',
		'vao',
		'textures',
		'projection',
		'assets',
		'window',
		'root'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Graphics'
}

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
	vao disableAttribute: 0.
	vao delete.
	vbo delete.
	textures do: [:e | e key delete ].
	textures := OrderedCollection new.
]

{ #category : #accessing }
DiyaRendererContext >> display [
	^ display
]

{ #category : #accessing }
DiyaRendererContext >> display: anObject [
	display := anObject
]

{ #category : #rendering }
DiyaRendererContext >> findTextureUnit [
	textures withIndexDo: [ :e :i|
		e value ifNil: [ ^ i - 1]
	].
	"random unit value"
	^ (Random new nextInt: 32) - 1
]

{ #category : #accessing }
DiyaRendererContext >> initialize [
	super initialize.
	vbo := OpenGLVertexBuffer new.
	vao := OpenGLVertexArray new.
	textures := Dictionary new.
	vao bind.
	vbo bind: GL_ARRAY_BUFFER.
	projection := Array2D identity: 4.
	assets := AssetManager new.
	vao enableAttribute: 0.
	OpenGLVertexArray
		vertexAttributePointerIndex: 0
		size:4
		type: GL_FLOAT
		normalized: GL_FALSE
		stride: 16
		pointer: nil.
	textures :=
		(1 to: 32) collect:[:i|
			(OpenGLTexture fromUnit: i - 1) -> nil] .
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

{ #category : #rendering }
DiyaRendererContext >> render [
	root render.
	root readyForSwap ifTrue: [  
		SDL2 glSwapWindow: window.
	]
]

{ #category : #accessing }
DiyaRendererContext >> resolution [
	^ (display w) @ (display h)
]

{ #category : #accessing }
DiyaRendererContext >> root [
	root ifNil: [ root := DiyaRootNode new ].
	^ root



]

{ #category : #rendering }
DiyaRendererContext >> submitData: vbuffer [
	vbo data: GL_ARRAY_BUFFER data: vbuffer usage: GL_DYNAMIC_DRAW.
]

{ #category : #'transformation matrices' }
DiyaRendererContext >> useProjection: aClass [
	projection := aClass fromDisplay: self display
]

{ #category : #rendering }
DiyaRendererContext >> useTexture: aTexture [
	|assoc|
	aTexture unit == -1 ifTrue:[ aTexture unit: self findTextureUnit].
	assoc := textures at: aTexture unit + 1.
	assoc value = aTexture ifFalse:[
		"unregister current texture"
		assoc value ifNotNil: [ assoc value commited: false ].
		aTexture commited: false.
		assoc value: aTexture.
	].
	assoc key active.
	aTexture commited ifTrue:[ ^ self ].
	"self stdlog: 'Commit data data to texture ', aTexture name, ' on Unit ', aTexture unit asString."
	assoc key setImage2D: aTexture.
	aTexture commited: true.
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
DiyaRendererContext >> window [
	^ window
]

{ #category : #accessing }
DiyaRendererContext >> window: anObject [
	window := anObject
]
