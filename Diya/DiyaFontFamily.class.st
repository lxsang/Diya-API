Class {
	#name : #DiyaFontFamily,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'faces',
		'name'
	],
	#category : #'Diya-Fonts'
}

{ #category : #'instance creation' }
DiyaFontFamily class >> fromFace: face [
	^self new addFace: face; yourself.
]

{ #category : #accessing }
DiyaFontFamily >> addFace: face [
	name ifNil: [ name := face familyName ].
	faces at: face styleName ifAbsentPut: face.
]

{ #category : #accessing }
DiyaFontFamily >> face: styleName [
	^faces at: styleName ifAbsent: [^faces at: 'Regular']
]

{ #category : #accessing }
DiyaFontFamily >> faces [
	^ faces
]

{ #category : #initialization }
DiyaFontFamily >> initialize [ 
	super initialize.
	faces := Dictionary new.
	name := nil
]

{ #category : #accessing }
DiyaFontFamily >> name [
	^ name
]

{ #category : #accessing }
DiyaFontFamily >> name: anObject [
	name := anObject
]

{ #category : #accessing }
DiyaFontFamily >> styleNames [
	^faces keys
]
