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
	"icon ifNotNil: [ icon fontSize: value ]."
	"dirty := true."

]

{ #category : #accessing }
DiyaLabel >> getHAlign: offset [
	^ 0 max: (txt alignLine: ( txt maxLineWidth)).
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
	anObject isString ifTrue: [
		icon := self addNode: (DiyaImageIcon from: anObject).
	].
	icon ifNil: [ ^ DiyaCoreAPIError signal: 'Invalid icon identification'].
	dirty := true.
]

{ #category : #accessing }
DiyaLabel >> iconSize [
	icon ifNil: [ ^0 ].
	^ icon iconSize

]

{ #category : #accessing }
DiyaLabel >> iconSize: v [
	icon ifNil: [ ^self ].
	icon iconSize: v

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
	|offset isize align|
	offset := 0.
	icon ifNotNil: [
		isize := self iconSize.
		offset :=  isize + (isize >> 2).
		"icon extent:offset @ (extent y)."
	].
	txt extent: (extent x - offset) @ (extent y).
	"lookahead update"
	txt update.
	align := self getHAlign: offset.
	txt position: offset  @ ( (self extent y - txt extent y ) >> 1).
	
	icon ifNil: [ ^self ].
	"{ offset. txt extent. txt maxLineWidth. align } inspect."
	icon position: (align @( (self extent y - self iconSize ) >> 1)).
	
]
