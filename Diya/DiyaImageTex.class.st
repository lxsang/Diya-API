Class {
	#name : #DiyaImageTex,
	#superclass : #OpenGLTexImage2D,
	#instVars : [
		'path'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-Graphics'
}

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

{ #category : #'instance creation' }
DiyaImageTex >> fromFile: aPath [
	|form color index|
	path := aPath.
	Transcript show: 'Loading texture from ', path fullName;cr.
	form := ImageReadWriter formFromFileNamed: path.
	data := FFIExternalArray externalNewType: GLubyte size:(form width) * (form height) * 4.
	LibC memset: data getHandle value: 0 size: data size.
	data autoRelease.
	width := form width.
	height := form height.
	index := 1.
	0 to: height -1 do:[:y|
		0 to: width - 1 do:[:x|
			color := (form colorAt: x@y) as4bytesRGB.
			data
				at: index put: color first;
				at: index + 1 put: (color at: 2);
				at: index +2 put: (color at: 3);
				at: index + 3 put: color last.
			index := index + 4.
		]
	].
	
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
DiyaImageTex >> path [
	^ path
]

{ #category : #accessing }
DiyaImageTex >> setup [
	OpenGLTexture
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_S param: GL_CLAMP_TO_EDGE;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_T param: GL_CLAMP_TO_EDGE;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MIN_FILTER param: GL_LINEAR;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MAG_FILTER param: GL_LINEAR.
]
