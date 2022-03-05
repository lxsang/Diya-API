Class {
	#name : #UniformMatrix4fv,
	#superclass : #OpenGLSLUniform,
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #accessing }
UniformMatrix4fv >> setUniformValue [
	OpenGLSLUniform
		uniformMatrix4fv: location
		count: 1
		transpose: value first
		value: value last getHandle 
]