Class {
	#name : #DiyaLoadingBar,
	#superclass : #DiyaWidget,
	#instVars : [
		'label',
		'bar',
		'progress',
		'percent'
	],
	#category : #'Diya-Widgets'
}

{ #category : #accessing }
DiyaLoadingBar >> bar [
	^ bar
]

{ #category : #initialization }
DiyaLoadingBar >> initialize [
	super initialize.
	bar := self addNode: (DiyaRectangle new).
	progress := self addNode: (DiyaRectangle new).
	bar styleName: #loadingBar.
	progress styleName: #loadingProgress.
	"label := self addNode: (DiyaLabel new).
	label wordWrap: false."
	percent := 0.
]

{ #category : #accessing }
DiyaLoadingBar >> label [
	^ label
]

{ #category : #accessing }
DiyaLoadingBar >> percent [
	^ percent
]

{ #category : #accessing }
DiyaLoadingBar >> percent: anObject [
	percent := anObject.
	self setDirty.
]

{ #category : #processing }
DiyaLoadingBar >> process [
	bar extent: self extent.
	progress extent: ((self percent) * (self extent x) / 100) @ (self extent y).
]

{ #category : #accessing }
DiyaLoadingBar >> progress [
	^ progress
]
