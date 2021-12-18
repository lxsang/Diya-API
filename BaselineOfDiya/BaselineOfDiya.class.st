Class {
	#name : #BaselineOfDiya,
	#superclass : #BaselineOf,
	#category : #BaselineOfDiya
}

{ #category : #baselines }
BaselineOfDiya >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec 
			package: 'Diya'.
		spec group: 'default' with: #('Diya').	
	 ].	

]
