Class {
	#name : #DiyaImageIcon,
	#superclass : #DiyaImageView,
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaImageIcon >> iconSize [
	^ self extent x
]

{ #category : #accessing }
DiyaImageIcon >> iconSize:v [
	^ self extent: v@v
]

{ #category : #accessing }
DiyaImageIcon >> initialize [
	super initialize.
	style set: #border value: 0
]
