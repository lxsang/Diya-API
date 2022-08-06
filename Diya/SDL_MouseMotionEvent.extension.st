Extension { #name : #'SDL_MouseMotionEvent' }

{ #category : #'*Diya' }
SDL_MouseMotionEvent >> triggableOn: arg1 [
	^ arg1 inner: self worldPosition
]

{ #category : #'*Diya' }
SDL_MouseMotionEvent >> worldPosition [
	^ (self x) @ (self y )
]
