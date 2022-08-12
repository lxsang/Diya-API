Class {
	#name : #DiyaBaseApplication,
	#superclass : #DiyaApplicationModel,
	#category : #'Diya-Applications'
}

{ #category : #initialization }
DiyaBaseApplication >> initialize [
	super initialize.
	root := DiyaCompositeNode new.
	root styleName: #global.
	am := AssetManager new.
]
