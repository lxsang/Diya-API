Class {
	#name : #OpenGLSL,
	#superclass : #DiyaSingleton,
	#instVars : [
		'programID',
		'uniforms'
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

{ #category : #'instance creation' }
OpenGLSL class >> cleanUpInstance: singleton [
	singleton delete
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
OpenGLSL class >> getUniformLocation: uname ofProgram: program [
	^self ffiCall:#(GLint glGetUniformLocation(	GLuint program,const GLchar *uname))
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> linkProgram:program [
	^self ffiCall: #(void glLinkProgram(GLuint program))
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> setShaderSourceFor: shader count: n string: s length: l [
	^ self ffiCall: #(void glShaderSource(	GLuint shader,GLsizei n,const void* s,const GLint *l))
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> systemUniforms [
	^#(u_time u_resolution u_mouse)
]

{ #category : #'as yet unclassified' }
OpenGLSL class >> useProgram:program [
	^self ffiCall:#(void glUseProgram(GLuint program))
]

{ #category : #accessing }
OpenGLSL class >> vertextShader [
	^ self subclassResponsibility
]

{ #category : #initialization }
OpenGLSL >> addUniform: uname of: utype [
	uniforms at:uname put: (utype fromName: uname).
]

{ #category : #compiling }
OpenGLSL >> checkStatus:status of: id [
	|infoLength buffer result|
	result  := FFIExternalArray externalNewType: GLint size: 1.
	infoLength := FFIExternalArray externalNewType: GLint size: 1.
	infoLength autoRelease.
	result autoRelease.
	OpenGLSL getShaderiv: id parameterName: status  params: result getHandle.
	OpenGLSL getShaderiv: id parameterName: GL_INFO_LOG_LENGTH params:  infoLength getHandle.
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
	OpenGLSL deleteShader: vertexShaderID.
	OpenGLSL deleteShader: fragmentShaderID.
	self locateUniforms
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

{ #category : #compiling }
OpenGLSL >> getSourcePtr: string for: shaderId [
	|xarray|
	xarray := FFIExternalArray externalNewType: 'char*' size: 1. 
	xarray at:1 put: (ExternalAddress fromString: string). 
	xarray autoRelease.
	OpenGLSL setShaderSourceFor: shaderId count: 1 string: xarray getHandle length: nil.
]

{ #category : #'submorphs-add/remove' }
OpenGLSL >> getUniformLocation:uname [
	^ self class getUniformLocation: uname asString ofProgram: programID
]

{ #category : #initialization }
OpenGLSL >> initialize [
	super initialize.
	uniforms := Dictionary new.
	self addUniform: #u_time of: Uniform1F.
	self addUniform: #u_resolution of: Uniform2F.
	self addUniform: #u_mouse of: Uniform2F.
	self setUpUniforms.
	self compile
]

{ #category : #compiling }
OpenGLSL >> locateUniforms [
	|loc|
	uniforms valuesDo: [ :uniform|
		loc := self getUniformLocation: uniform uname.
		loc = -1 ifFalse:[uniform location: loc]
	]
]

{ #category : #initialization }
OpenGLSL >> setUniform: uname value: values [
	|uniform|
	uniform := uniforms at: uname asSymbol ifAbsent:[
		^self error: 'Uniform', uname, 'is not defined in this program'].
	uniform value: values
]

{ #category : #initialization }
OpenGLSL >> setUpUniforms [
	"do nothing, custom uniform can be set up by subclass"
]

{ #category : #'submorphs-add/remove' }
OpenGLSL >> use [
	^OpenGLSL useProgram: programID 
]
