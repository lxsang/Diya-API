Class {
	#name : #DiyaMetaNode,
	#superclass : #DiyaNode,
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaMetaNode >> addNode: node at: pos [
	self shouldNotBeCalled
]

{ #category : #accessing }
DiyaMetaNode >> boundingBox [
	^ Rectangle origin: 0@0 extent: 0@0
]

{ #category : #rendering }
DiyaMetaNode >> draw [
	
]

{ #category : #accessing }
DiyaMetaNode >> extent [
	^  0@0
]

{ #category : #initialization }
DiyaMetaNode >> initialize [
		visibility := false.
]

{ #category : #testing }
DiyaMetaNode >> inner: aPoint [
	^ false
]

{ #category : #processing }
DiyaMetaNode >> process [
	
]

{ #category : #processing }
DiyaMetaNode >> updateTF [
	
]
