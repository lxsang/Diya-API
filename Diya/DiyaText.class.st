Class {
	#name : #DiyaText,
	#superclass : #Diya2DPrimShape,
	#instVars : [
		'data',
		'wrap',
		'texheight',
		'font',
		'lines'
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

{ #category : #'menu messages' }
DiyaText >> align [
	^ self style get: #textAlign
]

{ #category : #'menu messages' }
DiyaText >> align: v [
	self style set: #textAlign value: v.
	self formatText
]

{ #category : #accessing }
DiyaText >> alignLine:w [
	self align = #center ifTrue:[^ 0 max:((self extent x - w) / 2.0 ) asFloat].
	self align = #right ifTrue:[^ 0 max: self extent x - w].
	^0
]

{ #category : #initialization }
DiyaText >> allocMemory [
	vbuffer ifNotNil: [
		vbuffer size >= data size
			ifTrue: [^self]
			ifFalse:[vbuffer free]
	].
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size: data size * 16.
	vbuffer autoRelease.
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

{ #category : #initialization }
DiyaText >> drawBorder [
	self shouldNotBeCalled 
]

{ #category : #initialization }
DiyaText >> drawLines [
	^ self shouldNotBeCalled
]

{ #category : #accessing }
DiyaText >> drawText [
	self splitLines.
	self formatText .
]

{ #category : #accessing }
DiyaText >> extent: v [
	bbox := Rectangle origin: 0@0 corner: (v x) @ (v y negated ). 
	dirty := true
]

{ #category : #accessing }
DiyaText >> fontName [
	^ self style get: #fontFamily
]

{ #category : #initialization }
DiyaText >> fontName: name style: face size: size [
	name  ifNotNil: [style set:#fontFamily value: name].
	face ifNotNil: [style set: #fontStyle value:face].
	style set: #fontSize value: size.
	dirty := true.
	self initTexture
]

{ #category : #accessing }
DiyaText >> fontSize [
	^ self style get:#fontSize
]

{ #category : #initialization }
DiyaText >> fontSize: size [
	self fontName: nil style:nil  size: size
]

{ #category : #accessing }
DiyaText >> fontStyle [
	^ self style get: #fontStyle
]

{ #category : #accessing }
DiyaText >> formatText [
	|offset index line|
	lines ifNil: [^self].
	offset := 0@(self valignText: (texture linespace) * (lines size)).
	index := 1.
	lines do:[:assoc|
		line := assoc value.
		offset setX: (self alignLine: assoc key) setY: offset y.
		line do:[:g|
			(self getCharsVerticesFrom: g offset: offset cellh: texture cellh) do:[:v|
					vbuffer at: index put:v.
					index := index + 1.	
				]
		].
		offset setX: 0.0 setY: (offset y )- (texture linespace)
	].
	
]

{ #category : #accessing }
DiyaText >> getCharsVerticesFrom:glyph offset: offset cellh: cellh [
	|x y w h  gsize texcoord|
	gsize := glyph extent.
	x := offset x + (glyph bearing x).
	y := offset y - cellh.
	w := (gsize x).
	h := (gsize y).
	texcoord := glyph texcoord.
	offset setX: (offset x + (glyph advance x)) setY: offset y.
	^{x. y + h. texcoord origin x.  texcoord origin y.            
      x. y.  texcoord origin x.  texcoord corner y.
      x + w. y.  texcoord corner x.  texcoord corner y.
		"x. y + h.  texcoord origin x.  texcoord origin y.
      x + w. y.  texcoord corner x.  texcoord corner y."
      x + w. y + h.  texcoord corner x.  texcoord origin y.  }.
]

{ #category : #accessing }
DiyaText >> getLineAt: index to: line with: tex2D [
	|  glyph ret w |
	w := 0.
	index to: data size do:[ :i|
		glyph := tex2D getGlyph: (data at:i) asInteger.
		(w + (glyph advance x))  >= (self extent x) ifTrue:[
			wrap ifFalse: [ ^ i @ w].
			ret := self lastSeparatorFrom: i.
			ret to: i - 1 do:[:j|
				w := w - (line removeLast advance x)].
			^ (ret+1)@w
		] ifFalse:[
			w := w + (glyph advance x).
			line add: glyph.
		].
	].
	^ (data size + 1) @ w
]

{ #category : #initialization }
DiyaText >> initTexture [
	font:= DiyaFontManager uniqueInstance style: self fontStyle  from: self fontName.
	texture := font textureOf: self fontSize.
]

{ #category : #initialization }
DiyaText >> initialize [
	super initialize.
	data := nil.
	wrap := false.
	texheight := 0.
	style set: #border value: 0.
	type := GL_QUADS.
]

{ #category : #'as yet unclassified' }
DiyaText >> lastSeparatorFrom: index [
	index to: 1 by: -1 do: [:i|
		(data at: i) isSeparator ifTrue:[^i].
	].
	^ 0
]

{ #category : #accessing }
DiyaText >> lines [
	^ lines
]

{ #category : #accessing }
DiyaText >> splitLines [
	|line ret tex2D|
	ret := 1@0.
	tex2D := self texture.
	lines := OrderedCollection new.
	[
		line := OrderedCollection new.
		ret := self getLineAt: ret x to: line with: tex2D.
		lines add: ((ret y) -> line).
		(ret x < data size) and: wrap
	] whileTrue.
]

{ #category : #accessing }
DiyaText >> texture [
	texture ifNil: [ self initTexture ].
	texheight = texture height ifFalse: [
		texheight := texture height.
		self update.
		dirty := false.	
	].
	^texture
]

{ #category : #initialization }
DiyaText >> update [
	bbox ifNil: [ ^true ].
	data ifNil:[^true].
	data ifEmpty:[^true].
	vbuffer ifNotNil: [vbuffer free].
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size: data size * 16.
	vbuffer autoRelease.
	self drawText.
	^true
]

{ #category : #'menu messages' }
DiyaText >> valign [
	^ self style get: #textVAlign
]

{ #category : #'menu messages' }
DiyaText >> valign: v [
	self style set: #textVAlign value: v.
	self formatText.
]

{ #category : #accessing }
DiyaText >> valignText:h [
	self valign = #middle ifTrue:[^ (0 max:((self extent y - h) / 2 ) asFloat) negated].
	self valign = #bottom ifTrue:[^ (0 max:(self extent y - h )) negated].
	^0
]

{ #category : #initialization }
DiyaText >> wordWrap: aBool [
	wrap := aBool.
	dirty := true
]
