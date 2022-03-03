Class {
	#name : #GLTexShader,
	#superclass : #OpenGLSL,
	#category : #'Diya-Shaders'
}

{ #category : #accessing }
GLTexShader class >> fragmentShader [
	^ '
#ifdef GL_ES
precision mediump float;
#endif
uniform sampler2D u_texture;
uniform vec2 u_resolution;

void main(){
    //vec2 uv = gl_FragCoord.xy / u_resolution;
	 vec4 sampled = vec4(1.0, 1.0, 1.0, texture2D(u_texture,gl_FragCoord.zw).r);
    gl_FragColor = vec4(1.0,1.0,1.0,1.0)* sampled; //texture2D(u_texture,uv.xy);
}

'
]
