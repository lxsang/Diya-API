Class {
	#name : #UniformMatrix3fv,
	#superclass : #OpenGLSLUniform,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #accessing }
UniformMatrix3fv >> setUniformValue: value [
	OpenGLSLUniform
		uniformMatrix3fv: location
		count: 1
		transpose: value first
		value: value last getHandle 
]
