Class {
	#name : #DiyaText,
	#superclass : #Diya2DNode,
	#instVars : [
		'fontStyle',
		'fontSize',
		'data'
	],
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaText >> data [
	^ data
]

{ #category : #accessing }
DiyaText >> data: anObject [
	data := anObject
]

{ #category : #accessing }
DiyaText >> fontSize [
	^ fontSize
]

{ #category : #accessing }
DiyaText >> fontSize: anObject [
	fontSize := anObject
]

{ #category : #accessing }
DiyaText >> fontStyle [
	^ fontStyle
]

{ #category : #accessing }
DiyaText >> fontStyle: anObject [
	fontStyle := anObject
]

{ #category : #initialization }
DiyaText >> initialize [
	super initialize.
	fontStyle := DiyaFontManager uniqueInstance face: 'Regular' from:'Ubuntu'.
	fontSize := 12.
	data := nil.
]
