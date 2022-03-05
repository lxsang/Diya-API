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
	| offset|
	data ifNil: [ ^self ].
	offset := 0.0@0.0.
	OpenGL enable: GL_CULL_FACE.
	OpenGL enable: GL_BLEND.
	OpenGL enable: GL_TEXTURE_2D.
	OpenGL blendFnWithSfactor: GL_SRC_ALPHA dfactor: GL_ONE_MINUS_SRC_ALPHA.
	self shader use.
	shader setUniform: #u_time value: DiyaClock uniqueInstance elapsedTime asFloat.
	shader setUniform: #u_projection value: {GL_FALSE. context projection buffer}.
	shader setUniform: #u_transform value: {GL_TRUE. self tf asGLBuffer}.
	self shader setUniform: #u_texture value: 0.
	self shader setUniform: #u_resolution value: { context resolution x. context resolution y }.
	style := DiyaFontManager uniqueInstance style: self fontStyle  from: self fontName.
	OpenGL pixelstorei: GL_UNPACK_ALIGNMENT param: 1.
	"configure vao vbo for texture QUAD"
	context texture0 active.
	context vao enableAttribute: 0.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:4 type: GL_FLOAT normalized: GL_FALSE stride: 16 pointer: nil .
	data do:[:c | self drawCharacter: c at: offset].
	context vao disableAttribute: 0.
	"reset value"
	OpenGL pixelstorei: GL_UNPACK_ALIGNMENT param: 4.
	OpenGL disable: GL_CULL_FACE.
	OpenGL disable: GL_BLEND.
	
]

{ #category : #accessing }
DiyaText >> drawCharacter: c at: offset [
	|tex2D|
	tex2D := style loadChar: c asciiValue  size: self fontSize.
	context texture0 setImage2D: tex2D.
	OpenGLTexture parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_S param: GL_CLAMP_TO_EDGE.
	OpenGLTexture parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_WRAP_T param: GL_CLAMP_TO_EDGE.
	OpenGLTexture parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MIN_FILTER param: GL_LINEAR.
	OpenGLTexture parameteri: GL_TEXTURE_2D pname: GL_TEXTURE_MAG_FILTER param: GL_LINEAR.
	"fill the buffer"
	((offset x > extent x) and: (tex2D width > 0)) ifTrue:[
		offset setX: 0.0 setY: (offset y )- (tex2D linespace * (self scale y)).].
	self fillVerticesBuffer: context buffer at: offset tex: tex2D.
	context vbo subData: GL_ARRAY_BUFFER offset: 0 data: context buffer.
	OpenGL drawArrays: GL_TRIANGLES first:0  count:6.
	offset setX: (offset x + ((tex2D  advance x )* (self scale x)) ) setY: offset y.
]

{ #category : #accessing }
DiyaText >> fillVerticesBuffer: buffer at: offset tex: tex [
	|x y w h|
	x := offset x + ((tex bearing x )*(self scale x)).
	y := offset y - (((tex height) - (tex bearing y))*(self scale y)).
	w := (tex  width)*(self scale x).
	h := (tex  height)*(self scale y).
	{x. y + h. 0.0. 0.0.            
      x. y. 0.0. 1.0.
      x + w. y. 1.0. 1.0.
		x. y + h. 0.0. 0.0.
      x + w. y. 1.0. 1.0.
      x + w. y + h. 1.0. 0.0.  } withIndexDo: [ :e :i| buffer at:i put: e ]
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

{ #category : #initialization }
DiyaText >> initialize [
	super initialize.
	self fontName: 'Ubuntu'.
	self fontStyle: 'Regular'.
	self fontSize: 14.
	data := nil.
]
