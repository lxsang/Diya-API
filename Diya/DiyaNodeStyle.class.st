Class {
	#name : #DiyaNodeStyle,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'styles',
		'parent'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'as yet unclassified' }
DiyaNodeStyle class >> inherit: parent [
	^self new parent: parent; yourself
]

{ #category : #initialization }
DiyaNodeStyle >> get: styleName [
	^ styles at: styleName ifAbsent: [ parent ifNotNil: [ parent get: styleName ] ifNil: nil]
]

{ #category : #initialization }
DiyaNodeStyle >> initialize [ 
	super initialize.
	styles := Dictionary new.
	parent := nil.
	"self set: #bgcolor value: Color transparent.
	self set: #color value:Color white.
	self set: #border value: 0.
	self set: #borderColor value: Color transparent."
]

{ #category : #accessing }
DiyaNodeStyle >> parent [
	^ parent
]

{ #category : #accessing }
DiyaNodeStyle >> parent: anObject [
	parent := anObject
]

{ #category : #initialization }
DiyaNodeStyle >> set: styleName value: value [
	styles at: styleName put: value
]
