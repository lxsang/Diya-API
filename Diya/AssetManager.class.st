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
AssetManager class >> fromLocation: loc [
	^self new from: loc; yourself
]

{ #category : #adding }
AssetManager >> addAsset: value [
	assets at: value name put: value.
	^ value
]

{ #category : #adding }
AssetManager >> addAssetName: name value: value [
	assets at: name put: value.
	^ value
]

{ #category : #'instance creation' }
AssetManager >> from: location [
	base := location
]

{ #category : #initialization }
AssetManager >> initialize [
	super initialize.
	assets := Dictionary new.
	base := DiyaSystemSettings assetPath
]

{ #category : #accessing }
AssetManager >> name: name [ 
	^assets at: name.
]

{ #category : #accessing }
AssetManager >> name: name of: type [
	^assets at: name ifAbsentPut: [
		(type fromFile: (base / name))].
]

{ #category : #accessing }
AssetManager >> texture: name [
	^self name: name of: DiyaImageTex
]
