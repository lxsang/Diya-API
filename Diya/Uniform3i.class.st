Class {
	#name : #Uniform3i,
	#superclass : #OpenGLSLUniform,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #accessing }
Uniform3i >> setUniformValue [
	OpenGLSLUniform uniform3i: location value: value first value: (value at:2) value: value last
]
