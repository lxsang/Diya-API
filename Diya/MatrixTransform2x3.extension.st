Extension { #name : #MatrixTransform2x3 }

{ #category : #'*Diya' }
MatrixTransform2x3 >> asGLBuffer [	
	|buffer|
	buffer := FFIExternalArray externalNewType: #float size: 9.
	1 to: 6 do:[:i|
		buffer at:i put: (self at:i)].
	buffer
		at: 7 put: 0;
		at: 8 put: 0;
		at: 9 put: 1.
	buffer autoRelease.
	^buffer
]
