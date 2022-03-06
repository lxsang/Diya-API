Class {
	#name : #Diya2DShader,
	#superclass : #OpenGLSL,
	#category : #'Diya-Shaders'
}

{ #category : #accessing }
Diya2DShader class >> fragmentShader [ 
	^'
#ifdef GL_ES
  precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
// 2D uniforms
uniform int u_use_texture;
uniform vec4 u_color;
uniform vec4 u_border_color;
uniform sampler2D u_texture;
varying vec2 texcoord;
void main(void) {
	vec4 texcolor = vec4(1,1,1,1);
	if(u_use_texture == 1)
	{
		texcolor = vec4(1, 1, 1, texture2D(u_texture, texcoord).a);
	}
  gl_FragColor =  texcolor * u_color;
}'
]

{ #category : #accessing }
Diya2DShader class >> vertexShader [
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
Diya2DShader >> setUpUniforms [
	self addUniform: #u_texture of: Uniform1i.
	self addUniform: #u_use_texture of: Uniform1i.
	self addUniform: #u_color of: Uniform4F.
	self addUniform: #u_border_color of: Uniform4F.
	self addUniform: #u_border of: Uniform1i.
]
