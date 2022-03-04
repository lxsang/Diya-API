Class {
	#name : #OpenGLFontTex,
	#superclass : #OpenGLTexImage2D,
	#instVars : [
		'bearing',
		'advance',
		'linespace'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Fonts'
}

{ #category : #'instance creation' }
OpenGLFontTex class >> fromFace: face [
	^self new fromFace: face; yourself
]

{ #category : #accessing }
OpenGLFontTex >> advance [
	^ advance
]

{ #category : #accessing }
OpenGLFontTex >> advance: anObject [
	advance := anObject
]

{ #category : #accessing }
OpenGLFontTex >> bearing [
	^ bearing
]

{ #category : #accessing }
OpenGLFontTex >> bearing: anObject [
	bearing := anObject
]

{ #category : #accessing }
OpenGLFontTex >> fromFace: aFTFace [
	|size glyph rec|
	glyph := aFTFace glyph.
	size := glyph width * glyph height.
	data := FFIExternalArray externalNewType: #uint8 size:size.
	rec := (FTFaceRec fromHandle: aFTFace getHandle).
	data autoRelease.
	LibC memCopy: (rec glyph bitmap buffer) to:data getHandle  size: size.
	level := 0.
	internalFormat := GL_ALPHA.
	width := glyph width.
	height := glyph height.
	linespace := (rec size metrics height / 64) asInteger.
	border := 0.
	format := GL_ALPHA.
	type := GL_UNSIGNED_BYTE.
	target := GL_TEXTURE_2D.
	bearing  := (glyph hBearingX )@ (glyph hBearingY).
	advance := (glyph advanceX )@ (glyph advanceY).
]

{ #category : #accessing }
OpenGLFontTex >> linespace [
	^ linespace
]

{ #category : #accessing }
OpenGLFontTex >> linespace: anObject [
	linespace := anObject
]
