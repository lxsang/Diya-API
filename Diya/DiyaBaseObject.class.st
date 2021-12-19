Class {
	#name : #DiyaBaseObject,
	#superclass : #Object,
	#category : #'Diya-Core'
}

{ #category : #accessing }
DiyaBaseObject >> stderr [
	VTermOutputDriver stderr
]

{ #category : #accessing }
DiyaBaseObject >> stdout [
	^ VTermOutputDriver stdout
]
