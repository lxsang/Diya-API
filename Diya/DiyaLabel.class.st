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
DiyaLabel >> icon [
	^ icon
]

{ #category : #accessing }
DiyaLabel >> icon: anObject [
	icon := nil.
	anObject isNumber ifTrue: [ icon := self addNode: (DiyaFontIcon data: anObject) ].
	anObject isString ifTrue: [ icon := self addNode: (DiyaImageView from: anObject)].
	icon ifNil: [ ^ DiyaCoreAPIError signal: 'Invalid icon identification'].
	dirty := true.
]

{ #category : #initialization }
DiyaLabel >> initialize [
	super initialize.
	txt := self addNode:(DiyaText data: '').
	icon := nil.
	self extent: 0@0.
	"style := DiyaDefaultStyle uniqueInstance."
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
	isize := style get: #fontSize.
	icon ifNotNil: [
		offset :=  isize + (isize >> 1).
		icon position: 0 @ (extent y - isize)
	].
	txt extent: (extent x - offset) @ (extent y).
	txt position: offset @ (extent y)
	
]
