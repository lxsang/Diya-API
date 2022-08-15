Class {
	#name : #DiyaDefaultAppLoader,
	#superclass : #DiyaDefaultSystemLoader,
	#instVars : [
		'label'
	],
	#category : #'Diya-Applications'
}

{ #category : #initialization }
DiyaDefaultAppLoader >> updateLayout [
	super updateLayout.
	label ifNil:[
		label := node addNode: (DiyaText new) at: (progress position + (0@25)).
		label inlineStyle: #xAlign value: #center
	].
	label extent: (progress extent x) @ 40.
]

{ #category : #scheduling }
DiyaDefaultAppLoader >> updateProgress: name percent: p [
	label data: name.
	progress percent: p
]
