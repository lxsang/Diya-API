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
	dirty := true
]

{ #category : #accessing }
DiyaWidget >> update [
	self updateLayout.
	^ true
]

{ #category : #accessing }
DiyaWidget >> updateLayout [
	self subclassResponsibility 
]
