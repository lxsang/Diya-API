Class {
	#name : #DiyaStyle,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'parent',
		'style'
	],
	#category : #'Diya-UIThemes'
}

{ #category : #accessing }
DiyaStyle >> at: name ifAbsent: aBlock [
	|value|
	value := style at: name ifAbsent:[nil].
	value ifNotNil: [ ^value ].
	parent ifNil: [ ^aBlock value ].
	^ parent at:name ifAbsent: aBlock.
]

{ #category : #accessing }
DiyaStyle >> at: name put: value [
	style at: name put: value
]

{ #category : #initialization }
DiyaStyle >> initialize [ 
	super initialize.
	style := Dictionary new.
	parent := nil
	
]

{ #category : #accessing }
DiyaStyle >> parent [
	^ parent
]

{ #category : #accessing }
DiyaStyle >> parent: anObject [
	parent := anObject
]
