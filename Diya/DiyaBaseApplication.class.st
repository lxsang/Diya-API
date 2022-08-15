Class {
	#name : #DiyaBaseApplication,
	#superclass : #DiyaApplicationModel,
	#category : #'Diya-Applications'
}

{ #category : #initialization }
DiyaBaseApplication >> initialize [
	super initialize.
	node := DiyaCompositeNode new.
	node styleName: #global.
	am := AssetManager new.
]
