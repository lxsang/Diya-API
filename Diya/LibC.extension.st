Extension { #name : #LibC }

{ #category : #'*Diya' }
LibC >> memset:pointer value: value size: size [
	^self ffiCall: #(void *memset(void *pointer, int value, size_t size))
	
]

{ #category : #'*Diya' }
LibC class >> memset:pointer value: value size: size [
	^self uniqueInstance memset: pointer value: value size: size
]
