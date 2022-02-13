Class {
	#name : #OpenGLVertexArray,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'vertexArrayID'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #'as yet unclassified' }
OpenGLVertexArray class >> bind:array [
	^self ffiCall:#(void glBindVertexArray(	GLuint array))
]

{ #category : #'as yet unclassified' }
OpenGLVertexArray class >> deteleVertexArraysSize:n arrays: arrays [
	^self ffiCall:#(void glDeleteVertexArrays(	GLsizei n,const GLuint *arrays))
]

{ #category : #'as yet unclassified' }
OpenGLVertexArray class >> disableArrayAttribute: vaobj index: index [
	^self ffiCall: #(void glDisableVertexArrayAttrib(	GLuint vaobj,GLuint index))
]

{ #category : #'as yet unclassified' }
OpenGLVertexArray class >> disableAttributeArray: index [
	^self ffiCall: #(void glDisableVertexAttribArray(	GLuint index))
]

{ #category : #'as yet unclassified' }
OpenGLVertexArray class >> enableArrayAttribute: vaobj index: index [
	^self ffiCall: #(void glEnableVertexArrayAttrib(	GLuint vaobj,GLuint index))
]

{ #category : #'as yet unclassified' }
OpenGLVertexArray class >> enableAttributeArray: index [
	^self ffiCall: #(void glEnableVertexAttribArray(	GLuint index))
]

{ #category : #'library path' }
OpenGLVertexArray class >> ffiLibraryName [ 
	^ OpenGL ffiLibraryName 
]

{ #category : #'as yet unclassified' }
OpenGLVertexArray class >> genVertexArraysSize: n arrays: arrays [
	^self ffiCall:#(void glGenVertexArrays(	GLsizei n,GLuint *arrays))
]

{ #category : #'as yet unclassified' }
OpenGLVertexArray class >> vertexAttributeLPointerIndex: index size: size type: type stride: stride pointer: pointer [
	^self ffiCall: #(void glVertexAttribLPointer(	GLuint index,GLint size,GLenum type,GLsizei stride,const void * pointer))
]

{ #category : #'as yet unclassified' }
OpenGLVertexArray class >> vertexAttributePointerIndex: index size: size type: type normalized: normalized stride: stride pointer: pointer [
	^self ffiCall: #(void glVertexAttribPointer(	GLuint index,GLint size,GLenum type,GLboolean normalized,GLsizei stride,const void * pointer))
]

{ #category : #'as yet unclassified' }
OpenGLVertexArray class >> vertexAttributelPointerIndex: index size: size type: type stride: stride pointer: pointer [
	^self ffiCall: #(void glVertexAttribIPointer(	GLuint index,GLint size,GLenum type,GLsizei stride,const void * pointer))
]

{ #category : #accessing }
OpenGLVertexArray >> bind [
	OpenGLVertexArray bind: self vertexArrayID
]

{ #category : #accessing }
OpenGLVertexArray >> delete [
	OpenGLVertexArray deteleVertexArraysSize:1 arrays: vertexArrayID.
	vertexArrayID at: 1 put: -1
]

{ #category : #'as yet unclassified' }
OpenGLVertexArray >> disableAttribute: index [
	^OpenGLVertexArray disableAttributeArray: index
]

{ #category : #'as yet unclassified' }
OpenGLVertexArray >> enableAttribute: index [
	^OpenGLVertexArray enableAttributeArray: index
]

{ #category : #initialization }
OpenGLVertexArray >> initialize [
	vertexArrayID := FFIExternalArray externalNewType: GLint size:1. 
	vertexArrayID autoRelease.
	vertexArrayID at:1 put: -1.
	OpenGLVertexArray genVertexArraysSize: 1 arrays: vertexArrayID.
	 
]

{ #category : #accessing }
OpenGLVertexArray >> vertexArrayID [
	^vertexArrayID at: 1
]
