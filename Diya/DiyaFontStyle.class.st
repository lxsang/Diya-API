Class {
	#name : #DiyaFontStyle,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'texmap',
		'face',
		'name'
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
	face := anObject
]

{ #category : #initialization }
DiyaFontStyle >> initialize [
	super initialize.
	texmap := Dictionary new.
]

{ #category : #accessing }
DiyaFontStyle >> name [
	^ name
]

{ #category : #accessing }
DiyaFontStyle >> name: anObject [
	name := anObject
]

{ #category : #accessing }
DiyaFontStyle >> texmap [
	^ texmap
]

{ #category : #initialization }
DiyaFontStyle >> textureOf: size [
	|tex|
	tex := texmap at: size ifAbsentPut: [
		""
		OpenGLFontTex fromFace: face ofSize: size
	].
	^tex
]
