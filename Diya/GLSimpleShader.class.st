Class {
	#name : #GLSimpleShader,
	#superclass : #OpenGLSL,
	#category : #'Diya-Shaders'
}

{ #category : #accessing }
GLSimpleShader class >> fragmentShader [
	^ '
void main()
{
	gl_FragColor = vec4(0.4,0.4,0.8,1.0);
}
'
]

{ #category : #accessing }
GLSimpleShader class >> vertextShader [
	^ '
void main()
{
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
'
]
