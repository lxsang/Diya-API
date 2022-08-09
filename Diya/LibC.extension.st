Extension { #name : #LibC }

{ #category : #'*Diya' }
LibC class >> alloc: size [
	^self uniqueInstance alloc: size
]

{ #category : #'*Diya' }
LibC >> alloc:size [
	^self ffiCall: #(void *malloc(size_t size))
	
]

{ #category : #'*Diya' }
LibC >> memset:pointer value: value size: size [
	^self ffiCall: #(void *memset(void *pointer, int value, size_t size))
	
]

{ #category : #'*Diya' }
LibC class >> memset:pointer value: value size: size [
	^self uniqueInstance memset: pointer value: value size: size
]
