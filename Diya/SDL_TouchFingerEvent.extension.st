Extension { #name : #'SDL_TouchFingerEvent' }

{ #category : #'*Diya' }
SDL_TouchFingerEvent >> triggableOn: aNode [
	^ aNode inner: self worldPosition 
]

{ #category : #'*Diya' }
SDL_TouchFingerEvent >> worldPosition [
	|resolution|
	resolution := DiyaRendererContext uniqueInstance resolution.
	^((self x)* (resolution x) ) @ ((1.0 - self y)* (resolution  y)).
]
