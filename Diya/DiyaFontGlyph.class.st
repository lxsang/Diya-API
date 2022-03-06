Class {
	#name : #DiyaFontGlyph,
	#superclass : #Rectangle,
	#instVars : [
		'advance',
		'bearing',
		'texcoord'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Fonts'
}

{ #category : #accessing }
DiyaFontGlyph >> advance [
	^ advance
]

{ #category : #accessing }
DiyaFontGlyph >> advance: anObject [
	advance := anObject
]

{ #category : #accessing }
DiyaFontGlyph >> bearing [
	^ bearing
]

{ #category : #accessing }
DiyaFontGlyph >> bearing: anObject [
	bearing := anObject
]

{ #category : #accessing }
DiyaFontGlyph >> texcoord [
	^ texcoord
]

{ #category : #accessing }
DiyaFontGlyph >> texcoord: anObject [
	texcoord := anObject
]
