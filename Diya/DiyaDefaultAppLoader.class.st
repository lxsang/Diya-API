Class {
	#name : #DiyaDefaultAppLoader,
	#superclass : #DiyaLoader,
	#instVars : [
		'progress',
		'label'
	],
	#category : #'Diya-Applications'
}

{ #category : #initialization }
DiyaDefaultAppLoader >> init [
	progress := node addNode: (DiyaLoadingBar new) at: 20@50.
	progress extent: 420 @ 20.
	label := node addNode: (DiyaText new) at: 20@80.
	label extent: 420 @ 20.
	label inlineStyle: #xAlign value: #center
]

{ #category : #scheduling }
DiyaDefaultAppLoader >> updateProgress: name percent: p [
	label data: name.
	progress percent: p
]
