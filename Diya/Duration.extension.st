Extension { #name : #Duration }

{ #category : #'*Diya' }
Duration >> asFloat [
	^ seconds asFloat + (nanos / 1e9) asFloat 
]
