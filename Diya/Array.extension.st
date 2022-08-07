Extension { #name : #Array }

{ #category : #'*Diya' }
Array >> asDiyaStyle [
	|style|
	style := DiyaStyle new.
	self do:[:v |
		style at: v key put: v value
	].
	^style
]

{ #category : #'*Diya' }
Array >> asPoint [
	^ (self at: 1 ifAbsent:[0]) @ (self at: 2 ifAbsent:[0])
]
