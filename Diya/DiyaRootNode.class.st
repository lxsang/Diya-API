Class {
	#name : #DiyaRootNode,
	#superclass : #DiyaNode,
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaRootNode >> draw [
	OpenGL clearColorR: 1.0 G: 0.0 B: 1.0  A:0.
	OpenGL clear: GL_COLOR_BUFFER_BIT.
]

{ #category : #initialization }
DiyaRootNode >> initialize [
	super initialize.
	parent := self.
	shader := DiyaDefaultShader uniqueInstance.
]

{ #category : #testing }
DiyaRootNode >> isRoot [
	^ true
]

{ #category : #accessing }
DiyaRootNode >> updateTF [
	"donothing"
]
