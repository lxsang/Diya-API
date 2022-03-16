Class {
	#name : #DiyaCircle,
	#superclass : #DiyaEllipse,
	#category : #'Diya-Graphics'
}

{ #category : #'as yet unclassified' }
DiyaCircle class >> r: r [
	^self rx: r ry:r
]

{ #category : #'as yet unclassified' }
DiyaCircle class >> r: r shader:s [
	^self rx: r ry:r shader:s 
]
