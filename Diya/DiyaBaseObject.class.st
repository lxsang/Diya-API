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

{ #category : #asserting }
DiyaBaseObject >> shouldNotBeCalled [
	^DiyaCoreAPIError signal: 'Should not be called'
]

{ #category : #accessing }
DiyaBaseObject >> stderr [
	^VTermOutputDriver stderr
]

{ #category : #accessing }
DiyaBaseObject >> stderror: string [
	self stderr
		nextPutAll: DateAndTime now asString;
		nextPutAll: ': ';
		nextPutAll: string;
		nextPutAll: Character cr asString.
]

{ #category : #accessing }
DiyaBaseObject >> stdlog: string [
	self stdout
			nextPutAll: DateAndTime now asString;
			nextPutAll: ': ';
			nextPutAll: string;
			nextPutAll: Character cr asString.
]

{ #category : #accessing }
DiyaBaseObject >> stdout [
	^ VTermOutputDriver stdout
]
