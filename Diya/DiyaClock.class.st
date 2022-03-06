Class {
	#name : #DiyaClock,
	#superclass : #DiyaSingleton,
	#instVars : [
		'monotonic',
		'lastTick'
	],
	#category : #'Diya-Runtime'
}

{ #category : #initialization }
DiyaClock >> delta [
	 ^(DateAndTime now) - lastTick 
]

{ #category : #initialization }
DiyaClock >> elapsedTime [
 ^(DateAndTime now) - monotonic 
]

{ #category : #initialization }
DiyaClock >> initialize [
	monotonic := DateAndTime now.
	lastTick := monotonic.
]

{ #category : #initialization }
DiyaClock >> tick [
	lastTick := DateAndTime now.
]
