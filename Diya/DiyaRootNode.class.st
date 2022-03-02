Class {
	#name : #DiyaRootNode,
	#superclass : #DiyaComposableNode,
	#category : #'Diya-Graphics'
}

{ #category : #initialization }
DiyaRootNode >> initialize [
	super initialize.
	parent := self.
]

{ #category : #testing }
DiyaRootNode >> isRoot [
	^ true
]

{ #category : #accessing }
DiyaRootNode >> render [
	OpenGL clearColorR: 1.0 G: 0  B: 1.0  A:0.
	OpenGL clear: GL_COLOR_BUFFER_BIT.
	"render all child node"
	children do: [:c | c render ].
	
]

{ #category : #accessing }
DiyaRootNode >> updateTF [
	"donothing"
]
