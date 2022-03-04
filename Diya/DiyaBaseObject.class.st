Class {
	#name : #DiyaBaseObject,
	#superclass : #Object,
	#category : #'Diya-Core'
}

{ #category : #accessing }
DiyaBaseObject >> checkGLError: mark [
	|err|
	err := OpenGL getError.
	err = 0 ifFalse:[
		self stderror:mark, ': return error code ', err hex.
	].
]

{ #category : #accessing }
DiyaBaseObject >> logError: string [
	self stderr nextPutAll: string; cr
]

{ #category : #accessing }
DiyaBaseObject >> stderr [
	^VTermOutputDriver stderr
]

{ #category : #accessing }
DiyaBaseObject >> stderror: string [
	self stderr nextPutAll: string; nextPutAll: Character cr asString.
]

{ #category : #accessing }
DiyaBaseObject >> stdlog: string [
	self stdout nextPutAll: string;
			nextPutAll: Character cr asString.
]

{ #category : #accessing }
DiyaBaseObject >> stdout [
	^ VTermOutputDriver stdout
]
