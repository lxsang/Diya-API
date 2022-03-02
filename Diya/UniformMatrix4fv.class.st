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
		transpose: GL_FALSE
		value: value getHandle 
]
