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
		'extent',
		'dirty'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'instance creation' }
DiyaNode class >> size: size [
	^(self new) extent: size; yourself
]

{ #category : #'instance creation' }
DiyaNode class >> size: size shader:s [
	^(self with:s) extent: size; yourself
]

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

{ #category : #accessing }
DiyaNode >> extent [
	^ extent
]

{ #category : #accessing }
DiyaNode >> extent: anObject [
	extent := anObject.
	dirty := true
]

{ #category : #accessing }
DiyaNode >> height [
	^ extent y
]

{ #category : #initialization }
DiyaNode >> initialize [
	super initialize.
	parent := nil.
	shader := nil.
	context := DiyaRendererContext uniqueInstance.
	children := OrderedCollection new.
	dirty := false
]

{ #category : #testing }
DiyaNode >> isRoot [
	^false
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
DiyaNode >> render [
	dirty ifTrue:[dirty := self update not].
	shader ifNotNil: [ self setUpShader  ].
	self draw.
	children ifNil: [ ^self ].
	children do: [:c  | c render  ]. 
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
		shader use;
			setUniform: #u_time value: DiyaClock uniqueInstance elapsedTime asFloat;
			setUniform: #u_projection value: {GL_FALSE. context projection buffer};
			setUniform: #u_resolution value: { context resolution x. context resolution y };
			setUniform: #u_texture value: 0;
			setUniform: #u_transform value: {GL_TRUE. self tf asGLBuffer}.
		context mouse ifNotNil: [
			"in shader, window origin is bottom left conor of the window
			the mouse position should be transformed to this coodinate"
			shader setUniform: #u_mouse value:
				{ context mouse x. context resolution y - context mouse y }.
		].
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
DiyaNode >> tf [
	parent ifNil: [ self error: 'TF: This node is not attached to the main tree' ].
	^ tf
]

{ #category : #accessing }
DiyaNode >> update [
	^self subclassResponsibility 
]

{ #category : #accessing }
DiyaNode >> updateTF [
	self subclassResponsibility 
]

{ #category : #accessing }
DiyaNode >> wdith [
	^ extent x
]
