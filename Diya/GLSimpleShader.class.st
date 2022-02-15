Class {
	#name : #GLSimpleShader,
	#superclass : #OpenGLSL,
	#category : #'Diya-Shaders'
}

{ #category : #accessing }
GLSimpleShader class >> fragmentShader [
	^ '
#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
void main()
{
    vec2 mouse = vec2(u_mouse)/vec2(u_resolution);
    gl_FragColor = vec4(mouse.x, mouse.y, abs(sin(u_time)), 1.0);
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
