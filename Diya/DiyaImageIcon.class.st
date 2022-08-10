Class {
	#name : #DiyaImageIcon,
	#superclass : #DiyaImageView,
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaImageIcon >> borderWidth [
	^0
]

{ #category : #accessing }
DiyaImageIcon >> iconSize [
	^ self ? #iconSize
]

{ #category : #accessing }
DiyaImageIcon >> initialize [
	super initialize.
]

{ #category : #accessing }
DiyaImageIcon >> process [
	|v|
	v := self iconSize.
	self extent: (v@v).
	^super process
]
