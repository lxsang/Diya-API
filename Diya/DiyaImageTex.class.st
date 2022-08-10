Class {
	#name : #DiyaImageTex,
	#superclass : #OpenGLTexImage2D,
	#instVars : [
		'name',
		'surface'
	],
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

{ #category : #capture }
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

{ #category : #capture }
DiyaImageTex >> fromDisplay:  aRect as: assetName [
	surface ifNotNil: [ surface free ] ifNil: [data ifNotNil: [data free]].
	surface := nil.
	width := aRect extent x asInteger.
	height := aRect extent y asInteger.
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

{ #category : #capture }
DiyaImageTex >> fromDisplayAs: assetName [
	self fromDisplay: (Rectangle origin: 0@0 extent: DiyaDisplay extent ) as: assetName 
]

{ #category : #'instance creation' }
DiyaImageTex >> fromFile: aPath [
	Transcript show: 'Loading texture from ', aPath fullName;cr.
	name := aPath.
	aPath exists ifFalse: [ ^DiyaCoreAPIError signal:'File not found ', aPath fullName ].
	surface := SDL2Image SDLImgLoad: aPath fullName.
	surface ifNil: [ ^DiyaCoreAPIError signal:'Unable to load ', aPath fullName ].
	width := surface w.
	height := surface h.
	data := surface pixels.
	surface autoRelease.
	Transcript show: 'Loaded ', aPath fullName;cr.
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
DiyaImageTex >> name [
	^ name
]

{ #category : #accessing }
DiyaImageTex >> setup [
	OpenGLTexture
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_S param: GL_CLAMP_TO_EDGE;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_T param: GL_CLAMP_TO_EDGE;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MIN_FILTER param: GL_LINEAR;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MAG_FILTER param: GL_LINEAR.
]

{ #category : #accessing }
DiyaImageTex >> surface [
	^ surface
]
