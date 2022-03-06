Class {
	#name : #DiyaText,
	#superclass : #Diya2DNode,
	#instVars : [
		'fontStyle',
		'fontSize',
		'fontName',
		'data',
		'style',
		'wrap'
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
	data := anObject.
	dirty := true
]

{ #category : #accessing }
DiyaText >> draw [
	data ifNil: [ ^self ].
	self shader
		setUniform: #u_use_texture value:1.
	"configure vao vbo for texture QUAD"
	self texture setup.
	context texture0 setImage2D: self texture.
	context texture0 active. 
	context vao enableAttribute: 0.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:4 type: GL_FLOAT normalized: GL_FALSE stride: 16 pointer: nil .
	context vbo data: GL_ARRAY_BUFFER data: vbuffer size: nvertices*16 usage: GL_STATIC_DRAW.
	OpenGL drawArrays: GL_TRIANGLES first:0  count:nvertices.
	context vao disableAttribute: 0.
	"reset value"
	self texture drop.
	
]

{ #category : #accessing }
DiyaText >> drawText [
	|vertices index tex2D offset|
	nvertices  := 0.
	index := 1.
	offset := 0@0.
	tex2D := self texture.
	1 to: data size do: [ :i|
		vertices := self getCharsVertices:(data at:i) asciiValue offset: offset on: tex2D.
		vertices do: [ 
			:e| vbuffer at: index put:e.
			index := index + 1.
		].
		vertices ifNotEmpty: [ nvertices := nvertices + 6 ].
		(offset x > extent x and: wrap not) ifTrue: [ ^self ].
		(offset y negated > extent y) ifTrue: [ ^self ]. 
	].
]

{ #category : #accessing }
DiyaText >> fontName [
	^ fontName
]

{ #category : #initialization }
DiyaText >> fontName: name style: face size: size [
	name ifNotNil: [ fontName := name ].
	face ifNotNil: [ fontStyle := face ].
	fontSize := size.
	style := DiyaFontManager uniqueInstance style: self fontStyle  from: self fontName.
	dirty := true.
]

{ #category : #accessing }
DiyaText >> fontSize [
	^ fontSize
]

{ #category : #initialization }
DiyaText >> fontSize: size [
	self fontName: nil style:nil  size: size
]

{ #category : #accessing }
DiyaText >> fontStyle [
	^ fontStyle
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
		wrap ifFalse: [ ^ { } ].
		offset setX: 0.0 setY: (offset y )- (tex2D linespace).
		offset y negated > self extent y ifTrue:[^{}].
	].
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
	self fontName: 'Ubuntu' style:'Regular'  size: 16.
	data := nil.
	wrap := false.
]

{ #category : #accessing }
DiyaText >> texture [
	^style textureOf: self fontSize 
]

{ #category : #initialization }
DiyaText >> update [
	extent ifNil: [ ^false ].
	vbuffer ifNotNil: [vbuffer free].
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size: data size * 24.
	vbuffer autoRelease.
	self drawText.
	^true
]

{ #category : #initialization }
DiyaText >> wordWrap: aBool [
	wrap := aBool.
	dirty := true
]
