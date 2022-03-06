Class {
	#name : #DiyaRootNode,
	#superclass : #DiyaNode,
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaRootNode >> draw [
	OpenGL clearColorR: 0.0 G: 0.0 B: 0.0  A:0.
	OpenGL clear: GL_COLOR_BUFFER_BIT.
	context vbo bind: GL_ARRAY_BUFFER.
]

{ #category : #initialization }
DiyaRootNode >> initialize [
	super initialize.
	parent := self.
	shader := nil.
]

{ #category : #testing }
DiyaRootNode >> isRoot [
	^ true
]

{ #category : #initialization }
DiyaRootNode >> update [
	^true
]

{ #category : #accessing }
DiyaRootNode >> updateTF [
	"donothing"
]
