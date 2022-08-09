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

{ #category : #'as yet unclassified' }
OpenGL class >> blendFnOn:buf sfactor: sfactor dfactor: dfactor [
	^ self ffiCall: #(void glBlendFunci(	GLuint buf,GLenum sfactor,GLenum dfactor))
]

{ #category : #'as yet unclassified' }
OpenGL class >> blendFnWithSfactor: sfactor dfactor: dfactor [
	^ self ffiCall: #(void glBlendFunc(	GLenum sfactor,GLenum dfactor))
]

{ #category : #accessing }
OpenGL class >> checkSymbol [
	^#glDrawArrays
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

{ #category : #'as yet unclassified' }
OpenGL class >> disable: cap [
	^ self ffiCall: #(void glDisable(	GLenum cap))
]

{ #category : #'as yet unclassified' }
OpenGL class >> drawArrays: mode first: idx count:n [
	^self ffiCall: #(void glDrawArrays(GLenum mode,GLint idx,GLsizei n))
]

{ #category : #'as yet unclassified' }
OpenGL class >> enable: cap [
	^ self ffiCall: #(void glEnable(	GLenum cap))
]

{ #category : #accessing }
OpenGL class >> end [
	^ self ffiCall: #(void glEnd( void ))
]

{ #category : #'as yet unclassified' }
OpenGL class >> getError [
	^self ffiCall: #(GLenum glGetError(	void))
]

{ #category : #'as yet unclassified' }
OpenGL class >> getIntegerv: pname data: data [
	^self ffiCall: #(void glGetIntegerv(	GLenum pname,GLint * data))
]

{ #category : #'as yet unclassified' }
OpenGL class >> hint:target mode:mode [
	^self ffiCall: #(void glHint(	GLenum target,GLenum mode))
]

{ #category : #accessing }
OpenGL class >> libNames [
	^#('libGL.so.1')
]

{ #category : #geometry }
OpenGL class >> lineWidth: width [
	^ self ffiCall: #(void glLineWidth(GLfloat width))
]

{ #category : #accessing }
OpenGL class >> pixelstorei: pname param: param [
	^self ffiCall: #(void glPixelStorei(	GLenum pname,GLint param))
]

{ #category : #geometry }
OpenGL class >> readPixelsOn: buffer x:x y: y w:w h:h format: fmt type: type [
	^ self ffiCall: #(void glReadPixels(	GLint x,GLint y,GLsizei w,GLsizei h,GLenum fmt,GLenum type,void * buffer))
]

{ #category : #accessing }
OpenGL class >> vertex3fX:x Y:y Z:z [
	^self ffiCall: #(void glVertex3f(	GLfloat x,GLfloat y,GLfloat z))
]

{ #category : #'as yet unclassified' }
OpenGL class >> viewportX: x Y:y W: width H:height [
	^ self ffiCall: #(void glViewport(GLint x,GLint y,GLsizei width,GLsizei height))
]
