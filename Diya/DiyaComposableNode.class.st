Class {
	#name : #DiyaComposableNode,
	#superclass : #DiyaNode,
	#instVars : [
		'children'
	],
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaComposableNode >> addNode: node [
	^self addNode: node at: 0@0 
]

{ #category : #accessing }
DiyaComposableNode >> addNode: node at: pos [
	node parent: self.
	node position: pos.
	children add: node.
	^ node
]

{ #category : #accessing }
DiyaComposableNode >> children [
	^ children
]

{ #category : #initialization }
DiyaComposableNode >> initialize [
	super initialize.
	children := OrderedCollection new.
]

{ #category : #accessing }
DiyaComposableNode >> render [
	children do: [:c  | c render  ].
]
