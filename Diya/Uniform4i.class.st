Class {
	#name : #Uniform4i,
	#superclass : #OpenGLSLUniform,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #accessing }
Uniform4i >> setUniformValue [
	OpenGLSLUniform uniform4i: location
		value: value first
		value: (value at:2)
		value: (value at:3)
		value: value last
]
