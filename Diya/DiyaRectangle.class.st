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
	self drawLineAt: 0.
	self drawLineAt: 1.
	self drawLineAt: 3.
	self drawLineAt: 4.
	
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
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size:24.
	vbuffer autoRelease.
]

{ #category : #accessing }
DiyaRectangle >> update [
	|extent|
	extent := self extent.
	{
		0.0. extent y. 0.0. 0.0.            
      0. 0. 0.0. 1.0.
      extent x. 0.0. 1.0. 1.0.

		extent x. 0.0. 1.0. 1.0.
		extent x. extent y. 1.0. 0.0.
		0.0. extent y. 0.0. 0.0.      
	} doWithIndex: [:e :i| vbuffer at: i put: e].
	^true
]
