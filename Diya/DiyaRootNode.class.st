Class {
	#name : #DiyaRootNode,
	#superclass : #DiyaNode,
	#instVars : [
		'Q'
	],
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaRootNode >> Q [
	^ Q
]

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
	context vbo bind: GL_ARRAY_BUFFER.
]

{ #category : #'add/remove' }
DiyaRootNode >> enqueueDirtyNode: aNode [
	(Q includes: aNode ) ifFalse:[ Q add: aNode].
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
	Q := OrderedCollection new
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

{ #category : #accessing }
DiyaRootNode >> processingQueue [
	^ Q
]

{ #category : #initialization }
DiyaRootNode >> setClean [
	
	
	
]

{ #category : #initialization }
DiyaRootNode >> setDirty [
	
	
]

{ #category : #accessing }
DiyaRootNode >> updateTF [
	"donothing"
]
