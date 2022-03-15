Class {
	#name : #Uniform3F,
	#superclass : #OpenGLSLUniform,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #accessing }
Uniform3F >> setUniformValue: value [
	OpenGLSLUniform uniform3f: location value: value first value: (value at:2) value: value last
]
