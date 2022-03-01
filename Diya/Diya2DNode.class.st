Class {
	#name : #Diya2DNode,
	#superclass : #DiyaNode,
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
Diya2DNode >> drawOn: context [
	^self subclassResponsibility 
]

{ #category : #initialization }
Diya2DNode >> initialize [
	super initialize.
	translation := 0@0.
	scale := 0@0.
	rotation := 0.0.
	tf := Array2D identity: 3.
]

{ #category : #accessing }
Diya2DNode >> renderOn: context [
	self updateTF.
	self  drawOn: context.
]

{ #category : #accessing }
Diya2DNode >> updateTF [
	tf := Array2D identity:3.
	"translation"
		tf := tf +* {
			1. 0. translation x.
			0. 1. translation y.
			0. 0. 1
		}.
	"scale"
		tf := tf +* {
			scale x. 0. 0.
			0. scale y. 0.
			0. 0. 1.
		}.
	"rotation"
		tf := tf +* {
			rotation cos. 0-(rotation sin). 0.
			rotation sin. rotation cos. 0.
			0. 0. 1
		}.
	self parent = DiyaRootNode uniqueInstance ifTrue: [ ^tf ].
	tf := self parent tf +* tf
]
