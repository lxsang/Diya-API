Extension { #name : #Array }

{ #category : #'*Diya' }
Array >> asPoint [
	^ (self at: 1 ifAbsent:[0]) @ (self at: 2 ifAbsent:[0])
]
