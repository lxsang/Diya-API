Class {
	#name : #Uniform2i,
	#superclass : #OpenGLSLUniform,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #accessing }
Uniform2i >> setUniformValue: value [
	OpenGLSLUniform uniform2i: location value: value first value: value last
]
