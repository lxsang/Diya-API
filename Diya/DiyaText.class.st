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
	self shader
		setUniform: #u_use_texture value:1.
	"configure vao vbo for texture QUAD"
	style := DiyaFontManager uniqueInstance style: self fontStyle  from: self fontName.
	self texture setup.
	context texture0 setImage2D: self texture.
	context texture0 active. 
	context vao enableAttribute: 0.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:4 type: GL_FLOAT normalized: GL_FALSE stride: 16 pointer: nil .
	self drawText.
	context vao disableAttribute: 0.
	"reset value"
	self texture drop.
	
]

{ #category : #accessing }
DiyaText >> drawSubStringFrom: lower at: offset [
	|upper vertices count index tex2D|
	upper := lower + ((data size - lower) min:(context buffer size / 24) asInteger).
	count := 0.
	index := 1.
	tex2D := self texture.
	lower to: upper do: [ :i|
		vertices := self getCharsVertices:(data at:i) asciiValue offset: offset on: tex2D.
		vertices do: [ 
			:e| context buffer at: index put:e.
			index := index + 1.
		].
		vertices ifNotEmpty: [ count := count + 6 ].
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
DiyaText >> getCharsVertices:c offset: offset on: tex2D [
	|x y w h glyph gsize|
	c = (Character space asciiValue) ifTrue:[
		offset setX: (offset x + (tex2D spacing ) ) setY: offset y.
		^ {}.
	].
	glyph := tex2D getGlyph: c.
	gsize := glyph extent.
	((offset x > self extent x) and: (gsize x > 0)) ifTrue:[
		offset setX: 0.0 setY: (offset y )- (tex2D linespace).].
	x := offset x + (glyph bearing x).
	y := offset y - (tex2D cellh).
	w := (gsize x).
	h := (gsize y).
	offset setX: (offset x + (glyph advance x)) setY: offset y.
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
	self fontSize: 16.
	data := nil.
]

{ #category : #accessing }
DiyaText >> texture [
	^style textureOf: self fontSize 
]
