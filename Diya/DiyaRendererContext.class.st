Class {
	#name : #DiyaRendererContext,
	#superclass : #DiyaSingleton,
	#instVars : [
		'mouse',
		'display',
		'vbo',
		'vao'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'instance creation' }
DiyaRendererContext class >> cleanUpInstance: singleton [
	singleton destroy
]

{ #category : #accessing }
DiyaRendererContext >> destroy [ 
	vao delete.
	vbo delete.
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
	vao bind.
	vbo bind: GL_ARRAY_BUFFER.
]

{ #category : #accessing }
DiyaRendererContext >> mouse [
	^ mouse
]

{ #category : #accessing }
DiyaRendererContext >> mouse: anObject [
	mouse := anObject
]

{ #category : #'as yet unclassified' }
DiyaRendererContext >> resolution [
	^ (display w) @ (display h)
]

{ #category : #accessing }
DiyaRendererContext >> vao [
	^ vao
]

{ #category : #accessing }
DiyaRendererContext >> vbo [
	^ vbo
]
