Class {
	#name : #OpenGLTypes,
	#superclass : #SharedPool,
	#classVars : [
		'GLbitfield',
		'GLboolean',
		'GLbyte',
		'GLchar',
		'GLclampd',
		'GLclampf',
		'GLdouble',
		'GLenum',
		'GLfixed',
		'GLfloat',
		'GLhalf',
		'GLint',
		'GLint64',
		'GLintptr',
		'GLshort',
		'GLsizei',
		'GLsizeiptr',
		'GLsync',
		'GLubyte',
		'GLuint',
		'GLuint64',
		'GLushort'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #'class initialization' }
OpenGLTypes class >> initialize [ 
	GLfloat := #float.
	GLubyte := #uint8.
	GLenum := #int32.
	GLboolean := #uint8.
	GLbitfield := #int32.
	GLbyte := #int8.
	GLclampd := #double.
	GLclampf := #float.
	GLdouble := #double.
	GLfixed := #int32.
	GLhalf := #uint16.
	GLint := #int32.
	GLint64 := #int64.
	GLintptr := Smalltalk wordSize = 8 ifTrue: [ #int64 ] ifFalse: [ #int32 ].
	GLshort := #int16.
	GLsizei := #int32.
	GLsizeiptr := Smalltalk wordSize = 8 ifTrue: [ #int64 ] ifFalse: [ #int32 ].
	GLsync := Smalltalk wordSize = 8 ifTrue: [ #int64 ] ifFalse: [ #int32 ].
	GLuint := #uint32.
	GLuint64 := #uint64.
	GLushort := #uint16.
	GLchar := #char.
]
