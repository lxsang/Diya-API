Class {
	#name : #AssetManager,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'assets',
		'base'
	],
	#category : #'Diya-Core'
}

{ #category : #'instance creation' }
AssetManager class >> defaultAssetLocation [
	^Smalltalk imageDirectory / 'assets'
	
]

{ #category : #'instance creation' }
AssetManager class >> fromLocation: loc [
	^self new from: loc; yourself
]

{ #category : #'as yet unclassified' }
AssetManager >> from: location [
	base := location
]

{ #category : #initialization }
AssetManager >> initialize [
	super initialize.
	assets := Dictionary new.
	base := self class defaultAssetLocation
]

{ #category : #'as yet unclassified' }
AssetManager >> name: fileName of: type [
	^assets at: fileName ifAbsentPut: [(type fromFile: (base / fileName))].
]

{ #category : #'as yet unclassified' }
AssetManager >> texture: name [
	^self name: name of: DiyaImageTex
]
