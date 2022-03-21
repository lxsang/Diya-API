Class {
	#name : #DiyaWidget,
	#superclass : #Diya2DNode,
	#instVars : [
		'style',
		'extent'
	],
	#category : #'Diya-Widgets'
}

{ #category : #'instance creation' }
DiyaWidget class >> fromStyle: aStyle [
	^self new style: aStyle; yourself 
]

{ #category : #accessing }
DiyaWidget >> applyStyle [
	self subclassResponsibility
]

{ #category : #geometry }
DiyaWidget >> extent: size [
	extent := size.
	dirty := true.
]

{ #category : #initialization }
DiyaWidget >> initialize [
	super initialize.
	self style: DiyaDefaultStyle new.
]

{ #category : #accessing }
DiyaWidget >> style [
	^ style
]

{ #category : #accessing }
DiyaWidget >> style: anObject [
	style := anObject.
	self applyStyle.
]

{ #category : #accessing }
DiyaWidget >> update [
	self applyStyle.
	^ true
]
