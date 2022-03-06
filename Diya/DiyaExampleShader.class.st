Class {
	#name : #DiyaExampleShader,
	#superclass : #Diya2DShader,
	#category : #'Diya-Shaders'
}

{ #category : #accessing }
DiyaExampleShader class >> fragmentShader [
	^ '
#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
void main()
{
	vec2 mouse = u_mouse / u_resolution;
   vec2 px = (gl_FragCoord.xy/u_resolution);
    gl_FragColor = vec4(px/mouse, abs(sin(u_time)), 1.0);
}
'
]
