Class {
	#name : #OpenGLVertexBuffer,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'vertexBufferID'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer class >> bind: target buffer: buffer [
	^ self ffiCall: #(void glBindBuffer(	GLenum target,GLuint buffer))
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer class >> bufferData:target size: size data: data usage: usage [
	^self ffiCall: #(void glBufferData(	GLenum target,GLsizeiptr size,const void * data,GLenum usage))
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer class >> deleteBuffersSize:n buffers: buffers [
	^self ffiCall: #(void glDeleteBuffers(	GLsizei n,const GLuint * buffers))
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer class >> ffiLibraryName [ 
	^ OpenGL ffiLibraryName 
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer class >> genVertexBuffersSize:n buffers: buffers [
	^self ffiCall: #(void glGenBuffers(	GLsizei n,GLuint * buffers))
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer class >> getBufferData: target offset: offset size: size data: data [
	^self ffiCall: #(void glGetBufferSubData(GLenum target,GLintptr offset,GLsizeiptr size,void * data))
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer class >> namedBufferData:buffer size: size data: data usage: usage [
	^self ffiCall: #(void glNamedBufferData(GLuint buffer,GLsizeiptr size,const void *data,GLenum usage))
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer class >> subData:target offset: offset size: size data: data [
	^self ffiCall: #(void glBufferSubData(GLenum target,GLintptr offset,GLsizeiptr size,const void * data))
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer >> bind: target [
	^OpenGLVertexBuffer bind:target  buffer: self vertexBufferID 
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer >> data:target data: data size: size usage: usage [
	self bind: target.
	^OpenGLVertexBuffer bufferData: target size: size  data:(data ifNil:[data] ifNotNil: [data getHandle]) usage: usage 
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer >> data:target data: data usage: usage [
	self bind: target.
	^OpenGLVertexBuffer bufferData: target size: (data size) << 2  data:data getHandle usage: usage 
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer >> delete [ 
	OpenGLVertexBuffer deleteBuffersSize: 1 buffers:  vertexBufferID getHandle.
]

{ #category : #initialization }
OpenGLVertexBuffer >> initialize [
	vertexBufferID := FFIExternalArray externalNewType: GLint size:1. 
	vertexBufferID at:1 put: -1.
	vertexBufferID autoRelease.
	OpenGLVertexBuffer genVertexBuffersSize: 1 buffers: vertexBufferID getHandle
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer >> subData:target offset: offset data:data [
	self bind: target.
	^OpenGLVertexBuffer subData: target offset: offset size: (data size) << 2  data: data getHandle
]

{ #category : #'as yet unclassified' }
OpenGLVertexBuffer >> subData:target offset: offset data:data size: size [
	self bind: target.
	^OpenGLVertexBuffer subData: target offset: offset size: size  data: data getHandle
]

{ #category : #initialization }
OpenGLVertexBuffer >> vertexBufferID [
	^ vertexBufferID at: 1 
]
