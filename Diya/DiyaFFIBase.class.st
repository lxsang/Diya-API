Class {
	#name : #DiyaFFIBase,
	#superclass : #DiyaBaseObject,
	#category : #'Diya-Core'
}

{ #category : #accessing }
DiyaFFIBase class >> checkSymbol [
	^self subclassResponsibility 
]

{ #category : #accessing }
DiyaFFIBase class >> ffiLibraryName [
	^ self moduleName 
]

{ #category : #accessing }
DiyaFFIBase class >> libNames [
	^self subclassResponsibility
]

{ #category : #accessing }
DiyaFFIBase class >> moduleName [
	self libNames do:[:aName|
		(ExternalAddress loadSymbol: self checkSymbol from: aName) ifNotNil: [ 
			^ aName
		].
	].
	self error: 'Unable to find FFI library (', self checkSymbol, ')'.
]

{ #category : #'library path' }
DiyaFFIBase >> ffiLibraryName [ 
	^self class ffiLibraryName
]
