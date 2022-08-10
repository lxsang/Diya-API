Extension { #name : #Point }

{ #category : #'*Diya' }
Point >> applyTf: tf [
	^ tf localPointToGlobal: self
]

{ #category : #'*Diya' }
Point >> asArray3F [
	^ self asArray3F: 1.0
]

{ #category : #'*Diya' }
Point >> asArray3F: z [
	^ { self x. self y. z }
]
