Extension { #name : #'SDL_MouseMotionEvent' }

{ #category : #'*Diya' }
SDL_MouseMotionEvent >> triggableOn: arg1 [
	^ arg1 inner: self worldPosition
]

{ #category : #'*Diya' }
SDL_MouseMotionEvent >> worldPosition [
	^ (self x) @ (DiyaRendererContext uniqueInstance resolution y - self y )
]
