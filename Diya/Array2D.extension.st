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

{ #category : #'*Diya' }
Array2D class >> rotationMatrix2D: rotation [
	^Array2D rows: 3 columns: 3 contents:{
			rotation cos. (rotation sin) negated. 0.0.
			rotation sin. rotation cos. 0.0.
			0.0. 0.0. 1.0
		}
]

{ #category : #'*Diya' }
Array2D class >> scaleMatrix2D: scale [
	^Array2D rows: 3 columns: 3 contents:{
			scale x. 0.0. 0.0.
			0.0. scale y. 0.0.
			0.0. 0.0. 1.0
		}
]

{ #category : #'*Diya' }
Array2D class >> translateMatrix2D: translation [
	^Array2D rows: 3 columns: 3 contents: {
			1.0. 0.0. translation x.
			0.0. 1.0. translation y.
			0.0. 0.0. 1.0
		}
]
