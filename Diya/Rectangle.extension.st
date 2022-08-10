Extension { #name : #Rectangle }

{ #category : #'*Diya' }
Rectangle >> applyTf: tf [
	^ tf localBoundsToGlobal: self 
]
