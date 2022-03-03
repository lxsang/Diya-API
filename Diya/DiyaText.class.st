Class {
	#name : #DiyaText,
	#superclass : #Diya2DNode,
	#instVars : [
		'fontStyle',
		'fontSize',
		'fontName',
		'data'
	],
	#pools : [
		'FT2Types'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'as yet unclassified' }
DiyaText class >> data: string [
	^ (self new) data: string; yourself
]

{ #category : #'as yet unclassified' }
DiyaText class >> data: string shader: s [
	^ (self with:s) data: string; yourself
]

{ #category : #accessing }
DiyaText >> data [
	^ data
]

{ #category : #accessing }
DiyaText >> data: anObject [
	data := anObject
]

{ #category : #accessing }
DiyaText >> draw [
	|face offset|
	data ifNil: [ ^self ].
	offset := 100.0@100.0.
	OpenGL enable: GL_CULL_FACE.
	OpenGL enable: GL_BLEND.
	OpenGL blendFnWithSfactor: GL_SRC_ALPHA dfactor: GL_ONE_MINUS_SRC_ALPHA.
	self shader use.
	self shader setUniform: #u_time value: DiyaClock uniqueInstance elapsedTime asFloat.
	self shader setUniform: #u_projection value: context projection buffer.
	self shader setUniform: #u_texture value: 0.
	self shader setUniform: #u_resolution value: { context resolution x. context resolution y }.
	context mouse ifNotNil: [
		"in shader, window origin is bottom left conor of the window
		the mouse position should be transformed to this coodinate"
		shader setUniform: #u_mouse value: { context mouse x. context resolution y - context mouse y }.
	].
	face := DiyaFontManager uniqueInstance face: self fontStyle  from: self fontName.
	"set fontsize"
	face setPixelWidth:0 height: self fontSize.
	OpenGL pixelstorei: GL_UNPACK_ALIGNMENT param: 1.
	"configure vao vbo for texture QUAD"
	context vao enableAttribute: 0.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:4  type: GL_FLOAT normalized: GL_FALSE stride: 16 pointer: nil .
	data do:[:c | self drawCharacter: c at: offset with: face.].
	context vao disableAttribute: 0.
	"reset value"
	OpenGL pixelstorei: GL_UNPACK_ALIGNMENT param: 4.
	OpenGL disable: GL_CULL_FACE.
	OpenGL disable: GL_BLEND.
	
]

{ #category : #accessing }
DiyaText >> drawCharacter: c at: offset with: face [
	|tex2D|
	face loadCharacter: c asciiValue  flags: (1 << 2) "FT_LOAD_RENDER".
	tex2D := OpenGLTexImage2D new target: GL_TEXTURE_2D;
		level: 0;
		internalFormat: GL_RED;
		width: face glyph  width;
		height: face glyph  height;
		border: 0;
		format: GL_RED;
		type: GL_UNSIGNED_BYTE;
		data: (FTFaceRec fromHandle: face getHandle) glyph bitmap buffer;
		yourself.
	context texture0 setImage2D: tex2D.
	OpenGLTexture parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_S param: GL_CLAMP_TO_EDGE.
	OpenGLTexture parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_T param: GL_CLAMP_TO_EDGE.
	OpenGLTexture parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MIN_FILTER param: GL_LINEAR.
	OpenGLTexture parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MAG_FILTER param: GL_LINEAR.
	"fill the buffer"
	self fillVerticesBuffer: context buffer at: offset with: face.
	context vbo subData: GL_ARRAY_BUFFER offset:0  data: context buffer.
	OpenGL drawArrays: GL_TRIANGLES first:0  count:6.
	offset setX: (offset x + ((face glyph advanceX )* (self scale x)) ) setY: offset y.
]

{ #category : #accessing }
DiyaText >> fillVerticesBuffer: buffer at: offset with: face [
	|x y w h i|
	x := offset x + ((face glyph hBearingX )*(self scale x)).
	y := offset y - (((face glyph height) - (face glyph hBearingY))*(self scale y)).
	w := (face glyph width)*(self scale x).
	h := (face glyph height)*(self scale y).
	i := 1.
	{x. y + h. 0.0. 0.0.            
      x. y. 0.0. 1.0.
      x + w. y. 1.0. 1.0.
		x. y + h. 0.0. 0.0.
      x + w. y. 1.0. 1.0.
      x + w. y + h. 1.0. 0.0.  }
	do: [ :e| buffer at:i put:e. i := i+1 ]
]

{ #category : #accessing }
DiyaText >> fontName [
	^ fontName
]

{ #category : #accessing }
DiyaText >> fontName: anObject [
	fontName := anObject
]

{ #category : #accessing }
DiyaText >> fontSize [
	^ fontSize
]

{ #category : #accessing }
DiyaText >> fontSize: anObject [
	fontSize := anObject
]

{ #category : #accessing }
DiyaText >> fontStyle [
	^ fontStyle
]

{ #category : #accessing }
DiyaText >> fontStyle: anObject [
	fontStyle := anObject
]

{ #category : #initialization }
DiyaText >> initialize [
	super initialize.
	fontStyle := 'Regular'.
	fontName := 'Ubuntu'.
	fontSize := 40.
	data := nil.
]
