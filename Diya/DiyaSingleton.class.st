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
	self error: 'Use #uniqueInstance'
]

{ #category : #'instance creation' }
DiyaSingleton class >> reset [
	|singleton|
	singleton := singletons at: self class ifAbsent: [ ^ self ].
	self cleanUpInstance: singleton.
	singletons removeKey: self class
]

{ #category : #'instance creation' }
DiyaSingleton class >> uniqueInstance [ 
	singletons at: self class ifAbsentPut: super new.
	^ singletons at: self class
]
