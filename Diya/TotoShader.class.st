Class {
	#name : #TotoShader,
	#superclass : #OpenGLSL,
	#category : #'Diya-Shaders'
}

{ #category : #'as yet unclassified' }
TotoShader class >> fragmentShader [ 
	^'
#ifdef GL_ES
  precision highp float;
#endif

varying vec2 texcoord;
uniform sampler2D u_texture;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
void main(void) {
  gl_FragColor = vec4(1, 1, 1, texture2D(u_texture, texcoord).a) * vec4(1,1,1,1);
}'
]

{ #category : #'as yet unclassified' }
TotoShader class >> vertexShader [
	^'
varying vec2 texcoord;
uniform mat4 u_projection;
void main(void) {
  gl_Position = u_projection  * vec4(gl_Vertex.xy, 0, 1);
  texcoord = gl_Vertex.zw;
}'
]

{ #category : #initialization }
TotoShader >> setUpUniforms [
	self addUniform: #u_texture of: Uniform1i.
]
