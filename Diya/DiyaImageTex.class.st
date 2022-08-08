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
	Transcript show: 'Loading texture from ', aPath fullName;cr.
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
