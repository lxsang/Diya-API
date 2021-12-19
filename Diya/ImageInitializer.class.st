Class {
	#name : #ImageInitializer,
	#superclass : #CommandLineHandler,
	#category : #'Diya-Runtime'
}

{ #category : #accessing }
ImageInitializer class >> commandName [
	^'init'
]

{ #category : #activation }
ImageInitializer >> activate [
	self initializeImage.
	(self hasOption: 'save')
		ifTrue: [
			self snap
		].
	^ self exitSuccess
]

{ #category : #'init-image' }
ImageInitializer >> getInitListExclude: loaded [
	^ Smalltalk allClasses
		select: [ :c | 
			(loaded includes: c) not
				and: (c class selectors indexOf: #initialize ifAbsent: [  ]) isNotNil ]
]

{ #category : #'init-image' }
ImageInitializer >> getLoadedClasses [
	| list |
	list := (SessionManager default startupList
		collect: [ :c | 
			(c respondsTo: #registeredClass)
				ifTrue: [ c registeredClass ]
				ifFalse: [ c ] ]) asSet.
	list add: SourceFileArray.
	list add: FFICompilerPlugin.
	^ list
]

{ #category : #'init-image' }
ImageInitializer >> initializeImage [
	| initializeList retryList loaded |
	retryList := Set new.
	loaded := self getLoadedClasses.
	self preloadSystem: loaded.
	initializeList := self getInitListExclude: loaded.
	initializeList
		do: [ :c | 
			[ c initialize ]
				on: Error
				do: [ c = Cursor
						ifFalse: [ retryList add: c ] ] ].
	retryList
		do: [ :c | 
			Transcript
				show: 'CLASS: ' , c asString , ' is not initialized';
				cr.
			c initialize ].
	FFIMethodRegistry resetAll.
	Smalltalk garbageCollect.
	SourceFiles := SourceFileArray new.
	Transcript show: 'Image initialized'; cr.
]

{ #category : #'init-image' }
ImageInitializer >> preloadSystem: loaded [
	"load unicode"
	|udata ucase base|
	base := Smalltalk imageDirectory  pathString.
	udata := base,'/UnicodeData.txt'.
	ucase := base,'/CaseFolding-8.0.0.txt'.
	loaded add: (TextConstants initialize; yourself ).
	loaded add: (InflateStream  initialize; yourself ).
	loaded add: (FastInflateStream  initialize; yourself ).
	EncodedCharSet initialize.
	Unicode initializeTagConstants.
	Unicode 
		parseUnicodeDataFrom: (ZnCharacterReadStream on: (File named: udata ) readStream encoding: 	'utf8');
		parseCaseMappingFrom: (ZnCharacterReadStream on: (File named: ucase ) readStream encoding: 'utf8'). 
	Character characterSet: Unicode.
	ByteTextConverter initialize.
	CombinedChar parseCompositionMappingFrom: (ZnCharacterReadStream on: (File named: udata ) readStream encoding: 'utf8').
]

{ #category : #activation }
ImageInitializer >> snap [
	Smalltalk globals at: #CODENAME put: 'diya'.
	Smalltalk globals at: #VERSION put: '0.1.0'.
	self class removeFromSystem.
	Smalltalk addToStartUpList: DiyaBoot.
	Smalltalk garbageCollect.
	Smalltalk snapshot: true andQuit: true.
	
]
