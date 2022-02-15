Class {
	#name : #Uniform2F,
	#superclass : #OpenGLSLUniform,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #accessing }
Uniform2F >> setUniformValue [
	OpenGLSLUniform uniform2f: location value: value first value: value last
]
