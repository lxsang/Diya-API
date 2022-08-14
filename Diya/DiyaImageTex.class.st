Class {
	#name : #DiyaImageTex,
	#superclass : #OpenGLTexImage2D,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'instance creation' }
DiyaImageTex class >> fromDisplay:  aRect as: assetName [
	^ self new fromDisplay: aRect as: assetName; yourself 
]

{ #category : #'instance creation' }
DiyaImageTex class >> fromDisplayAs: assetName [
	^ self new fromDisplayAs: assetName; yourself 
]

{ #category : #'instance creation' }
DiyaImageTex class >> fromFile: path [
	^ self new fromFile: path; yourself
]

{ #category : #accessing }
DiyaImageTex >> drop [
	"OpenGL
		disable: GL_CULL_FACE;
		disable: GL_BLEND."
]

{ #category : #conversion }
DiyaImageTex >> flipY [
	|buffer size linesize top bottom|
	size := self bytesSize.
	linesize := width << 2.
	buffer := FFIExternalArray externalNewType: GLubyte size: linesize.
	LibC memset: buffer getHandle value: 0 size: buffer size.
	0 to: (height >> 1) -1 do: [ :line|
		top := line * linesize.
		bottom := (size - (linesize * (line + 1))).
		LibC memCopy: (data getHandle) + top to: buffer getHandle size: linesize.
		LibC memCopy: (data getHandle) + bottom to: (data getHandle) + top size: linesize.
		LibC memCopy: buffer getHandle to: (data getHandle) + bottom size: linesize.
	].
	buffer free
]

{ #category : #'instance creation' }
DiyaImageTex >> fromDisplay:  aRect as: assetName [
	data ifNotNil: [data free].
	width := aRect extent x asInteger.
	height := aRect extent y asInteger.
	commited := false.
	data := FFIExternalArray externalNewType: GLubyte size: self bytesSize.
	LibC memset: data getHandle value: 0 size: data size.
	data autoRelease.
	OpenGL readPixelsOn: data getHandle
		x: aRect origin x
		y: (DiyaDisplay height) - (aRect origin y) - (aRect extent y)
		w: aRect extent x
		h: aRect extent y
		format:GL_RGBA
		type: GL_UNSIGNED_BYTE.
	name := assetName.
	self flipY.
]

{ #category : #'instance creation' }
DiyaImageTex >> fromDisplayAs: assetName [
	self fromDisplay: (Rectangle origin: 0@0 extent: DiyaDisplay extent ) as: assetName 
]

{ #category : #'instance creation' }
DiyaImageTex >> fromFile: aPath [
	|surface|
	self stdlog: 'Loading texture from ', aPath fullName.
	data ifNotNil: [ data free ].
	name := aPath fullName.
	surface := self surfaceFromFile: aPath.
	width := surface w.
	height := surface h.
	data := FFIExternalArray externalNewType: GLubyte size: self bytesSize.
	LibC memset: data getHandle value: 0 size: data size.
	data autoRelease.
	LibC memCopy: surface pixels getHandle to: data getHandle size: data size.
	SDL2 
		freeSurface: surface.
	commited := false.
	self stdlog: 'Loaded ', aPath fullName.
]

{ #category : #'instance creation' }
DiyaImageTex >> fromForm: aForm name: aName [
	|surface|
	name := aName.
	data ifNotNil: [ data free ].
	surface := self surfaceFromForm: aForm.
	width := surface w.
	height := surface h.
	commited := false.
	data := FFIExternalArray externalNewType: GLubyte size: self bytesSize.
	LibC memset: data getHandle value: 0 size: data size.
	data autoRelease.
	LibC memCopy: surface pixels getHandle to: data getHandle size: data size.
	SDL2 
		freeSurface: surface.
]

{ #category : #'instance creation' }
DiyaImageTex >> initialize [
	super initialize.
	level := 0.
	border := 0.
	format := GL_RGBA.
	internalFormat := GL_RGBA.
	type := GL_UNSIGNED_BYTE.
	target := GL_TEXTURE_2D.
]

{ #category : #accessing }
DiyaImageTex >> mipmap [
	^false
]

{ #category : #accessing }
DiyaImageTex >> setup [
	OpenGLTexture
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_S param: GL_CLAMP_TO_EDGE;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_T param: GL_CLAMP_TO_EDGE;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MIN_FILTER param: GL_LINEAR;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MAG_FILTER param: GL_LINEAR.
]

{ #category : #conversion }
DiyaImageTex >> surfaceFromFile: aPath [
	aPath exists ifFalse: [ ^DiyaCoreAPIError signal:'File not found ', aPath fullName ].
	[^ SDL2Image SDLImgLoad: aPath fullName] on: Error do: [
		^  self surfaceFromForm:  (ImageReadWriter formFromFileNamed: aPath)
	].
]

{ #category : #conversion }
DiyaImageTex >> surfaceFromForm: aForm [
	|srcSurface destSurface  form|
	form := aForm asFormOfDepth: 32.
	srcSurface :=
		SDL2 createRGBSurfaceFromPixels: form bits
			width: form width height: form height
			depth: 32 pitch: (form width << 2)
			rmask: 16r00ff0000 
			gmask: 16r000ff00
			bmask: 16r00000ff
			amask: 16rff000000.
	destSurface :=
		SDL2 createRGBSurfaceFromPixels: srcSurface pixels getHandle
			width: form width height: form height
			depth: 32 pitch: (form width << 2)
			rmask: 16r000000ff 
			gmask: 16r0000ff00
			bmask: 16r00ff0000
			amask: 16rff000000.
	SDL2 SDLBlitSurface: srcSurface srcRect: nil dest: destSurface  dstRect: nil.
	SDL2 
		freeSurface: srcSurface.
	^ destSurface
]
