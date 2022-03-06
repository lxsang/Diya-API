Class {
	#name : #DiyaRectangle,
	#superclass : #Diya2DPrimShape,
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaRectangle >> initialize [
	super initialize.
	self extent:10@10.
	translation  := nil.
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size:24.
	vbuffer autoRelease.
	nvertices := 6
]

{ #category : #accessing }
DiyaRectangle >> update [
	{
		0.0. extent y. 0.0. 0.0.            
      0. 0. 0.0. 1.0.
      extent x. 0.0. 1.0. 1.0.
		0.0. extent y. 0.0. 0.0.
      extent x. 0.0. 1.0. 1.0.
      extent x. extent y. 1.0. 0.0.
	} doWithIndex: [:e :i| vbuffer at: i put: e].
	^true
]
