Extension { #name : #Array2D }

{ #category : #'*Diya' }
Array2D >> asGLBuffer [
	|buffer i|
	i := 1.
	buffer := FFIExternalArray externalNewType: #float size: self size.
	self asArray do:[:e|
		buffer at:i put:e.
		i := i+1
	].
	buffer autoRelease.
	^buffer
]
