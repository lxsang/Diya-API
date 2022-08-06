Class {
	#name : #DiyaFontIcon,
	#superclass : #DiyaText,
	#pools : [
		'FT2Types'
	],
	#category : #'Diya-Graphics'
}

{ #category : #initialization }
DiyaFontIcon >> data: code [
	super data:(code isArray ifTrue: [ code ] ifFalse:[{code}]).
	bbox := Rectangle origin: 0@0 corner: ((data size) * (self fontSize) ) @ self fontSize.
]

{ #category : #initialization }
DiyaFontIcon >> drawText [
	|index offset tex glyph |
	index := 1.
	tex := self texture.
	offset := (self alignLine: self fontSize)@(self valignText: self fontSize).
	data do: [ :c|
		glyph := tex getGlyph: c asInteger.
		(self getCharsVerticesFrom: glyph offset: offset  cellh: tex cellh) do: [
			:e| vbuffer at: index put:e.
			index := index + 1
		].
		"offset setX: offset x + tex spacing setY: offset y" 
	].

	
]

{ #category : #initialization }
DiyaFontIcon >> fontName: name style: face size: size [
	super fontName: name style:face  size: size. 
	data ifNil: [ ^ self ].
	bbox := Rectangle origin: 0@0 corner: ((data size) * size ) @ size.
]

{ #category : #initialization }
DiyaFontIcon >> getLinebreakIndices: delta [
	self shouldNotBeCalled 
]

{ #category : #accessing }
DiyaFontIcon >> iconSize [
	^ self fontSize
]

{ #category : #accessing }
DiyaFontIcon >> iconSize: v [
	"self extent: "
	^ self fontSize: v
]

{ #category : #initialization }
DiyaFontIcon >> initialize [ 
	super initialize.
	data := {  }.
	self fontName: 'bootstrap-icons' style: 'Regular' size: 16.
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size:24.
	vbuffer autoRelease.
]

{ #category : #initialization }
DiyaFontIcon >> lastSeparatorFrom: i [
	self shouldNotBeCalled 
]
