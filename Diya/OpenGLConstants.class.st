Class {
	#name : #OpenGLConstants,
	#superclass : #SharedPool,
	#classVars : [
		'GL_ACCUM_BUFFER_BIT',
		'GL_COLOR_BUFFER_BIT',
		'GL_DEPTH_BUFFER_BIT',
		'GL_LINES',
		'GL_LINE_LOOP',
		'GL_LINE_STRIP',
		'GL_POINTS',
		'GL_POLYGON',
		'GL_QUADS',
		'GL_QUAD_STRIP',
		'GL_STENCIL_BUFFER_BIT',
		'GL_TRIANGLES',
		'GL_TRIANGLE_FAN',
		'GL_TRIANGLE_STRIP'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #'class initialization' }
OpenGLConstants class >> initCommonMask [
	GL_COLOR_BUFFER_BIT := 16r00004000.
	GL_DEPTH_BUFFER_BIT := 16r00000100.
	GL_ACCUM_BUFFER_BIT := 16r00000200.
	GL_STENCIL_BUFFER_BIT := 16r00000400.
]

{ #category : #'class initialization' }
OpenGLConstants class >> initCommonMode [
	GL_TRIANGLES := 16r0004.
	GL_POINTS := 16r0000.
	GL_LINES := 16r0001.
	GL_LINE_STRIP := 16r0003.
	GL_LINE_LOOP := 16r0002.
	GL_TRIANGLE_STRIP := 16r0005.
	GL_TRIANGLE_FAN := 16r0006.
	GL_QUADS := 16r0007.
	GL_QUAD_STRIP := 16r0008.
	GL_POLYGON := 16r0009.
]

{ #category : #'class initialization' }
OpenGLConstants class >> initialize [
	self initCommonMode.
	self initCommonMask.
]
