Class {
	#name : #DiyaBaseApplication,
	#superclass : #DiyaApplicationModel,
	#category : #'Diya-Applications'
}

{ #category : #initialization }
DiyaBaseApplication >> initialize [
	super initialize.
	root := Diya2DNode new.
]
