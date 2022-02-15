Class {
	#name : #DiyaRenderer,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'context'
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

{ #category : #deleting }
DiyaRenderer >> destroy [ 
	^ self subclassResponsibility 
]

{ #category : #initialization }
DiyaRenderer >> initialize [
	super initialize.
	context := DiyaRendererContext uniqueInstance
]

{ #category : #deleting }
DiyaRenderer >> render [ 
	^ self subclassResponsibility 
]

{ #category : #deleting }
DiyaRenderer >> setup [ 
	^ self subclassResponsibility 
]
