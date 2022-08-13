Class {
	#name : #DiyaConvexPolygon,
	#superclass : #DiyaPolygon,
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaConvexPolygon >> calculateVertices [
	|size index p texcoord|
	size := (points size + 1) << 2.
	vbuffer ifNotNil: [ vbuffer free ].
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size:size.
	vbuffer autoRelease.
	points sort:[:a :b| a angle > b angle]. 
	index := 1.
	points do:[:point|
		texcoord := self texcoordOf: point.
		vbuffer
			at: index put: point x;
			at: index + 1 put: point y;
			at: index + 2 put: texcoord x;
			at: index + 3 put: texcoord y.
		index := index + 4.
	].
	p := points at: 2.
	texcoord := self texcoordOf: p.
	vbuffer
			at: index put:  p x;
			at: index + 1 put: p y;
			at: index + 2 put: texcoord x;
			at: index + 3 put: texcoord y.
]

{ #category : #initialization }
DiyaConvexPolygon >> drawLines [
	OpenGL drawArrays: GL_LINE_LOOP first:voffset  count: (vbuffer size >> 2) - 1.
]

{ #category : #initialization }
DiyaConvexPolygon >> initialize [ 
	super initialize.
	type := GL_TRIANGLE_FAN
]

{ #category : #accessing }
DiyaConvexPolygon >> texcoordOf: point [
	^ (point / (self extent )) asFloatPoint 
]
