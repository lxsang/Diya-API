Class {
	#name : #DiyaSingleton,
	#superclass : #DiyaBaseObject,
	#classVars : [
		'singletons'
	],
	#category : #'Diya-Core'
}

{ #category : #'instance creation' }
DiyaSingleton class >> cleanUpInstance: singleton [
	"do nothing for now"
]

{ #category : #'class initialization' }
DiyaSingleton class >> initialize [
	singletons := Dictionary new.
]

{ #category : #'instance creation' }
DiyaSingleton class >> new [
	^ DiyaCoreAPIError signal: 'Use #uniqueInstance'
]

{ #category : #'instance creation' }
DiyaSingleton class >> reset [
	|singleton key|
	key := self class asString asSymbol.
	singleton := singletons at: key ifAbsent: [ ^ self ].
	self cleanUpInstance: singleton.
	singletons removeKey: key
]

{ #category : #'instance creation' }
DiyaSingleton class >> resetAll [
	self allSubclasses do:[:e| e reset]
]

{ #category : #'instance creation' }
DiyaSingleton class >> uniqueInstance [ 
	^singletons at: self class asString asSymbol  ifAbsentPut: [ super new ].
]

{ #category : #initialization }
DiyaSingleton >> initialize [
	super initialize.
	self stdlog: 'Initialise unique instance of ', self className.
]
