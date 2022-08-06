Extension { #name : #'SDL_MouseButtonEvent' }

{ #category : #'*Diya' }
SDL_MouseButtonEvent >> triggableOn: aNode [
	^ aNode inner: self worldPosition 
]

{ #category : #'*Diya' }
SDL_MouseButtonEvent >> worldPosition [
	^ (self x) @ (self y )
]
