Class {
	#name : #DiyaNode,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'translation',
		'parent',
		'children',
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

{ #category : #accessing }
DiyaNode >> addNode: node [
	^self addNode: node at: 0@0 
]

{ #category : #accessing }
DiyaNode >> addNode: node at: pos [
	children ifNil: [ ^self ].
	node parent: self.
	node position: pos.
	children add: node.
	^ node
]

{ #category : #accessing }
DiyaNode >> boundingBox [
	^ self subclassResponsibility 
]

{ #category : #accessing }
DiyaNode >> children [
	^children
]

{ #category : #accessing }
DiyaNode >> draw [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
DiyaNode >> gltf: points [
	^self subclassResponsibility 
]

{ #category : #initialization }
DiyaNode >> initialize [
	super initialize.
	parent := nil.
	shader := nil.
	context := DiyaRendererContext uniqueInstance.
	children := OrderedCollection new.
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
	self draw.
	children ifNil: [ ^self ].
	children do: [:c  | c render  ]. 
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
	shader ifNil: [ 
		parent ifNil: [ ^nil ].
		^parent shader ].
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
