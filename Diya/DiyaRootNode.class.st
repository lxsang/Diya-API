Class {
	#name : #DiyaRootNode,
	#superclass : #DiyaNode,
	#classVars : [
		'singleton'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'instance creation' }
DiyaRootNode class >> new [
	self error: 'Please use uniqueInstance'
]

{ #category : #'instance creation' }
DiyaRootNode class >> reset [
	singleton := nil
]

{ #category : #'instance creation' }
DiyaRootNode class >> uniqueInstance [
	singleton ifNil: [ singleton := super new].
	^singleton
]

{ #category : #initialization }
DiyaRootNode >> initialize [
	super initialize.
	parent := self.
]
