Class {
	#name : #DiyaStyleSheet,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'stylesheet'
	],
	#category : #'Diya-UIThemes'
}

{ #category : #convenience }
DiyaStyleSheet >> ? styleName [
	^stylesheet at: styleName ifAbsent:[
		DiyaCoreAPIError signal: 'Unable to query stylesheet ', styleName
	]. 
]

{ #category : #initialization }
DiyaStyleSheet >> define: styName extend: parentStyName styles: rules [
	|parentSheet style|
	parentSheet := self ? parentStyName.
	style := self define: styName styles: rules.
	style parent: parentSheet.
	^style
	
]

{ #category : #initialization }
DiyaStyleSheet >> define: name styles: rules [
	|style|
	style := rules asDiyaStyle.
	stylesheet at: name put: style.
	^style
	
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
