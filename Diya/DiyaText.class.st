Class {
	#name : #DiyaText,
	#superclass : #Diya2DPrimShape,
	#instVars : [
		'fontStyle',
		'fontSize',
		'fontName',
		'data',
		'style',
		'wrap',
		'texheight'
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
	|vertices index tex2D offset lbdelta|
	index := 1.
	offset := 0@0.
	tex2D := self texture.
	lbdelta := self getLinebreakIndices: (self extent x / tex2D meanww) asInteger.
	1 to: data size do: [ :i|
		vertices := self getCharsVerticesAt:i offset: offset on: tex2D.
		vertices do: [ 
			:e| vbuffer at: index put:e.
			index := index + 1.
		].
		(offset x > self extent x and: wrap not) ifTrue: [ ^self ].
		((lbdelta includes: i + 1) and: wrap) ifTrue: [
			offset setX: 0.0 setY: (offset y )- (tex2D linespace).
			(offset y negated > self extent y) ifTrue: [ ^self ].
		]. 
	].
]

{ #category : #accessing }
DiyaText >> extent: v [
	bbox := Rectangle origin: 0@0 corner: (v x) @ (v y negated ). 
	dirty := true
]

{ #category : #accessing }
DiyaText >> fontName [
	^ fontName
]

{ #category : #initialization }
DiyaText >> fontName: name style: face size: size [
	name  ifNotNil: [fontName := name].
	face ifNotNil: [fontStyle := face].
	
	fontName := fontName  ifNil: [DiyaFontManager uniqueInstance defaultFamily].
	fontStyle := fontStyle ifNil: [DiyaFontManager uniqueInstance defaultStyle].
	
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
DiyaText >> getCharsVerticesAt:i offset: offset on: tex2D [
	|x y w h glyph gsize c texcoord|
	c := (data at:i) asInteger.
	glyph := tex2D getGlyph: c.
	gsize := glyph extent.
	((offset x > self extent x) and: (gsize x > 0)) ifTrue:[
		wrap ifFalse: [ ^ { } ].
	].
	x := offset x + (glyph bearing x).
	y := offset y - (tex2D cellh).
	w := (gsize x).
	h := (gsize y).
	texcoord := glyph texcoord.
	offset setX: (offset x + (glyph advance x)) setY: offset y.
	^{x. y + h. texcoord origin x.  texcoord origin y.            
      x. y.  texcoord origin x.  texcoord corner y.
      x + w. y.  texcoord corner x.  texcoord corner y.
		x. y + h.  texcoord origin x.  texcoord origin y.
      x + w. y.  texcoord corner x.  texcoord corner y.
      x + w. y + h.  texcoord corner x.  texcoord origin y.  }.
]

{ #category : #accessing }
DiyaText >> getLinebreakIndices: delta [
	|indices idx|
	indices := Set new.
	idx := delta + 1.
	[
		idx < data size
	] whileTrue: [
		indices add: (self lastSeparatorFrom: idx) + 1.
		idx := idx + delta.
	]. 
	^indices
]

{ #category : #initialization }
DiyaText >> initialize [
	super initialize.
	"self fontName: 'Ubuntu' style:'Regular'  size: 16."
	data := nil.
	wrap := false.
	bbox := nil.
	texheight := 0.
	self fontSize: 16
]

{ #category : #'as yet unclassified' }
DiyaText >> lastSeparatorFrom: index [
	index to: 1 by: -1 do: [:i|
		(data at: i) isSeparator ifTrue:[^i].
	].
	^ 0
]

{ #category : #accessing }
DiyaText >> texture [
	|tex|
	tex := style textureOf: self fontSize.
	texheight = tex height ifFalse: [ 
		texheight := tex height.
		self update.
		dirty := false.	
	].
	^tex
]

{ #category : #initialization }
DiyaText >> update [
	bbox ifNil: [ ^false ].
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
