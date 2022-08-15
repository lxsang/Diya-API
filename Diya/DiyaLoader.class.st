Class {
	#name : #DiyaLoader,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'node',
		'jobs'
	],
	#category : #'Diya-Applications'
}

{ #category : #scheduling }
DiyaLoader >> executeJobs: callback [
	jobs withIndexDo: [ :job :i|
		self updateProgress: job key percent: ((i - 1) * 100 / (jobs size)) asInteger.
		job value value.
	].
	jobs := OrderedCollection new.
	self updateProgress: 'Finishing...' percent: 100.
	500 milliSeconds wait.
	callback value.
]

{ #category : #initialization }
DiyaLoader >> init [
	self subclassResponsibility 
]

{ #category : #initialization }
DiyaLoader >> initialize [
	super initialize.
	node := DiyaCompositeNode new.
	jobs := OrderedCollection new.
	self init.
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

{ #category : #scheduling }
DiyaLoader >> updateProgress: name percent: p [
	self subclassResponsibility 
]
