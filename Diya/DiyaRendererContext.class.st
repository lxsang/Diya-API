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
		'assets'
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
	vao delete.
	vbo delete.
	texture0 delete.
]

{ #category : #accessing }
DiyaRendererContext >> display [
	^ display
]

{ #category : #accessing }
DiyaRendererContext >> display: anObject [
	display := anObject
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

{ #category : #'as yet unclassified' }
DiyaRendererContext >> resolution [
	^ (display w) @ (display h)
]

{ #category : #accessing }
DiyaRendererContext >> texture0 [
	^ texture0
]

{ #category : #'as yet unclassified' }
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
