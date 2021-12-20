Class {
	#name : #OpenGL,
	#superclass : #DiyaFFIBase,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #accessing }
OpenGL class >> begin: mode [
	^ self ffiCall: #(void glBegin(GLenum mode))
]

{ #category : #accessing }
OpenGL class >> checkSymbol [
	^#glBegin
]

{ #category : #'as yet unclassified' }
OpenGL class >> clear: mask [
	^ self ffiCall: #(void glClear(GLbitfield mask))
]

{ #category : #'as yet unclassified' }
OpenGL class >> clearColorR: red G: green B: blue A:alpha [
	^self ffiCall: #(void glClearColor(	GLclampf red,GLclampf green,GLclampf blue,GLclampf alpha))
]

{ #category : #accessing }
OpenGL class >> color3fR: red G: green B: blue [
	^self ffiCall: #(void glColor3f(GLfloat red,GLfloat green,GLfloat blue))
]

{ #category : #accessing }
OpenGL class >> end [
	^ self ffiCall: #(void glEnd( void ))
]

{ #category : #accessing }
OpenGL class >> libNames [
	^#('libGL.so.1')
]

{ #category : #accessing }
OpenGL class >> vertex3fX:x Y:y Z:z [
	^self ffiCall: #(void glVertex3f(	GLfloat x,GLfloat y,GLfloat z))
]

{ #category : #'as yet unclassified' }
OpenGL class >> viewportX: x Y:y W: width H:height [
	^ self ffiCall: #(void glViewport(GLint x,GLint y,GLsizei width,GLsizei height))
]