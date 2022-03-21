Class {
	#name : #DiyaApplicationModel,
	#superclass : #DiyaSingleton,
	#instVars : [
		'root',
		'am'
	],
	#category : #'Diya-Applications'
}

{ #category : #accessing }
DiyaApplicationModel >> am [
	^ am
]

{ #category : #accessing }
DiyaApplicationModel >> cleanup [
	self subclassResponsibility 
]

{ #category : #accessing }
DiyaApplicationModel >> context [
	^DiyaRendererContext uniqueInstance
]

{ #category : #initialization }
DiyaApplicationModel >> initialize [ 
	super initialize.
	am := AssetManager new.
]

{ #category : #accessing }
DiyaApplicationModel >> main [
	self subclassResponsibility 
]

{ #category : #accessing }
DiyaApplicationModel >> quit [
	self cleanup
]

{ #category : #accessing }
DiyaApplicationModel >> root [
	^ root
]

{ #category : #accessing }
DiyaApplicationModel >> setup [
	self subclassResponsibility 
]
