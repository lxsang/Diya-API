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
]

{ #category : #accessing }
DiyaText >> drawText [
	|vertices index tex2D offset|
	index := 1.
	offset := 0@0.
	tex2D := self texture.
	1 to: data size do: [ :i|
		vertices := self getCharsVerticesAt:i offset: offset on: tex2D.
		vertices do: [ 
			:e| vbuffer at: index put:e.
			index := index + 1.
		].
		(offset x > self extent x and: wrap not) ifTrue: [ ^self ].
		(offset y negated > self extent y) ifTrue: [ ^self ]. 
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
DiyaText >> getCharsVerticesAt:i offset: offset on: tex2D [
	|x y w h glyph gsize c texcoord|
	c := (data at:i) asciiValue.
	c = (Character space asciiValue) ifTrue:[
		offset setX: (offset x + (tex2D spacing ) ) setY: offset y.
		wrap ifTrue: [
			(offset x + ((self nextSpaceFrom: i + 1) * (tex2D fontSize))) > (self extent x) ifTrue: [
				offset setX: 0.0 setY: (offset y )- (tex2D linespace)]. 
		].
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
	texcoord := glyph texcoord.
	offset setX: (offset x + (glyph advance x)) setY: offset y.
	^{x. y + h. texcoord origin x.  texcoord origin y.            
      x. y.  texcoord origin x.  texcoord corner y.
      x + w. y.  texcoord corner x.  texcoord corner y.
		x. y + h.  texcoord origin x.  texcoord origin y.
      x + w. y.  texcoord corner x.  texcoord corner y.
      x + w. y + h.  texcoord corner x.  texcoord origin y.  }.
]

{ #category : #initialization }
DiyaText >> initialize [
	super initialize.
	self fontName: 'Ubuntu' style:'Regular'  size: 16.
	data := nil.
	wrap := false.
	bbox := nil.
	texheight := 0.
]

{ #category : #'as yet unclassified' }
DiyaText >> nextSpaceFrom: index [
	index to: (data size) do: [:i|
		(data at: i) = (Character space) ifTrue:[^i - index].
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
