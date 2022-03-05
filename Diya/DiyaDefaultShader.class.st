Class {
	#name : #DiyaDefaultShader,
	#superclass : #OpenGLSL,
	#category : #'Diya-Shaders'
}

{ #category : #accessing }
DiyaDefaultShader class >> fragmentShader [
	^ '
#ifdef GL_ES
precision mediump float;
#endif
void main()
{
    gl_FragColor = vec4(1.0,1.0,1.0,1.0);
}
'
]