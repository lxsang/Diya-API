Extension { #name : #'SDL_TouchFingerEvent' }

{ #category : #'*Diya' }
SDL_TouchFingerEvent >> triggableOn: aNode [
	^ aNode inner: self worldPosition 
]

{ #category : #'*Diya' }
SDL_TouchFingerEvent >> worldPosition [
	^ (self x) @ (DiyaRendererContext uniqueInstance resolution y - self y )
]
