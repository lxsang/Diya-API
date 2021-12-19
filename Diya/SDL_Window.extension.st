Extension { #name : #'SDL_Window' }

{ #category : #'*Diya' }
SDL_Window >> destroy [
	self primDestroy.
	handle beNull
]

{ #category : #'*Diya' }
SDL_Window >> warpMouseX:x Y:y [
	^self ffiCall: #(void SDL_WarpMouseInWindow(self,int x, int y))
	
]
