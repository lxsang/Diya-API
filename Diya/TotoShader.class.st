Class {
	#name : #TotoShader,
	#superclass : #OpenGLSL,
	#category : #'Diya-Shaders'
}

{ #category : #'as yet unclassified' }
TotoShader class >> fragmentShader [ 
	^'
#version 330 core
in vec2 TexCoords;

uniform sampler2D text;

void main()
{    
    vec4 sampled = vec4(1.0, 1.0, 1.0, texture(text, TexCoords).r);
    gl_FragColor = vec4(1.0,1.0,1.0, 1.0) * sampled;
} '
]

{ #category : #'as yet unclassified' }
TotoShader class >> vertexShader [
	^'
#version 330 core
layout (location = 0) in vec4 vertex; // <vec2 pos, vec2 tex>
out vec2 TexCoords;

uniform mat4 u_projection;

void main()
{
    gl_Position = u_projection * vec4(vertex.xy, 0.0, 1.0);
    TexCoords = vertex.zw;
}  '
]
