Class {
	#name : #DiyaLabel,
	#superclass : #DiyaWidget,
	#instVars : [
		'txt',
		'icon'
	],
	#category : #'Diya-Widgets'
}

{ #category : #accessing }
DiyaLabel >> fontSize [
	^txt fontSize.

]

{ #category : #accessing }
DiyaLabel >> fontSize: value [
	txt fontSize: value.
	icon ifNotNil: [ icon fontSize: value ].
	"dirty := true."

]

{ #category : #accessing }
DiyaLabel >> icon [
	^ icon
]

{ #category : #accessing }
DiyaLabel >> icon: anObject [
	icon := nil.
	anObject isNumber ifTrue: [
		icon := self addNode: (DiyaFontIcon data: anObject).
		icon align: #left].
	anObject isString ifTrue: [ icon := self addNode: (DiyaImageView from: anObject)].
	icon ifNil: [ ^ DiyaCoreAPIError signal: 'Invalid icon identification'].
	dirty := true.
]

{ #category : #accessing }
DiyaLabel >> iconPosition: offset [
	|xpos|
	txt splitLines.
	txt lines ifEmpty: [ ^0@0 ].
	xpos := txt alignLine: txt lines first key.
	^xpos@0
]

{ #category : #accessing }
DiyaLabel >> iconSize [
	icon ifNil: [ ^0 ].
	^icon fontSize.

]

{ #category : #accessing }
DiyaLabel >> iconSize: v [
	icon ifNil: [ ^self ].
	icon fontSize: v.

]

{ #category : #initialization }
DiyaLabel >> initialize [
	super initialize.
	txt := self addNode:(DiyaText data: '').
	icon := nil.
	self extent: 0@0.
]

{ #category : #accessing }
DiyaLabel >> txt [
	^ txt
]

{ #category : #accessing }
DiyaLabel >> txt: anObject [
	txt data: anObject.
	dirty := true
]

{ #category : #accessing }
DiyaLabel >> updateLayout [
	|offset isize|
	offset := 0.
	icon ifNotNil: [
		isize := icon fontSize.
		offset :=  isize + (isize >> 1).
		icon extent:offset @ (extent y).
	].
	txt extent: (extent x - offset) @ (extent y).
	txt position: offset @ 0.
	icon ifNil: [ ^self ].
	icon position: (self iconPosition: offset).
	
]
