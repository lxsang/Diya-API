Class {
	#name : #Uniform1F,
	#superclass : #OpenGLSLUniform,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #accessing }
Uniform1F >> setUniformValue [
	OpenGLSLUniform uniform1f: location value: value
]
