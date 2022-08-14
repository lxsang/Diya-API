Class {
	#name : #DiyaClock,
	#superclass : #DiyaSingleton,
	#instVars : [
		'monotonic',
		'lastTick',
		'lapTime'
	],
	#category : #'Diya-Runtime'
}

{ #category : #initialization }
DiyaClock >> delta [
	 ^ self lapDelta + self lapTime
]

{ #category : #initialization }
DiyaClock >> elapsedTime [
 ^(DateAndTime now) - monotonic 
]

{ #category : #initialization }
DiyaClock >> initialize [
	monotonic := DateAndTime now.
	lastTick := monotonic.
	lapTime := 0.
]

{ #category : #initialization }
DiyaClock >> lapDelta [
	 ^ ((DateAndTime now) - lastTick) asMilliSeconds
]

{ #category : #initialization }
DiyaClock >> lapTime [
	^ lapTime
]

{ #category : #initialization }
DiyaClock >> tick [
	lapTime := self lapDelta.
	lastTick := DateAndTime now.
]
