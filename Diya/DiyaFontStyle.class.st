Class {
	#name : #DiyaFontStyle,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'face',
		'name',
		'charmap'
	],
	#category : #'Diya-Fonts'
}

{ #category : #'instance creation' }
DiyaFontStyle class >> fromFace: aFace [
	^self new face: aFace; yourself
]

{ #category : #accessing }
DiyaFontStyle >> face [
	^ face
]

{ #category : #accessing }
DiyaFontStyle >> face: anObject [
	face := anObject.
	name := anObject styleName
]

{ #category : #initialization }
DiyaFontStyle >> initialize [
	super initialize.
	charmap := Dictionary new.
]

{ #category : #initialization }
DiyaFontStyle >> loadChar: charCode size: size [
	|tex dic|
	"lookup in the char map"
	dic := charmap at: charCode ifAbsentPut: Dictionary new.
	tex := dic at: size ifAbsentPut: [
		face setPixelWidth:0 height: size.
		face loadCharacter: charCode  flags: (1 << 2).
		OpenGLFontTex fromFace: face
	].
	^tex
]

{ #category : #accessing }
DiyaFontStyle >> name [
	^ name
]

{ #category : #accessing }
DiyaFontStyle >> name: anObject [
	name := anObject
]
