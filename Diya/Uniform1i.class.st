Class {
	#name : #Uniform1i,
	#superclass : #OpenGLSLUniform,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #accessing }
Uniform1i >> setUniformValue [
	OpenGLSLUniform uniform1i: location value: value
]
