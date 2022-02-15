Class {
	#name : #DiyaRendererContext,
	#superclass : #DiyaSingleton,
	#instVars : [
		'mouse',
		'display'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaRendererContext >> display [
	^ display
]

{ #category : #accessing }
DiyaRendererContext >> display: anObject [
	display := anObject
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
