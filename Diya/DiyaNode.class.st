Class {
	#name : #DiyaNode,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'translation',
		'parent',
		'scale',
		'rotation',
		'tf',
		'shader',
		'context'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'instance creation' }
DiyaNode class >> with: shader [
	^self new shader: shader; yourself
]

{ #category : #initialization }
DiyaNode >> initialize [
	super initialize.
	parent := nil.
	shader := DiyaDefaultShader uniqueInstance.
	context := DiyaRendererContext uniqueInstance.
]

{ #category : #testing }
DiyaNode >> isRoot [
	^false
]

{ #category : #accessing }
DiyaNode >> parent [
	^ parent
]

{ #category : #accessing }
DiyaNode >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
DiyaNode >> position [
	^ translation
]

{ #category : #accessing }
DiyaNode >> position: anObject [
	translation := anObject.
	self updateTF.
]

{ #category : #accessing }
DiyaNode >> render [
	^self subclassResponsibility 
]

{ #category : #accessing }
DiyaNode >> rotation [
	^ rotation
]

{ #category : #accessing }
DiyaNode >> rotation: anObject [
	rotation := anObject.
	self updateTF.
]

{ #category : #accessing }
DiyaNode >> scale [
	^ scale
]

{ #category : #accessing }
DiyaNode >> scale: anObject [
	scale := anObject.
	self updateTF.
]

{ #category : #accessing }
DiyaNode >> shader [
	^ shader
]

{ #category : #accessing }
DiyaNode >> shader: anObject [
	shader := anObject
]

{ #category : #accessing }
DiyaNode >> tf [
	parent ifNil: [ self error: 'TF: This node is not attached to the main tree' ].
	^ tf
]

{ #category : #accessing }
DiyaNode >> updateTF [
	self subclassResponsibility 
]
