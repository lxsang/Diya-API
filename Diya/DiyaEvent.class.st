Class {
	#name : #DiyaEvent,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'enable',
		'mapped',
		'target'
	],
	#category : #'Diya-Events'
}

{ #category : #'instance creation' }
DiyaEvent class >> from: mappedEvt [
	^ self new mapped: mappedEvt; yourself
]

{ #category : #accessing }
DiyaEvent >> enable [
	^ enable
]

{ #category : #initialization }
DiyaEvent >> initialize [ 
	super initialize.
	enable := true.
]

{ #category : #accessing }
DiyaEvent >> mapped [
	^ mapped
]

{ #category : #accessing }
DiyaEvent >> mapped: anObject [
	mapped := anObject
]

{ #category : #initialization }
DiyaEvent >> preventDefault [
	enable := false
]

{ #category : #accessing }
DiyaEvent >> target [
	^ target
]

{ #category : #accessing }
DiyaEvent >> target: anObject [
	target := anObject
]
