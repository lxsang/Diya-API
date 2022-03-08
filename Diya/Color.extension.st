Extension { #name : #Color }

{ #category : #'*Diya' }
Color >> as4bytesRGB [
	^{
		(self red* 255) asInteger.
		(self green * 255) asInteger.
		(self blue*255) asInteger.
		(self alpha* 255) asInteger
	}
]

{ #category : #'*Diya' }
Color >> asGL4FArray [
	^{self red. self green. self blue. self alpha }
]
