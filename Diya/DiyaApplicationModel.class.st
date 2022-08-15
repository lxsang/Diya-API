Class {
	#name : #DiyaApplicationModel,
	#superclass : #DiyaSingleton,
	#instVars : [
		'node',
		'am',
		'target',
		'context'
	],
	#category : #'Diya-Applications'
}

{ #category : #accessing }
DiyaApplicationModel >> am [
	^ am
]

{ #category : #accessing }
DiyaApplicationModel >> cleanup [
	self subclassResponsibility 
]

{ #category : #accessing }
DiyaApplicationModel >> context [
	^DiyaRenderer
]

{ #category : #initialization }
DiyaApplicationModel >> initialize [ 
	super initialize.
	context := DiyaRenderer
]

{ #category : #'as yet unclassified' }
DiyaApplicationModel >> loadNode [
	|pseudoRoot|
	pseudoRoot := DiyaRootNode new.
	pseudoRoot addNode: node.
	pseudoRoot processQueue do:[:el|
		el process
	].
]

{ #category : #accessing }
DiyaApplicationModel >> node [
	^ node
]

{ #category : #accessing }
DiyaApplicationModel >> onloaded: aBlock [
	self subclassResponsibility 
]

{ #category : #accessing }
DiyaApplicationModel >> quit [
	node empty.
	self cleanup
]

{ #category : #initialization }
DiyaApplicationModel >> target: aNode [
	target := aNode.
]
