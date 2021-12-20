Class {
	#name : #OpenGLSL,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'programID'
	],
	#classVars : [
		'singleton'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #'as yet unclassified' }
OpenGLSL class >> attachShader: shader to: program [
	^self ffiCall: #(void glAttachShader(GLuint program,GLuint shader))
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> compileShader: shader [
	^ self ffiCall: #(void glCompileShader(	GLuint shader))
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> createProgram [
	^self ffiCall: #(GLuint glCreateProgram(void))
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> createShader: shaderType [
	^ self ffiCall: #(GLuint glCreateShader(	GLenum shaderType))
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> deleteProgram: program [
	^self ffiCall: #(void glDeleteProgram(GLuint program))
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> deleteShader: shader [
	^ self ffiCall: #(void glDeleteShader(	GLuint shader))
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> detachShaderFrom: program shader:shader [
	^ self ffiCall: #(void glDetachShader(GLuint program,GLuint shader))
]

{ #category : #'library path' }
OpenGLSL class >> ffiLibraryName [ 
	^ OpenGL ffiLibraryName 
]

{ #category : #accessing }
OpenGLSL class >> fragmentShader [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> getProgramInfoLogOf: prog maxLength: maxLength lengthPtr: length buffer: infoLog [
	^self ffiCall:#(void glGetProgramInfoLog(GLuint prog,GLsizei maxLength,GLsizei *length,GLchar *infoLog))
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> getShaderInfoLogOf: shader maxLength: maxLength lengthPtr: length buffer: infoLog [
	^self ffiCall:#(void glGetShaderInfoLog(GLuint shader,GLsizei maxLength,GLsizei *length,GLchar *infoLog))
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> getShaderiv:shader parameterName: pname params: ptr [
	^ self ffiCall: #(void glGetShaderiv(GLuint shader,GLenum pname,GLint *ptr))
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> linkProgram:program [
	^self ffiCall: #(void glLinkProgram(GLuint program))
]

{ #category : #'instance creation' }
OpenGLSL class >> new [
	self error: 'Use #uniqueInstance'
]

{ #category : #'instance creation' }
OpenGLSL class >> reset [
	singleton ifNotNil: [ 
		singleton delete.
	].
	singleton := nil
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> setShaderSourceFor: shader count: n string: s length: l [
	^ self ffiCall: #(void glShaderSource(	GLuint shader,GLsizei n,const char ** s,const GLint *l))
]

{ #category : #'instance creation' }
OpenGLSL class >> uniqueInstance [
	singleton ifNil: [ singleton := super new. singleton compile ].
	^ singleton
]

{ #category : #accessing }
OpenGLSL class >> vertextShader [
	^ self subclassResponsibility
]

{ #category : #compiling }
OpenGLSL >> checkStatus:status of: id [
	|infoLength buffer|
	infoLength := FFIExternalArray externalNewType: #GLint size: 1.
	infoLength autoRelease.
	OpenGLSL getShaderiv: id parameterName: status  params: nil.
	OpenGLSL getShaderiv: id parameterName: GL_INFO_LOG_LENGTH params:  infoLength.
	(infoLength at:1) > 0 ifTrue: [
		"report the error"
		buffer := ByteArray new:(infoLength at: 1).
		id = programID ifTrue: [
			OpenGLSL getProgramInfoLogOf: id maxLength: (infoLength at: 1) lengthPtr: nil  buffer: buffer
		] ifFalse: [ 
			OpenGLSL getShaderInfoLogOf: id maxLength: (infoLength at: 1) lengthPtr: nil  buffer: buffer
		].
		^self error: buffer asString
	].
	^self
	
]

{ #category : #compiling }
OpenGLSL >> compile [
	|vertexShaderID fragmentShaderID|
	vertexShaderID := OpenGLSL createShader: GL_VERTEX_SHADER.
	fragmentShaderID := OpenGLSL createShader: GL_FRAGMENT_SHADER.
	self compileVertexShader: vertexShaderID.
	self compileFragmentShader: fragmentShaderID.
	programID := OpenGLSL createProgram.
	OpenGLSL attachShader: vertexShaderID to: programID.
	OpenGLSL attachShader: fragmentShaderID to: programID.
	OpenGLSL linkProgram: programID.
	self checkStatus: GL_LINK_STATUS of: programID.
	OpenGLSL detachShaderFrom: programID  shader: vertexShaderID.
	OpenGLSL detachShaderFrom: programID  shader: fragmentShaderID.
	
]

{ #category : #compiling }
OpenGLSL >> compileFragmentShader:fragmentShaderID [
	self getSourcePtr:self class fragmentShader   for: fragmentShaderID.
	OpenGLSL compileShader: fragmentShaderID.
	self checkStatus:GL_COMPILE_STATUS of: fragmentShaderID
	
]

{ #category : #compiling }
OpenGLSL >> compileVertexShader: vertexShaderID [
	self getSourcePtr:self class vertextShader  for: vertexShaderID.
	OpenGLSL compileShader: vertexShaderID.
	self checkStatus:GL_COMPILE_STATUS of: vertexShaderID
	
]

{ #category : #'submorphs-add/remove' }
OpenGLSL >> delete [
	OpenGLSL deleteProgram: programID
]

{ #category : #'library path' }
OpenGLSL >> ffiLibraryName [
	^self class ffiLibraryName 
]

{ #category : #compiling }
OpenGLSL >> getSourcePtr: string for: shaderId [
	|cstr i ptr |
	cstr :=  FFIExternalArray externalNewType: #uint8 size: string size + 1.
	cstr autoRelease.
	i := 1.
	(string asByteArray copyWith: 0) do: [ :e|
		cstr at: i put: e.
		i := i+1.
	].
	ptr := FFIExternalArray externalNewType: #GLintptr size:  1.
	ptr autoRelease.
	ptr at: 1 put: cstr pointer value.
	OpenGLSL setShaderSourceFor: shaderId count: 1 string: ptr  length: nil.
]

{ #category : #'submorphs-add/remove' }
OpenGLSL >> use [
	^self ffiCall: #(void glUseProgram(	GLuint program)) 
]
