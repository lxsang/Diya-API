Class {
	#name : #DiyaRenderer,
	#superclass : #DiyaSingleton,
	#instVars : [
		'root'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'instance creation' }
DiyaRenderer class >> fromContext: ctx [
	^self new context: ctx; yourself
]

{ #category : #initialization }
DiyaRenderer >> initialize [
	super initialize.
]

{ #category : #deleting }
DiyaRenderer >> render [ 
	root render. 
]

{ #category : #accessing }
DiyaRenderer >> root [
	^ root
]

{ #category : #accessing }
DiyaRenderer >> root: anObject [
	root := anObject
]
