Class {
	#name : #OpenGLSLUniform,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'uname',
		'location'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> ffiLibraryName [ 
	^ OpenGL ffiLibraryName 
]

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> fromName: uname [
	^self new uname: uname; yourself
]

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> fromName: uname at: location [
	^self new uname: uname; location: location; yourself
]

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> uniform1f: location value: v0 [
	^self ffiCall: #(void glUniform1f(GLint location,GLfloat v0))
]

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> uniform1i: location value: v0 [ 
	^self ffiCall: #(void glUniform1i(GLint location,GLint v0))
]

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> uniform2f: location value: v0 value: v1 [
	^self ffiCall: #(void glUniform2f(GLint location,GLfloat v0,GLfloat v1))
]

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> uniform2i: location value: v0 value: v1 [
	^self ffiCall: #(void glUniform2i(GLint location,GLint v0,GLint v1))
]

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> uniform3f: location value: v0 value: v1 value: v2 [
	^self ffiCall: #(void glUniform3f(GLint location,GLfloat v0,GLfloat v1,GLfloat v2))
]

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> uniform3i: location value: v0 value: v1 value: v2 [
	^self ffiCall: #(void glUniform3i(GLint location,GLint v0,GLint v1,GLint v2))
]

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> uniform4f: location value: v0 value: v1 value: v2 value: v3 [
	^self ffiCall: #(void glUniform4f(GLint location,GLfloat v0,GLfloat v1,GLfloat v2, GLfloat v3))
]

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> uniform4i: location value: v0 value: v1 value: v2 value: v3 [
	^self ffiCall: #(void glUniform4i(GLint location,GLint v0,GLint v1,GLint v2, GLint v3))
]

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> uniformMatrix3fv: location count: count transpose: transpose value: value [
	^self ffiCall: #(void glUniformMatrix3fv(GLint location,GLsizei count,GLboolean transpose,const GLfloat *value))
]

{ #category : #'as yet unclassified' }
OpenGLSLUniform class >> uniformMatrix4fv: location count: count transpose: transpose value: value [
	^self ffiCall: #(void glUniformMatrix4fv(GLint location,GLsizei count,GLboolean transpose,const GLfloat *value))
]

{ #category : #accessing }
OpenGLSLUniform >> location [
	^ location
]

{ #category : #accessing }
OpenGLSLUniform >> location: anObject [
	location := anObject
]

{ #category : #accessing }
OpenGLSLUniform >> setUniformValue: value [
	 ^ self subclassResponsibility
 	
]

{ #category : #accessing }
OpenGLSLUniform >> uname [
	^ uname
]

{ #category : #accessing }
OpenGLSLUniform >> uname: anObject [
	uname := anObject
]

{ #category : #accessing }
OpenGLSLUniform >> value: values [
	location = -1 ifTrue: [ ^self ].
	self setUniformValue: values.
 	
]
