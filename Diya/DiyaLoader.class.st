Class {
	#name : #DiyaLoader,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'node',
		'jobs',
		'target'
	],
	#category : #'Diya-Applications'
}

{ #category : #'instance creation' }
DiyaLoader class >> on: target [
	^ self new target: target; yourself
]

{ #category : #scheduling }
DiyaLoader >> executeJobs: callback [
	"target visibility: false."
	target empty.
	target addNode: node.
	"target visibility: true".
	node visibility: true.
	self updateLayout.
	500 milliSeconds wait.
	self job: [ 500 milliSeconds wait. ] name: 'finishing' .
	jobs withIndexDo: [ :job :i|
		self updateProgress: job key percent: ((i - 1) * 100 / (jobs size)) asInteger.
		job value value.
	].
	jobs := OrderedCollection new.
	self updateProgress: 'Finishing...' percent: 100.
	
	node visibility: false.
	target empty.
	callback value.
	target visibility: true.
]

{ #category : #initialization }
DiyaLoader >> initialize [
	super initialize.
	node := DiyaCompositeNode new.
	jobs := OrderedCollection new.
	target := nil.
]

{ #category : #scheduling }
DiyaLoader >> job: aBlock name: aName [
	jobs add: (aName -> aBlock)
]

{ #category : #accessing }
DiyaLoader >> node [ 
	^ node
]

{ #category : #scheduling }
DiyaLoader >> onloaded: aBlock [
	[ self executeJobs: aBlock ] fork"At: Processor userBackgroundPriority". 
]

{ #category : #accessing }
DiyaLoader >> target [
	^ target
]

{ #category : #accessing }
DiyaLoader >> target: anObject [
	target := anObject
]

{ #category : #initialization }
DiyaLoader >> updateLayout [
	self subclassResponsibility 
]

{ #category : #scheduling }
DiyaLoader >> updateProgress: name percent: p [
	self subclassResponsibility 
]
