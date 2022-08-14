Class {
	#name : #DiyaRootNode,
	#superclass : #DiyaNode,
	#instVars : [
		'Q',
		'R'
	],
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaRootNode >> boundingBox [
	^ Rectangle origin: 0@0 corner: context resolution 
]

{ #category : #'add/remove' }
DiyaRootNode >> cleanDirtyNode: aNode [
	Q remove: aNode ifAbsent:[]
]

{ #category : #accessing }
DiyaRootNode >> draw [
	|c|
	c := self ? #bgColor.
	OpenGL clearColorR: c red G: c green B: c blue  A: c alpha.
	OpenGL clear: GL_COLOR_BUFFER_BIT.
]

{ #category : #'add/remove' }
DiyaRootNode >> enqueueDirtyNode: aNode [
	Q addIfNotPresent: aNode
]

{ #category : #accessing }
DiyaRootNode >> extent [
	^  context resolution 
]

{ #category : #initialization }
DiyaRootNode >> initialize [
	super initialize.
	parent := self.
	shader := nil.
	root := self.
	styleName := #global.
	Q := OrderedCollection new.
	R := OrderedCollection new.
]

{ #category : #accessing }
DiyaRootNode >> inner: aPoint [
	^true
]

{ #category : #accessing }
DiyaRootNode >> isRoot [ 
	^true
]

{ #category : #initialization }
DiyaRootNode >> process [
	
]

{ #category : #testing }
DiyaRootNode >> readyForSwap [
	^ R isEmpty 
]

{ #category : #rendering }
DiyaRootNode >> render [
	| maxProcessingTime|
	self stepDown.
	R ifEmpty: [
		self draw.
		self renderNext: children 
	].
	maxProcessingTime := (1000 / DiyaSystemSettings maxFPS) asInteger.
	[
		self spinOnce: maxProcessingTime 
	] whileTrue
]

{ #category : #rendering }
DiyaRootNode >> renderNext: nodes [
	R addAllFirstUnlessAlreadyPresent: nodes.
]

{ #category : #initialization }
DiyaRootNode >> setClean [
	
	
	
]

{ #category : #initialization }
DiyaRootNode >> setDirty [
	
	
]

{ #category : #rendering }
DiyaRootNode >> spinOnce: maxProcessingTime [ 
	|node|
	Q ifNotEmpty: [ 
		node := Q removeFirst.
		node process.
	].
	R ifNotEmpty: [ 
		node := R removeFirst.
		node render.	
	].
	(Q isEmpty and: R isEmpty) ifTrue: [ ^false ].
	DiyaSystemSettings renderAtOnce ifTrue: [ ^ true ].
	^(DiyaSystemClock lapDelta asMilliSeconds  < maxProcessingTime)
]

{ #category : #accessing }
DiyaRootNode >> updateTF [
	"donothing"
]
