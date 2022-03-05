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
	#ifdef GL_ES
precision mediump float;
#endif
uniform mat4 u_projection;
uniform mat3 u_transform;
varying vec2 texcoord;
void main()
{
	vec3 coord_global = u_transform * vec3(gl_Vertex.xy, 1.0);
	gl_Position = u_projection * vec4(coord_global.xy, 0, 1.0);
	texcoord = gl_Vertex.zw;
}'
]

{ #category : #initialization }
TotoShader >> setUpUniforms [
	self addUniform: #u_texture of: Uniform1i.
]
