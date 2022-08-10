Class {
	#name : #DiyaButton,
	#superclass : #DiyaWidget,
	#instVars : [
		'label',
		'rec'
	],
	#category : #'Diya-Widgets'
}

{ #category : #accessing }
DiyaButton class >> text: string [
	^ self new text: string; yourself
]

{ #category : #accessing }
DiyaButton >> icon: ico [
	label icon: ico.
	label setDirty.
]

{ #category : #accessing }
DiyaButton >> iconSize: size [
	label iconSize: size.
]

{ #category : #initialization }
DiyaButton >> initialize [
	super initialize.
	rec := self addNode: (DiyaRectangle new).
	label := self addNode: (DiyaLabel new).
	label txt
		wordWrap: false.
]

{ #category : #accessing }
DiyaButton >> label [
	^ label
]

{ #category : #accessing }
DiyaButton >> process [
	rec extent: self extent.
	label position: 0@0.
	label extent: self extent.
	^true
]

{ #category : #accessing }
DiyaButton >> text: string [
	label txt: string.
]
