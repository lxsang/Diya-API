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
	bbox := self recFromPoints.
	self calculateVertices.
	^true
]

{ #category : #accessing }
DiyaPolygon >> recFromPoints [
	|maxX maxY minX minY x y|
	maxX := minX := (points at: 1) x.
	maxY := minY := (points at: 1) y.
	points  do: [ :p|
		x := p x.
		y := p y.
		maxX := maxX max: x.
		maxY := maxY max: y.
		minX := minX min: x.
		minY := minY min: y.
	].
	^ Rectangle origin: minX@minY corner: maxX @ maxY
]
