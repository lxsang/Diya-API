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
	OpenGL drawArrays: GL_LINE_LOOP first:voffset  count: (vbuffer size >> 2).
	
]

{ #category : #accessing }
DiyaRectangle >> extent: v [
	bbox := Rectangle origin:0@0 corner: v.
	self setDirty
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
DiyaRectangle >> process [
	|extent|
	extent := self extent.
	vbuffer
		at: 1 put: 0.0;
		at: 2 put: 0.0;
		at: 3 put: 0.0;
		at: 4 put: 0.0;
		
		at: 5 put: 0.0;
		at: 6 put: extent y;
		at: 7 put: 0.0;
		at: 8 put: 1.0;
		
		at: 9 put: extent x;
		at: 10 put: extent y;
		at: 11 put: 1.0;
		at: 12 put: 1.0;
		
		at: 13 put: extent x;
		at: 14 put: 0.0;
		at: 15 put: 1.0;
		at: 16 put: 0.0.
	^true
]
