Class {
	#name : #DiyaRootNode,
	#superclass : #DiyaNode,
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaRootNode >> boundingBox [
	^ Rectangle origin: 0@0 corner: context resolution 
]

{ #category : #accessing }
DiyaRootNode >> draw [
	|c|
	c := style get: #bgcolor.
	OpenGL clearColorR: c red G: c green B: c blue  A: c alpha.
	OpenGL clear: GL_COLOR_BUFFER_BIT.
	context vbo bind: GL_ARRAY_BUFFER.
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
	style := DiyaDefaultStyle new
]

{ #category : #'as yet unclassified' }
DiyaRootNode >> inner: aPoint [
	^true
]

{ #category : #accessing }
DiyaRootNode >> isRoot [ 
	^true
]

{ #category : #initialization }
DiyaRootNode >> update [
	^true
]

{ #category : #accessing }
DiyaRootNode >> updateTF [
	"donothing"
]
