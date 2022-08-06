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

{ #category : #accessing }
DiyaWidget >> bgColor:v [
	^style set: #bgcolor value: v

]

{ #category : #accessing }
DiyaWidget >> color [
	^style get: #color
]

{ #category : #accessing }
DiyaWidget >> color: value [
	style set: #color value: value
]

{ #category : #geometry }
DiyaWidget >> extent [
	^extent
]

{ #category : #geometry }
DiyaWidget >> extent: size [
	extent := size.
	dirty := true.
]

{ #category : #initialization }
DiyaWidget >> initialize [
	super initialize.
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
