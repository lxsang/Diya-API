Class {
	#name : #DiyaImageView,
	#superclass : #DiyaRectangle,
	#category : #'Diya-Graphics'
}

{ #category : #'instance creation' }
DiyaImageView class >> from: assetName [
	^self new from: assetName ; yourself
]

{ #category : #'instance creation' }
DiyaImageView >> from: name [
	texture := context assets texture: name.
	self extent: texture extent
]
