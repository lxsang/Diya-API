Class {
	#name : #DiyaWidget,
	#superclass : #Diya2DNode,
	#instVars : [
		'extent'
	],
	#category : #'Diya-Widgets'
}

{ #category : #'instance creation' }
DiyaWidget class >> fromStyle: aStyle [
	^self new style: aStyle; yourself 
]

{ #category : #geometry }
DiyaWidget >> extent [
	^extent
]

{ #category : #geometry }
DiyaWidget >> extent: size [
	extent := size.
	self setDirty.
]

{ #category : #initialization }
DiyaWidget >> initialize [
	super initialize.
]
