Class {
	#name : #DiyaFontGlyph,
	#superclass : #Rectangle,
	#instVars : [
		'advance',
		'bearing',
		'tex'
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
DiyaFontGlyph >> tex [
	^ tex
]

{ #category : #accessing }
DiyaFontGlyph >> tex: anObject [
	tex := anObject
]

{ #category : #accessing }
DiyaFontGlyph >> texcoord [
	^ (Rectangle origin: (self origin/ (tex extent) ) asFloatPoint  corner: ((self corner) / (tex extent)) asFloatPoint ).
]
