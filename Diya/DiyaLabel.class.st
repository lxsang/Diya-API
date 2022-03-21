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
DiyaLabel >> applyStyle [
	txt color: style color.
	txt fontName: style fontFamily style: style fontStyle  size: style fontSize.
	txt wordWrap: true.
	icon ifNotNil: [
		icon color: style color.
		icon fontSize: style fontSize
	].
	"update extent"
	
]

{ #category : #accessing }
DiyaLabel >> icon [
	^ icon
]

{ #category : #accessing }
DiyaLabel >> icon: anObject [
	icon := nil.
	anObject isNumber ifTrue: [ icon := root addNode: (DiyaFontIcon data: anObject) ].
	anObject isString ifTrue: [ icon := root addNode: (DiyaImageView from: anObject)].
	icon ifNil: [ ^ DiyaCoreAPIError signal: 'Invalid icon identification'].
	dirty := true.
]

{ #category : #initialization }
DiyaLabel >> initialize [
	super initialize.
	txt := root addNode:(DiyaText new).
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
