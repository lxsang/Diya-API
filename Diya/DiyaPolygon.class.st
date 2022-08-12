Class {
	#name : #DiyaPolygon,
	#superclass : #Diya2DPrimShape,
	#instVars : [
		'points'
	],
	#category : #'Diya-Graphics'
}

{ #category : #'as yet unclassified' }
DiyaPolygon class >> points: points [
	^self new points: points; yourself
]

{ #category : #'as yet unclassified' }
DiyaPolygon class >> points: points shader:s [
	^self new points: points; shader:s; yourself
]

{ #category : #accessing }
DiyaPolygon >> calculateVertices [
	^self subclassResponsibility 
]

{ #category : #initialization }
DiyaPolygon >> initialize [
	super initialize.
	points := {}.
	vbuffer := nil.
]

{ #category : #accessing }
DiyaPolygon >> points [
	^ points
]

{ #category : #accessing }
DiyaPolygon >> points: anObject [
	points := anObject.
	self setDirty
]

{ #category : #accessing }
DiyaPolygon >> process [
	bbox := Rectangle encompassing: points.
	self calculateVertices.
	^true
]
