Class {
	#name : #DiyaApplicationModel,
	#superclass : #DiyaSingleton,
	#instVars : [
		'node',
		'am',
		'loader'
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
DiyaApplicationModel >> initLoader [
	self subclassResponsibility 
]

{ #category : #initialization }
DiyaApplicationModel >> initialize [ 
	super initialize.
	self initLoader.
]

{ #category : #accessing }
DiyaApplicationModel >> loader [ 
	^ loader
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
	self cleanup
]
