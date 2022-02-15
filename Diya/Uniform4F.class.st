Class {
	#name : #Uniform4F,
	#superclass : #OpenGLSLUniform,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #accessing }
Uniform4F >> setUniformValue [
	OpenGLSLUniform uniform4f: location
		value: value first
		value: (value at:2)
		value: (value at:3)
		value: value last
]
