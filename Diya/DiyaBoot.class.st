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
	self startx.
]

{ #category : #'system startup' }
DiyaBoot class >> startx [
	DiyaInit uniqueInstance eventLoop
]
