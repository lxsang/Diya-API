Class {
	#name : #DiyaRenderer,
	#superclass : #DiyaBaseObject,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Graphics'
}

{ #category : #deleting }
DiyaRenderer >> destroy [ 
	^ self subclassResponsibility 
]

{ #category : #deleting }
DiyaRenderer >> render [ 
	^ self subclassResponsibility 
]

{ #category : #deleting }
DiyaRenderer >> setup [ 
	^ self subclassResponsibility 
]
