Class {
	#name : #DiyaDefaultSystemLoader,
	#superclass : #DiyaLoader,
	#instVars : [
		'progress'
	],
	#category : #'Diya-Applications'
}

{ #category : #initialization }
DiyaDefaultSystemLoader >> updateLayout [
	|xtent|
	xtent := DiyaRenderer resolution.
	progress ifNil:[progress := node addNode: (DiyaLoadingBar new) at: 20@((xtent y >> 1) - 50)].
	progress extent: (xtent x - 40) @ 20.
]

{ #category : #scheduling }
DiyaDefaultSystemLoader >> updateProgress: name percent: p [
	progress percent: p
]
