Extension { #name : #'SDL_Window' }

{ #category : #'*Diya' }
SDL_Window >> destroy [
	self primDestroy.
	handle beNull
]

{ #category : #'*Diya' }
SDL_Window class >> finalizeResourceData: aTuple [
	| handle |
	
	handle := aTuple first.
	handle isNull ifTrue: [ ^ self ].

	self destroyWindow: handle.
	handle beNull
]

{ #category : #'*Diya' }
SDL_Window >> warpMouseX:x Y:y [
	^self ffiCall: #(void SDL_WarpMouseInWindow(self,int x, int y))
	
]
