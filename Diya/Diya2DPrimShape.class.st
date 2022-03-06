Class {
	#name : #Diya2DPrimShape,
	#superclass : #Diya2DNode,
	#instVars : [
		'texture'
	],
	#category : #'Diya-Graphics'
}

{ #category : #initialization }
Diya2DPrimShape >> initialize [
	super initialize.
	texture := nil.
]

{ #category : #initialization }
Diya2DPrimShape >> setUpShader [
	super setUpShader.
	texture ifNotNil: [
		self shader
			setUniform: #u_use_texture value:1.
	].
]

{ #category : #accessing }
Diya2DPrimShape >> texture [
	^ texture
]

{ #category : #accessing }
Diya2DPrimShape >> texture: anObject [
	texture := anObject
]
