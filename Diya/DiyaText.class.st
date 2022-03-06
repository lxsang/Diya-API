Class {
	#name : #DiyaText,
	#superclass : #Diya2DNode,
	#instVars : [
		'fontStyle',
		'fontSize',
		'fontName',
		'data',
		'style'
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
	data ifNil: [ ^self ].
	style := DiyaFontManager uniqueInstance style: self fontStyle  from: self fontName.
	OpenGL
		enable: GL_CULL_FACE;
		enable: GL_BLEND;
		blendFnWithSfactor: GL_SRC_ALPHA dfactor: GL_ONE_MINUS_SRC_ALPHA;
		pixelstorei: GL_UNPACK_ALIGNMENT param: 1.
	self shader
		use;
		setUniform: #u_time value: DiyaClock uniqueInstance elapsedTime asFloat;
		setUniform: #u_projection value: {GL_FALSE. context projection buffer};
		setUniform: #u_transform value: {GL_TRUE. self tf asGLBuffer};
		setUniform: #u_texture value: 0;
		setUniform: #u_resolution value: { context resolution x. context resolution y }.
	"configure vao vbo for texture QUAD"
	context texture0 active. 
	context texture0 setImage2D: self texture.
	OpenGLTexture
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_S param: GL_CLAMP_TO_EDGE;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_T param: GL_CLAMP_TO_EDGE;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MIN_FILTER param: GL_LINEAR;
		parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MAG_FILTER param: GL_LINEAR.
	context vao enableAttribute: 0.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:4 type: GL_FLOAT normalized: GL_FALSE stride: 16 pointer: nil .
	self drawText.
	context vao disableAttribute: 0.
	"reset value"
	OpenGL
		pixelstorei: GL_UNPACK_ALIGNMENT param: 4;
		disable: GL_CULL_FACE;
		disable: GL_BLEND.
	
]

{ #category : #accessing }
DiyaText >> drawCharacter: c at: offset [
	|x y w h glyph tex2D|
	tex2D := self texture.
	c = (Character space asciiValue) ifTrue:[
		^offset setX: (offset x + ((tex2D spacing )* (self scale x)) ) setY: offset y.
	].
	glyph := tex2D getGlyph: c.
	((offset x > self extent x) and: (glyph extent x > 0)) ifTrue:[
		offset setX: 0.0 setY: (offset y )- (tex2D linespace * (self scale y)).].
	x := offset x + ((glyph bearing x )*(self scale x)).
	y := offset y - ((tex2D cellh) * (self scale y)).
	w := (glyph extent x)*(self scale x).
	h := (glyph extent y)*(self scale y).
	{x. y + h. glyph texcoord origin x. glyph texcoord origin y.            
      x. y. glyph texcoord origin x. glyph texcoord corner y.
      x + w. y. glyph texcoord corner x. glyph texcoord corner y.
		x. y + h. glyph texcoord origin x. glyph texcoord origin y.
      x + w. y. glyph texcoord corner x. glyph texcoord corner y.
      x + w. y + h. glyph texcoord corner x. glyph texcoord origin y.  }  withIndexDo: [ :e :i| context buffer at:i put: e ].
	context vbo subData: GL_ARRAY_BUFFER offset: 0 data: context buffer.
	OpenGL drawArrays: GL_TRIANGLES first:0  count:6.
	offset setX: (offset x + ((glyph advance x )* (self scale x)) ) setY: offset y.
]

{ #category : #accessing }
DiyaText >> drawSubStringFrom: lower at: offset [
	|upper vertices count|
	upper := lower + ((data size - lower) min:(context buffer size / 6) asInteger) - 1.
	count := 0.
	lower to: upper do: [ :i|
		vertices := self getCharsVertices:(data at:i) asciiValue offset: offset.
		vertices withIndexDo: [ 
			:e :p| context buffer at: count*4 + p put:e ].
		count := count + (vertices size /4) asInteger.
	].
	context vbo subData: GL_ARRAY_BUFFER offset: 0 data: context buffer.
	OpenGL drawArrays: GL_TRIANGLES first:0  count:count.
	^ upper + 1
]

{ #category : #accessing }
DiyaText >> drawText [
	|lower offset|
	offset := 0@0.
	lower := 1.
	[
		lower := self drawSubStringFrom: lower at:offset.
		lower < data size.
	] whileTrue.
]

{ #category : #accessing }
DiyaText >> fillVerticesBuffer: buffer at: offset tex: tex [
	|x y w h|
	"x := offset x + ((tex bearing x )*(self scale x)).
	y := offset y - (((tex height) - (tex bearing y))*(self scale y)).
	w := (tex  width)*(self scale x).
	h := (tex  height)*(self scale y)."
	x := 0.
	y := 0.
	w := tex width.
	h := tex height.
	{x. y + h. 0.0. 0.0.            
      x. y. 0.0. 1.0.
      x + w. y. 1.0. 1.0.
		x. y + h. 0.0. 0.0.
      x + w. y. 1.0. 1.0.
      x + w. y + h. 1.0. 0.0.  } withIndexDo: [ :e :i| buffer at:i put: e ]


"{x. y + h. 0.0. 0.0.            
      x. y. 0.0. 1.0.
      x + w. y. 1.0. 1.0.
		x. y + h. 0.0. 0.0.
      x + w. y. 1.0. 1.0.
      x + w. y + h. 1.0. 0.0.  }"
]

{ #category : #accessing }
DiyaText >> fontName [
	^ fontName
]

{ #category : #accessing }
DiyaText >> fontName: anObject [
	fontName := anObject.
]

{ #category : #accessing }
DiyaText >> fontSize [
	^ fontSize
]

{ #category : #accessing }
DiyaText >> fontSize: anObject [
	fontSize := anObject.
]

{ #category : #accessing }
DiyaText >> fontStyle [
	^ fontStyle
]

{ #category : #accessing }
DiyaText >> fontStyle: anObject [
	fontStyle := anObject.
]

{ #category : #accessing }
DiyaText >> getCharsVertices:c offset: offset [
	|x y w h glyph tex2D|
	tex2D := self texture.
	c = (Character space asciiValue) ifTrue:[
		offset setX: (offset x + ((tex2D spacing )* (self scale x)) ) setY: offset y.
		^ {  }.
	].
	glyph := tex2D getGlyph: c.
	((offset x > self extent x) and: (glyph extent x > 0)) ifTrue:[
		offset setX: 0.0 setY: (offset y )- (tex2D linespace * (self scale y)).].
	x := offset x + ((glyph bearing x )*(self scale x)).
	y := offset y - ((tex2D cellh) * (self scale y)).
	w := (glyph extent x)*(self scale x).
	h := (glyph extent y)*(self scale y).
	offset setX: (offset x + ((glyph advance x )* (self scale x)) ) setY: offset y.
	^{x. y + h. glyph texcoord origin x. glyph texcoord origin y.            
      x. y. glyph texcoord origin x. glyph texcoord corner y.
      x + w. y. glyph texcoord corner x. glyph texcoord corner y.
		x. y + h. glyph texcoord origin x. glyph texcoord origin y.
      x + w. y. glyph texcoord corner x. glyph texcoord corner y.
      x + w. y + h. glyph texcoord corner x. glyph texcoord origin y.  }.
]

{ #category : #initialization }
DiyaText >> initialize [
	super initialize.
	self fontName: 'Ubuntu'.
	self fontStyle: 'Regular'.
	self fontSize: 14.
	data := nil.
]

{ #category : #accessing }
DiyaText >> texture [
	^style textureOf: self fontSize 
]
