Class {
	#name : #DiyaClock,
	#superclass : #DiyaSingleton,
	#instVars : [
		'monotonic'
	],
	#category : #'Diya-Runtime'
}

{ #category : #initialization }
DiyaClock >> elapsedTime [
 ^(DateAndTime now) - monotonic 
]

{ #category : #initialization }
DiyaClock >> initialize [
	monotonic := DateAndTime now.
]
