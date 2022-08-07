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

{ #category : #accessing }
DiyaFontIcon >> fontName [
	^ self ? #textIconFamily
]

{ #category : #initialization }
DiyaFontIcon >> getLinebreakIndices: delta [
	self shouldNotBeCalled 
]

{ #category : #accessing }
DiyaFontIcon >> iconSize [
	^ self fontSize
]

{ #category : #initialization }
DiyaFontIcon >> initialize [ 
	super initialize.
	data := {  }.
	vbuffer :=  FFIExternalArray externalNewType: GLfloat size:24.
	vbuffer autoRelease.
]

{ #category : #initialization }
DiyaFontIcon >> lastSeparatorFrom: i [
	self shouldNotBeCalled 
]

{ #category : #initialization }
DiyaFontIcon >> update [
	data ifNil: [ ^self ].
	bbox := Rectangle origin: 0@0 corner: ((data size) * (self fontSize) ) @ self fontSize.
	^ super update.
]
