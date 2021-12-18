Class {
	#name : #DiyaBoot,
	#superclass : #DiyaBaseObject,
	#category : #'Diya-Runtime'
}

{ #category : #'system startup' }
DiyaBoot class >> getLoadedClasses [
	^ SessionManager default startupList
		collect: [ :c | 
			(c respondsTo: #registeredClass)
				ifTrue: [ c registeredClass ]
				ifFalse: [ c ] ]
]

{ #category : #'class initialization' }
DiyaBoot class >> initialize [
	Smalltalk addToStartUpList: DiyaBoot 
]

{ #category : #'system startup' }
DiyaBoot class >> startUp: status [
	"
	As is the entry point for Diya, it need to be disabled
	when inside the SDK image.
	"
	((Smalltalk globals at:#codeName ifAbsent:[nil]) = 'diya') ifFalse: [^self].
	self getLoadedClasses
		do: [ :c | 
			Transcript
				show: c className;
				cr ].
	Transcript show: self tickSinceStart; cr.
]

{ #category : #'system startup' }
DiyaBoot class >> tickSinceStart [
	^ self ffiCall: #( uint clock() ) module: 'libc.so.6'.
]
