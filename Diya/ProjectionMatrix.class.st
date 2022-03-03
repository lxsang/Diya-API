Class {
	#name : #ProjectionMatrix,
	#superclass : #Array2D,
	#instVars : [
		'buffer'
	],
	#category : #'Diya-Math'
}

{ #category : #'instance creation' }
ProjectionMatrix class >> fromDisplay: display [
	^self subclassResponsibility
]

{ #category : #accessing }
ProjectionMatrix >> buffer [
	^ buffer
]

{ #category : #initialization }
ProjectionMatrix >> calculate [
	self subclassResponsibility
]

{ #category : #initialization }
ProjectionMatrix >> default [

]

{ #category : #initialization }
ProjectionMatrix >> handle [
	^buffer getHandle
]

{ #category : #initialization }
ProjectionMatrix >> initialize [
	super initialize.
	self rows:4  columns: 4 contents: ((Array new: 16) atAllPut: 0).
	1 to: 4 do: [ :i| self at: i at:i put: 1.0 ].
	buffer := FFIExternalArray externalNewType: #float size: self size.
	buffer autoRelease.
	self default.
	self update
]

{ #category : #initialization }
ProjectionMatrix >> update [
	|i|
	self calculate.
	i := 1.
	self asArray do:[:e|
		buffer at:i put:e.
		i := i+1
	].
]
