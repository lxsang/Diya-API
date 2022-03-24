Class {
	#name : #DiyaRectangle,
	#superclass : #Diya2DPrimShape,
	#category : #'Diya-Graphics'
}

{ #category : #'instance creation' }
DiyaRectangle class >> size: size [
	^(self new) extent: size; yourself
]

{ #category : #'instance creation' }
DiyaRectangle class >> size: size shader:s [
	^(self with:s) extent: size; yourself
]

{ #category : #initialization }
DiyaRectangle >> drawLines [
	OpenGL drawArrays: GL_LINE_LOOP first:0  count: (vbuffer size >> 2).
	
]

{ #category : #accessing }
DiyaRectangle >> extent: v [
	bbox := Rectangle origin:0@0 corner: v.
	dirty := true
]

{ #category : #accessing }
DiyaRectangle >> initialize [
	super initialize.
	self extent:10@10.
	translation  := nil.
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size:16.
	vbuffer autoRelease.
	type := GL_QUADS.
]

{ #category : #accessing }
DiyaRectangle >> update [
	|extent|
	extent := self extent.
	{
		0.0. extent y. 0.0. 0.0.            
      0. 0. 0.0. 1.0.
      extent x. 0.0. 1.0. 1.0.
		extent x. extent y. 1.0. 0.0.
	} doWithIndex: [:e :i| vbuffer at: i put: e].
	^true
]
