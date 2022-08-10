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
		'styleName',
		'style',
		'id'
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
DiyaNode >> ? styleAttr [
	| value|
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
	Transcript show:'Added node #', self id asString; cr.
	^ node 
]

{ #category : #accessing }
DiyaNode >> allChildren [
	|nodes|
	nodes := OrderedCollection new.
	children ifNil: [ ^ nodes ].
	children do:[:c|
		nodes add: c.
		c allChildren do:[:e| nodes add:e].
	].
	^nodes
	
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

{ #category : #accessing }
DiyaNode >> id [
	^ id
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
	styleName := nil.
	style := nil.
	root := nil.
	id := Random new nextInt: 1e6
]

{ #category : #accessing }
DiyaNode >> inner: aPoint [
	^ self subclassResponsibility 
]

{ #category : #testing }
DiyaNode >> isDirty [
	^ dirty
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

{ #category : #accessing }
DiyaNode >> process [
	^self subclassResponsibility 
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
	self step.
	dirty ifTrue:[
		dirty := self process not].
	shader ifNotNil: [self setUpShader].
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

{ #category : #initialization }
DiyaNode >> setClean [
	dirty := false
]

{ #category : #initialization }
DiyaNode >> setDirty [
	dirty := true
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
		"evt mapped triggableOn: children first."
		children select: [:node | evt mapped triggableOn: node ] thenDo:[:node| node trigger: evt]
	].
]

{ #category : #accessing }
DiyaNode >> updateTF [
	self subclassResponsibility 
]
