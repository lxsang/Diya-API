Class {
	#name : #OpenGLTexture,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'textureID',
		'unit'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #'as yet unclassified' }
OpenGLTexture class >> active: unit [
	^self ffiActive: GL_TEXTURE_UNIT_BASE + unit
]

{ #category : #'as yet unclassified' }
OpenGLTexture class >> bind: target texture: texture [
	^ self ffiCall: #(void glBindTexture(GLenum target,GLuint texture))
]

{ #category : #'as yet unclassified' }
OpenGLTexture class >> bindDefault: target [
	self bind: target texture: 0
]

{ #category : #'as yet unclassified' }
OpenGLTexture class >> delete: n pointer:textures [
	^ self ffiCall: #(void glDeleteTextures(GLsizei n,const GLuint * textures))
]

{ #category : #'as yet unclassified' }
OpenGLTexture class >> ffiActive: unit [
	^self ffiCall: #(void glActiveTexture(	GLenum unit))
]

{ #category : #'library path' }
OpenGLTexture class >> ffiLibraryName [ 
	^ OpenGL ffiLibraryName 
]

{ #category : #'as yet unclassified' }
OpenGLTexture class >> fromUnit: unit [
	^self new unit: unit; yourself
]

{ #category : #'as yet unclassified' }
OpenGLTexture class >> genTexture: n pointer: textures [
	^ self ffiCall: #(void glGenTextures(GLsizei n,GLuint * textures))
]

{ #category : #'as yet unclassified' }
OpenGLTexture class >> image2D: target level: level internalformat: internalformat w: width h: height border: border format: fmt type: type data: data [
	^ self ffiCall: #(void glTexImage2D(	GLenum target,GLint level,GLint internalformat,GLsizei width,GLsizei height,GLint border,GLenum fmt,GLenum type,const void * data))
]

{ #category : #'as yet unclassified' }
OpenGLTexture class >> parameteri: target pname: pname param: param [
	^ self ffiCall: #(void glTexParameteri(	GLenum target,GLenum pname,GLint param))
]

{ #category : #initialization }
OpenGLTexture >> active [
	self class active: self unit
]

{ #category : #initialization }
OpenGLTexture >> bind: target [
	^ self class bind: target texture: self textureID
	
]

{ #category : #initialization }
OpenGLTexture >> delete [
	self class delete: 1 pointer:  textureID getHandle.
	textureID  free.
]

{ #category : #initialization }
OpenGLTexture >> initialize [
	textureID := FFIExternalArray externalNewType: GLint size:1. 
	textureID autoRelease.
	textureID at:1 put: -1.
	self class genTexture: 1 pointer: textureID getHandle.
	unit := 0.
]

{ #category : #initialization }
OpenGLTexture >> setImage2D: tex2D [
	self active.
	self bind: tex2D target.
	self class image2D: tex2D target
		level: tex2D level
		internalformat: tex2D internalFormat
		w: tex2D width
		h: tex2D height
		border: tex2D border
		format: tex2D format
		type: tex2D type
		data: tex2D data
]

{ #category : #initialization }
OpenGLTexture >> textureID [
	^textureID at: 1
]

{ #category : #accessing }
OpenGLTexture >> unit [
	^ unit
]

{ #category : #accessing }
OpenGLTexture >> unit: anObject [
	unit := anObject
]
