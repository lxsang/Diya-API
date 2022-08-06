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
DiyaButton >> icon: id [
	label icon: id.
	label updateLayout.
]

{ #category : #accessing }
DiyaButton >> iconSize: size [
	label iconSize: size.
]

{ #category : #initialization }
DiyaButton >> initialize [
	super initialize.
	style 
		set:#textAlign value: #center;
		set:#textVAlign value: #middle;
		set:#border value: 1.
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
DiyaButton >> text: string [
	label txt: string.
]

{ #category : #accessing }
DiyaButton >> updateLayout [
	rec extent: self extent.
	label position: 0@0.
	label extent: self extent.
]
