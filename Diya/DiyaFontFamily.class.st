Class {
	#name : #DiyaFontFamily,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'styles',
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
	styles at: face styleName ifAbsentPut: (DiyaFontStyle fromFace: face).
]

{ #category : #initialization }
DiyaFontFamily >> initialize [ 
	super initialize.
	styles := Dictionary new.
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
DiyaFontFamily >> style: styleName [
	^styles at: styleName ifAbsent: [^styles at: 'Regular']
]

{ #category : #accessing }
DiyaFontFamily >> styleNames [
	^styles keys
]

{ #category : #accessing }
DiyaFontFamily >> styles [
	^ styles
]
