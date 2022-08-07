Class {
	#name : #DiyaStyleSheet,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'stylesheet'
	],
	#category : #'Diya-Graphics'
}

{ #category : #convenience }
DiyaStyleSheet >> ? sheet [
	^stylesheet at: sheet ifAbsent:[
		DiyaCoreAPIError signal: 'Unable to query stylesheet ', sheet	
	]. 
]

{ #category : #initialization }
DiyaStyleSheet >> define: name styles: styles [
	stylesheet at: name put: styles asDictionary.
	^self
	
]

{ #category : #initialization }
DiyaStyleSheet >> initialize [
	super initialize.
	stylesheet := Dictionary new.
]

{ #category : #accessing }
DiyaStyleSheet >> stylesheet [
	^ stylesheet
]
