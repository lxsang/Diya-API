Class {
	#name : #OpenGLFontTex,
	#superclass : #OpenGLTexImage2D,
	#instVars : [
		'charmap',
		'cellw',
		'cellh',
		'spacing'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Fonts'
}

{ #category : #'instance creation' }
OpenGLFontTex class >> fromFace: face ofSize: size [
	^self new fromFace: face ofSize: size; yourself
]

{ #category : #'instance creation' }
OpenGLFontTex >> blitPixel8: bitmap at: offset size: size [
	size = (0@0) ifTrue:[^self].
	0 to: size y - 1 do: [ :i|
			LibC memCopy: (bitmap getHandle + (i* (size x))) to:(data getHandle + ((i + offset y) * width + (offset x) ))  size: size x
	]
]

{ #category : #accessing }
OpenGLFontTex >> cellh [
	^ cellh
]

{ #category : #accessing }
OpenGLFontTex >> cellw [
	^ cellw
]

{ #category : #accessing }
OpenGLFontTex >> charmap [
	^ charmap
]

{ #category : #'instance creation' }
OpenGLFontTex >> createBitmapFontFrom: bitmaps metrics: metrics maxBearing: maxbearing [
	|currChar offset|
	data ifNotNil: [data free ].
	charmap := OrderedCollection new.
	data := FFIExternalArray externalNewType: GLubyte size:cellw * cellh * 256.
	LibC memset: data getHandle value: 0 size: data size.
	data autoRelease.
	currChar := 1.
	offset := 0@0.
	width := cellw * 16.
	height := cellh * 16.
	0 to: 15 do: [ :row|
		0 to: 15 do: [ :col| |glyph|
			offset := (col * cellw) @ (row*cellh).
			glyph := (DiyaFontGlyph  origin: offset extent: (((metrics at: currChar) first x asInteger)  @ cellh)).
			glyph
				bearing: ((metrics at: currChar) at: 2) asFloatPoint;
				advance: ((metrics at: currChar) at: 3) asFloatPoint;
				texcoord: (Rectangle origin: (glyph origin/ (self extent) ) asFloatPoint  corner: ((glyph corner) / (self extent)) asFloatPoint ).
			charmap add:glyph.
			self blitPixel8: (bitmaps at: currChar) at: (offset x) @ ((offset y) + maxbearing - ((metrics at: currChar) last) ) size: (metrics at: currChar) first.
			currChar := currChar + 1.
		]
	].
]

{ #category : #accessing }
OpenGLFontTex >> drop [
	OpenGL
		pixelstorei: GL_UNPACK_ALIGNMENT param: 4;
		disable: GL_CULL_FACE;
		disable: GL_BLEND.
]

{ #category : #'instance creation' }
OpenGLFontTex >> fromFace: face  ofSize: size [
	|minhang maxbearing rec metrics bitmaps |
	face setPixelWidth:0 height: size.
	"set up a buffer for 256 characters"
	bitmaps := OrderedCollection new.
	metrics := OrderedCollection new.
	cellw := 0.
	cellh := 0.
	minhang := 0.
	maxbearing := 0.
	rec := (FTFaceRec fromHandle: face getHandle).
	0 to: 255 do: [ :c |
		|bmp bmpsize|
		face loadCharacter: c flags: (1 << 2).
		metrics add: {
			(((rec glyph metrics width) /64)@ ((rec glyph metrics height) /64)).
			(face glyph hBearing).
			(face glyph advance).
			((rec glyph metrics horiBearingY) / 64)
		}.
		maxbearing := maxbearing max:  ((rec glyph metrics horiBearingY) / 64).
		cellw := cellw max: ((rec glyph metrics width) / 64).
		minhang := minhang min: ((( rec glyph metrics horiBearingY) - (rec glyph metrics height )) / 64).
		"copy buffer"
		bmpsize := (rec glyph bitmap width)*(rec glyph bitmap rows).
		bmp := FFIExternalArray externalNewType: GLubyte size:bmpsize.
		LibC memCopy: rec glyph bitmap buffer to: bmp getHandle  size: bmpsize.
		bitmaps add: bmp.
	].
	cellh := maxbearing - minhang.
	spacing := (cellw / 2) asInteger.
	self createBitmapFontFrom: bitmaps metrics: metrics maxBearing: maxbearing.
	bitmaps do:[:p| p free].
]

{ #category : #accessing }
OpenGLFontTex >> getGlyph: c [
	^(self charmap at: c + 1)
]

{ #category : #initialization }
OpenGLFontTex >> initialize [
	super initialize.
	charmap := OrderedCollection new.
	data := nil.
	level := 0.
	border := 0.
	format := GL_ALPHA.
	internalFormat := GL_ALPHA.
	type := GL_UNSIGNED_BYTE.
	target := GL_TEXTURE_2D.
]

{ #category : #accessing }
OpenGLFontTex >> linespace [
	^ cellh
]

{ #category : #accessing }
OpenGLFontTex >> setup [
	OpenGL
		enable: GL_CULL_FACE;
		enable: GL_BLEND;
		blendFnWithSfactor: GL_SRC_ALPHA dfactor: GL_ONE_MINUS_SRC_ALPHA;
		pixelstorei: GL_UNPACK_ALIGNMENT param: 1.
	OpenGLTexture
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_S param: GL_CLAMP_TO_EDGE;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_T param: GL_CLAMP_TO_EDGE;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MIN_FILTER param: GL_LINEAR;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MAG_FILTER param: GL_LINEAR.
]

{ #category : #accessing }
OpenGLFontTex >> spacing [
	^ spacing
]
