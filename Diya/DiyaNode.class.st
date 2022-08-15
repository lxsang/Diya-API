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
		'ehandlers',
		'root',
		'styleName',
		'style',
		'inlineStyle',
		'id',
		'visibility',
		'pivot'
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

{ #category : #styling }
DiyaNode >> ? styleAttr [
	| value|
	value := inlineStyle at: styleAttr ifAbsent:[nil].
	value ifNotNil: [ ^value ].
	styleName ifNotNil: [
		style ifNil: [
			style := DiyaUIThemesManager uniqueInstance currentTheme ? (self styleName).
		].
		value := style at: styleAttr ifAbsent:[nil].
		value ifNotNil: [ ^value ].
	].
	"try to look at parent style"
	parent ifNil:[self styleNotFound: styleAttr].
	^ parent ? styleAttr
]

{ #category : #'add/remove' }
DiyaNode >> addNode: node [
	^self addNode: node at: 0@0 
]

{ #category : #'add/remove' }
DiyaNode >> addNode: node at: pos [
	children ifNil: [ ^self ].
	node parent: self.
	children add: node.
	node position: pos.
	node root: self root.
	node setDirtyAll.
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

{ #category : #rendering }
DiyaNode >> draw [
	self subclassResponsibility 
]

{ #category : #requirements }
DiyaNode >> empty [
	children ifNotNil: [
		children do:[:c|
			c root: nil.
			c setClean.
			c visibility: false.
		]	
	].
	children := OrderedCollection new.
]

{ #category : #accessing }
DiyaNode >> extent [
	^  self subclassResponsibility  
]

{ #category : #accessing }
DiyaNode >> id [
	^ id
]

{ #category : #initialization }
DiyaNode >> initialize [
	super initialize.
	parent := nil.
	shader := nil.
	context := DiyaRenderer.
	children := OrderedCollection new.
	ehandlers := Dictionary new.
	styleName := nil.
	style := nil.
	root := nil.
	inlineStyle := Dictionary new.
	visibility := true.
	pivot := 0@0.
	id := self className,'#',(Random new nextInt: 1e6) asString.
]

{ #category : #styling }
DiyaNode >> inlineStyle: name value: value [
	inlineStyle at: name put: value
]

{ #category : #testing }
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
DiyaNode >> pivot [
	^ pivot
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

{ #category : #processing }
DiyaNode >> process [
	^self subclassResponsibility 
]

{ #category : #convenience }
DiyaNode >> register: aBlock to: eventName [
	|evtCode|
	evtCode := SDL2Constants bindingOf: ('SDL_', eventName asUppercase).
	evtCode ifNil: [ evtCode := eventName  ].
	ehandlers at: evtCode value put: aBlock.
	
]

{ #category : #'add/remove' }
DiyaNode >> remove [
	parent ifNotNil: [ parent removeChild: self ]
]

{ #category : #'add/remove' }
DiyaNode >> removeChild: c [
	c setClean.
	c root: nil.
	c visibility: false.
	children ifNotNil: [ children remove: c ifAbsent:[  ]]
]

{ #category : #rendering }
DiyaNode >> render [
	visibility ifFalse:[^self].
	shader ifNotNil: [self setUpShader].
	self draw.
	children ifNil: [ ^self ].
	root ifNil: [ ^self ].
	root renderNext: children 
]

{ #category : #'add/remove' }
DiyaNode >> replaceChild: aNode with: anotherNode [
	|index|
	children ifNil: [ ^ self ].
	index := children indexOf: aNode.
	index = 0 ifTrue:[^ self].
	children at: index put: anotherNode.
	anotherNode parent: self.
	anotherNode root: self root.
	anotherNode setDirtyAll.
	aNode root: nil.
]

{ #category : #accessing }
DiyaNode >> root [
	^ root
]

{ #category : #accessing }
DiyaNode >> root: anObject [
	root = anObject ifTrue:[^self].
	root := anObject.
	children ifNotNil: [ 
		children do:[:c | c root: root]	
	]
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
DiyaNode >> rotation: anObject pivot: p [
	rotation := anObject.
	pivot := p.
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

{ #category : #'changing state' }
DiyaNode >> setClean [
	 root ifNil: [ ^self ].
	root cleanDirtyNode: self.
]

{ #category : #'changing state' }
DiyaNode >> setDirty [
	root ifNil: [ ^self ].
	self root enqueueDirtyNode: self.
]

{ #category : #'changing state' }
DiyaNode >> setDirtyAll [
	self setDirty.
	children ifNotNil: [
		children do:[:c| c setDirtyAll] ]
]

{ #category : #rendering }
DiyaNode >> setUpShader [
	|mem|
		mem := self tf asGLBuffer.
		shader use;
			setUniform: #u_time value: DiyaSystemClock elapsedTime asFloat;
			setUniform: #u_projection value: {GL_FALSE. context projection buffer};
			setUniform: #u_resolution value: { context resolution x. context resolution y };
			setUniform: #u_transform value: {GL_TRUE. mem}.
		context mouse ifNotNil: [
			"in shader, window origin is bottom left conor of the window
			the mouse position should be transformed to this coodinate"
			shader setUniform: #u_mouse value:
				{ context mouse x. context mouse y }.
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

{ #category : #stepping }
DiyaNode >> step [
]

{ #category : #stepping }
DiyaNode >> stepDown [
	self step.
	children ifNotNil: [ children do:[:c | c stepDown ] ]
]

{ #category : #accessing }
DiyaNode >> styleName [
	^ styleName
]

{ #category : #accessing }
DiyaNode >> styleName: anObject [
	styleName := anObject.
	style := nil.
	self setDirty
]

{ #category : #'event handling' }
DiyaNode >> styleNotFound: styleAttr [
	DiyaCoreAPIError signal: 'Query undefined style ', styleAttr, ' in', styleName.
]

{ #category : #accessing }
DiyaNode >> tf [
	^ tf
]

{ #category : #'event handling' }
DiyaNode >> trigger: evt [
	evt enable ifFalse:[^self].
	ehandlers at: evt mapped type ifPresent:[:handler|
		evt target: self.
		handler value: evt].
	children ifNil: [^self].
	evt enable ifTrue: [
		children select: [:node | evt mapped triggableOn: node ] thenDo:[:node| node trigger: evt]
	].
]

{ #category : #processing }
DiyaNode >> updateTF [
	self subclassResponsibility 
]

{ #category : #accessing }
DiyaNode >> visibility [
	^ visibility
]

{ #category : #accessing }
DiyaNode >> visibility: anObject [
	visibility := anObject.
	children ifNotNil: [
		children do:[:c| c visibility: anObject ] ]
]
