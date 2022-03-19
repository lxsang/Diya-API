Extension { #name : #Rectangle }

{ #category : #'*Diya' }
Rectangle >> applyTf: tf [
	^ Rectangle
		origin: (self origin applyTf: tf)
		corner: (self corner applyTf: tf)
]
