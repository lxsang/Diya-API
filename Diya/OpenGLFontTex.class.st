Class {
	#name : #OpenGLFontTex,
	#superclass : #OpenGLTexImage2D,
	#instVars : [
		'charmap',
		'cellw',
		'cellh',
		'spacing',
		'fontSize',
		'colp',
		'rowp',
		'face',
		'maxbearing',
		'maxrows',
		'meanww'
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

{ #category : #processing }
OpenGLFontTex >> blitPixel8: bitmap at: offset size: size [
	size = (0@0) ifTrue:[^self].
	0 to: size y - 1 do: [ :i|
			LibC memCopy: (bitmap getHandle + (i* (size x))) to:(data getHandle + ((i + offset y) * width + (offset x) ))  size: size x
	].
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

{ #category : #accessing }
OpenGLFontTex >> drop [
	OpenGL
		pixelstorei: GL_UNPACK_ALIGNMENT param: 4";
		disable: GL_CULL_FACE;
		disable: GL_BLEND".
]

{ #category : #accessing }
OpenGLFontTex >> fontSize [
	^ fontSize
]

{ #category : #'instance creation' }
OpenGLFontTex >> fromFace: aFace  ofSize: size [
	|minhang rec iptr charcode w numw|
	fontSize := size.
	face := aFace.
	commited := false.
	name := aFace familyName, '@', aFace styleName,'@', size asString.
	charmap := Dictionary new.
	face setPixelWidth:0 height: self fontSize.
	cellw := cellh := minhang := maxbearing := 0.
	iptr := FFIExternalArray externalNewType: GLuint size:1.
	iptr at:1 put: 0.
	rec := (FTFaceRec fromHandle: face getHandle).
	charcode := face getFirstChar: iptr getHandle.
	meanww := 0.
	numw := 0.
	[ (iptr at: 1) = 0 ] whileFalse: [
		face loadCharacter: charcode flags: (1 << 2).
		w := ((rec glyph metrics width) >> 6).
		(w > (size << 1)) ifFalse:[
			maxbearing := maxbearing max:  ((rec glyph metrics horiBearingY) >> 6).
			cellw := cellw max: w.
			minhang := minhang min: ((( rec glyph metrics horiBearingY) - (rec glyph metrics height)) >> 6).
			meanww := meanww + w.
			numw := numw + 1.
		].
		charcode := face getNextChar: charcode iptr: iptr getHandle.
	].
	cellh := maxbearing - minhang.
	spacing := (cellw >> 2) asInteger.
	meanww := meanww / numw.
	maxrows := 8.
	data := FFIExternalArray externalNewType: GLubyte size:cellw * cellh * (maxrows << 5).
	LibC memset: data getHandle value: 0 size: data size.
	width := cellw << 5.
	height := cellh.
	data autoRelease.
	iptr free.
]

{ #category : #processing }
OpenGLFontTex >> genGlyph:c [
	|rec  offset glyph gsize|
	face setPixelWidth:0 height: self fontSize. 
	face loadCharacter: c flags: (1 << 2).
	rec := (FTFaceRec fromHandle: face getHandle).
	gsize := ((rec glyph metrics width) >> 6)@((rec glyph metrics height) >> 6).
	offset := (colp * cellw) @ (rowp*cellh).
	glyph := (DiyaFontGlyph  origin: offset extent: ((gsize x)  @ cellh)).
	glyph
		bearing: face glyph hBearing asFloatPoint;
		advance: face glyph advance;
		tex: self.
	self blitPixel8: rec glyph bitmap buffer at: (offset x) @ ((offset y) + maxbearing - ((rec glyph metrics horiBearingY) >> 6) ) size: gsize.
	colp := (colp + 1) % 32.
	colp = 0 ifTrue:[
		rowp := rowp + 1.
		height := height + cellh.
		rowp >= maxrows ifTrue:[
			self reallocateBuffer.
		]. 
	].
	commited := false.
	^glyph
	
]

{ #category : #processing }
OpenGLFontTex >> genPrintableASCII [
	33 to: 126 do: [ :c| self genGlyph: c ]
]

{ #category : #accessing }
OpenGLFontTex >> getGlyph: c [
	^(self charmap at: c ifAbsentPut:[
		self genGlyph:c])
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
	colp := 0.
	rowp := 0.
]

{ #category : #accessing }
OpenGLFontTex >> linespace [
	^ cellh
]

{ #category : #accessing }
OpenGLFontTex >> meanww [
	^ meanww
]

{ #category : #processing }
OpenGLFontTex >> reallocateBuffer [
	|newbuffer|
	maxrows := maxrows + 4.
	newbuffer := FFIExternalArray externalNewType: GLubyte size:cellw * cellh * (maxrows << 5).
	LibC memset: newbuffer getHandle value: 0 size: newbuffer size.
	LibC memCopy: data getHandle to: newbuffer getHandle size: data size.
	newbuffer autoRelease.
	data free.
	data := newbuffer 
	
]

{ #category : #initialization }
OpenGLFontTex >> setup [
	OpenGL
		"enable: GL_CULL_FACE;
		enable: GL_BLEND;
		blendFnWithSfactor: GL_SRC_ALPHA dfactor: GL_ONE_MINUS_SRC_ALPHA;"
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
