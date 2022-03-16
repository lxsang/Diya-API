Class {
	#name : #OpenGLFontTex,
	#superclass : #OpenGLTexImage2D,
	#instVars : [
		'charmap',
		'cellw',
		'cellh',
		'spacing',
		'fontSize'
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
	].
	bitmap free.
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
OpenGLFontTex >> createBitmapFontFrom: glyphs maxBearing: maxbearing [
	|bmp metric offset nrows index element|
	data ifNotNil: [data free ].
	charmap := Dictionary new.
	nrows := glyphs size >> 5.
	(glyphs size % 32) = 0 ifFalse:[nrows := nrows + 1].
	data := FFIExternalArray externalNewType: GLubyte size:cellw * cellh * (nrows << 5).
	LibC memset: data getHandle value: 0 size: data size.
	data autoRelease.
	index := 1.
	offset := 0@0.
	width := cellw * 32.
	height := cellh * nrows.
	0 to: nrows - 1 do: [ :row|
		0 to: 31 do: [ :col| |glyph|
			element := glyphs at: index.
			metric := element at: 3.
			bmp := element at:2.
			offset := (col * cellw) @ (row*cellh).
			glyph := (DiyaFontGlyph  origin: offset extent: ((metric first x asInteger)  @ cellh)).
			glyph
				bearing: (metric at: 2) asFloatPoint;
				advance: (metric at: 3) asFloatPoint;
				texcoord: (Rectangle origin: (glyph origin/ (self extent) ) asFloatPoint  corner: ((glyph corner) / (self extent)) asFloatPoint ).
			charmap at: element first put:glyph.
			self blitPixel8: bmp at: (offset x) @ ((offset y) + maxbearing - (metric last) ) size: metric first.
			index := index + 1.
			index > glyphs size ifTrue:[^self].
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

{ #category : #accessing }
OpenGLFontTex >> fontSize [
	^ fontSize
]

{ #category : #'instance creation' }
OpenGLFontTex >> fromFace: face  ofSize: size [
	|minhang maxbearing rec  glyphs iptr charcode w|
	fontSize := size.
	face setPixelWidth:0 height: size.
	glyphs := OrderedCollection new.
	cellw := 0.
	cellh := 0.
	minhang := 0.
	maxbearing := 0.
	iptr := FFIExternalArray externalNewType: GLuint size:1.
	iptr at:1 put: 0.
	rec := (FTFaceRec fromHandle: face getHandle).
	charcode := face getFirstChar: iptr getHandle.
	[ (iptr at: 1) = 0 ] whileFalse: [
		|bmp bmpsize metric|
		face loadCharacter: charcode flags: (1 << 2).
		w := ((rec glyph metrics width) >> 6).
		(w > (size << 1)) ifFalse:[
			metric := {
				(((rec glyph metrics width) >> 6)@ ((rec glyph metrics height) >> 6)).
				(face glyph hBearing).
				(face glyph advance).
				((rec glyph metrics horiBearingY) >> 6)
			}.
			maxbearing := maxbearing max:  ((rec glyph metrics horiBearingY) >> 6).
			cellw := cellw max: w.
			minhang := minhang min: ((( rec glyph metrics horiBearingY) - (rec glyph metrics height)) >> 6).
			"copy buffer"
			bmpsize := (rec glyph bitmap width)*(rec glyph bitmap rows).
			bmp := FFIExternalArray externalNewType: GLubyte size:bmpsize.
			LibC memCopy: rec glyph bitmap buffer to: bmp getHandle  size: bmpsize.
			glyphs add: {charcode. bmp. metric}.
		].
		charcode := face getNextChar: charcode iptr: iptr getHandle.
	].
	cellh := maxbearing - minhang.
	spacing := (size >> 2) asInteger.
	self createBitmapFontFrom: glyphs maxBearing: maxbearing.
	iptr free.
]

{ #category : #accessing }
OpenGLFontTex >> getGlyph: c [
	^(self charmap at: c ifAbsent:[^nil])
]

{ #category : #initialization }
OpenGLFontTex >> initialize [
	super initialize.
	charmap := Dictionary new.
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
