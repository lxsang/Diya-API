Extension { #name : #SmalltalkImage }

{ #category : #'*Diya' }
SmalltalkImage >> getenv: key [
	^ self ffiCall: #(char *getenv(const char *key)) module: LibC 
]
