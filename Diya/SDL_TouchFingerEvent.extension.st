Extension { #name : #'SDL_TouchFingerEvent' }

{ #category : #'*Diya' }
SDL_TouchFingerEvent >> triggableOn: aNode [
	^ aNode inner: self worldPosition 
]

{ #category : #'*Diya' }
SDL_TouchFingerEvent >> worldPosition [
	|resolution|
	resolution := DiyaRenderer resolution.
	^((self x)* (resolution x) ) @ ((self y)* (resolution  y)).
]
