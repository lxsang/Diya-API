Class {
	#name : #DiyaTimerNode,
	#superclass : #DiyaMetaNode,
	#instVars : [
		'timeout',
		'elapsedTime',
		'handlers'
	],
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaTimerNode class >> timeout: ms [
	^ self new timeout: ms; yourself
]

{ #category : #accessing }
DiyaTimerNode class >> timeout: ms do: aBlock [
	^ (self timeout: ms) onTimeout: aBlock;yourself
]

{ #category : #accessing }
DiyaTimerNode class >> timeout: ms doOnce: aBlock [
	^ (self timeout: ms) onceTimeout:  aBlock;yourself
]

{ #category : #accessing }
DiyaTimerNode >> delta [
	^ DiyaClock uniqueInstance delta asMilliSeconds
]

{ #category : #accessing }
DiyaTimerNode >> initialize [
	super initialize.
	elapsedTime := 0.
	handlers := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
DiyaTimerNode >> onTimeout: aBlock [
	handlers add: aBlock
]

{ #category : #'as yet unclassified' }
DiyaTimerNode >> onceTimeout: aBlock [
	|newBlock|
	handlers := OrderedCollection new.
	newBlock := [ :node | aBlock value: node. self remove ].
	handlers add: newBlock
]

{ #category : #stepping }
DiyaTimerNode >> step [
	elapsedTime := elapsedTime + self delta.
	elapsedTime >= timeout ifFalse:[^ self].
	handlers do:[:e| e value: self ].
	elapsedTime := 0
]

{ #category : #accessing }
DiyaTimerNode >> timeout [
	^ timeout
]

{ #category : #accessing }
DiyaTimerNode >> timeout: anObject [
	timeout := anObject
]
