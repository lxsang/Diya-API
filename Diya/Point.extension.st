Extension { #name : #Point }

{ #category : #'*Diya' }
Point >> applyTf: tf [
	^(tf +* (self asArray3F)) asPoint
]

{ #category : #'*Diya' }
Point >> asArray3F [
	^ self asArray3F: 1.0
]

{ #category : #'*Diya' }
Point >> asArray3F: z [
	^ { self x. self y. z }
]

{ #category : #'*Diya' }
Point >> asGLCoord [
	|res|
	res := DiyaRendererContext uniqueInstance resolution.
	^(self / ( res / 2.0)) + (-1.0@ -1.0).
]

{ #category : #'*Diya' }
Point >> glNormalise [
	|res p|
	res := DiyaRendererContext uniqueInstance resolution.
	p := self / (res/ 2).
	^ (p x asFloat) @ (p y asFloat)
]
