Class {
	#name : #DiyaNode,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'translation',
		'parent',
		'children',
		'scale',
		'rotation',
		'tf',
		'shader',
		'context',
		'dirty',
		'ehandlers',
		'root',
		'style'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes',
		'SDL2Constants'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'instance creation' }
DiyaNode class >> with: shader [
	^self new shader: shader; yourself
]

{ #category : #accessing }
DiyaNode >> addNode: node [
	^self addNode: node at: 0@0 
]

{ #category : #accessing }
DiyaNode >> addNode: node at: pos [
	children ifNil: [ ^self ].
	node parent: self.
	node position: pos.
	children add: node.
	node root: self root.
	node style parent: style.
	^ node
]

{ #category : #accessing }
DiyaNode >> boundingBox [
	^ self subclassResponsibility 
]

{ #category : #accessing }
DiyaNode >> children [
	^children
]

{ #category : #accessing }
DiyaNode >> draw [
	self subclassResponsibility 
]

{ #category : #requirements }
DiyaNode >> empty [
	children := OrderedCollection new.
]

{ #category : #accessing }
DiyaNode >> extent [
	^  self subclassResponsibility  
]

{ #category : #initialization }
DiyaNode >> initialize [
	super initialize.
	parent := nil.
	shader := nil.
	context := DiyaRendererContext uniqueInstance.
	children := OrderedCollection new.
	dirty := false.
	ehandlers := Dictionary new.
	style := DiyaNodeStyle new.
	root := nil.
]

{ #category : #'as yet unclassified' }
DiyaNode >> inner: aPoint [
	^ self subclassResponsibility 
]

{ #category : #testing }
DiyaNode >> isRoot [
	^ false
]

{ #category : #convenience }
DiyaNode >> on: eventName do: aBlock [
	eventName isArray ifFalse:[ ^ self register: aBlock to: eventName ].
	eventName do:[:e| self register: aBlock to:e ].
	
]

{ #category : #accessing }
DiyaNode >> parent [
	^ parent
]

{ #category : #accessing }
DiyaNode >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
DiyaNode >> position [
	^ translation
]

{ #category : #accessing }
DiyaNode >> position: anObject [
	translation := anObject.
	self updateTF.
]

{ #category : #convenience }
DiyaNode >> register: aBlock to: eventName [
	|evtCode|
	evtCode := SDL2Constants bindingOf: ('SDL_', eventName asUppercase).
	evtCode ifNil: [ ^DiyaCoreAPIError signal: 'Unknow event ', eventName ].
	ehandlers at: evtCode value put: aBlock.
	
]

{ #category : #accessing }
DiyaNode >> render [
	dirty ifTrue:[
		dirty := self update not].
	shader ifNotNil: [ self setUpShader  ].
	self draw.
	children ifNil: [ ^self ].
	children do: [:c  | c render  ]. 
]

{ #category : #accessing }
DiyaNode >> root [
	^ root
]

{ #category : #accessing }
DiyaNode >> root: anObject [
	root := anObject
]

{ #category : #accessing }
DiyaNode >> rotation [
	^ rotation
]

{ #category : #accessing }
DiyaNode >> rotation: anObject [
	rotation := anObject.
	self updateTF.
]

{ #category : #accessing }
DiyaNode >> scale [
	^ scale
]

{ #category : #accessing }
DiyaNode >> scale: anObject [
	scale := anObject.
	self updateTF.
]

{ #category : #accessing }
DiyaNode >> setUpShader [
	|mem|
		mem := self tf asGLBuffer.
		shader use;
			setUniform: #u_time value: DiyaClock uniqueInstance elapsedTime asFloat;
			setUniform: #u_projection value: {GL_FALSE. context projection buffer};
			setUniform: #u_resolution value: { context resolution x. context resolution y };
			setUniform: #u_texture value: 0;
			setUniform: #u_transform value: {GL_TRUE. mem}.
		context mouse ifNotNil: [
			"in shader, window origin is bottom left conor of the window
			the mouse position should be transformed to this coodinate"
			shader setUniform: #u_mouse value:
				{ context mouse x. context resolution y - context mouse y }.
		].
		mem free.
]

{ #category : #accessing }
DiyaNode >> shader [
	shader ifNil: [ 
		parent ifNil: [ ^nil ].
		^parent shader ].
	^ shader
]

{ #category : #accessing }
DiyaNode >> shader: anObject [
	shader := anObject
]

{ #category : #accessing }
DiyaNode >> style [
	^style
]

{ #category : #accessing }
DiyaNode >> style: aStyle [
	style := aStyle.
	dirty := true.
	parent ifNotNil: [ style parent: parent style ]
]

{ #category : #accessing }
DiyaNode >> tf [
	^ tf
]

{ #category : #'as yet unclassified' }
DiyaNode >> trigger: evt [
	evt enable ifFalse:[^self].
	ehandlers at: evt mapped type ifPresent:[:handler| handler value: evt].
	children ifNil: [^self].
	evt enable ifTrue: [
		"evt mapped triggableOn: children first."
		children select: [:node | evt mapped triggableOn: node ] thenDo:[:node| node trigger: evt]
	].
]

{ #category : #accessing }
DiyaNode >> update [
	^self subclassResponsibility 
]

{ #category : #accessing }
DiyaNode >> updateTF [
	self subclassResponsibility 
]
