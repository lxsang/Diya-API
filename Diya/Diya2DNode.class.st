Class {
	#name : #Diya2DNode,
	#superclass : #DiyaNode,
	#category : #'Diya-Graphics'
}

{ #category : #'as yet unclassified' }
Diya2DNode >> gltf: points do: block [
	^ points collect: [ :point | |coord|
		coord := self tf +* { point x. point y. 1.0 }.
		block value: coord first value: (coord at:2)
	 ]
]

{ #category : #initialization }
Diya2DNode >> initialize [
	super initialize.
	translation := 0@0.
	scale := 1.0@1.0.
	rotation := 0.0.
	tf := Array2D identity: 3.
]

{ #category : #accessing }
Diya2DNode >> updateTF [
	tf := Array2D identity:3.
	"translation"
		tf := tf +* (Array2D rows: 3 columns: 3 contents: {
			1.0. 0.0. translation x.
			0.0. 1.0. translation y.
			0.0. 0.0. 1.0
		}).
	"rotation"
		tf := tf +* (Array2D rows: 3 columns: 3 contents:{
			rotation cos. (rotation sin) negated. 0.0.
			rotation sin. rotation cos. 0.0.
			0.0. 0.0. 1.0
		}).
	"scale"
		tf := tf +* (Array2D rows: 3 columns: 3 contents:{
			scale x. 0.0. 0.0.
			0.0. scale y. 0.0.
			0.0. 0.0. 1.0
		}).
	self parent isRoot ifTrue: [ ^tf ].
	tf := self parent tf +* tf
]
