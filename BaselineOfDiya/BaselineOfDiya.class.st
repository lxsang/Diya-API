Class {
	#name : #BaselineOfDiya,
	#superclass : #BaselineOf,
	#category : #BaselineOfDiya
}

{ #category : #baselines }
BaselineOfDiya class >> corePackages [
	| groups |

	groups := self packagesOfGroupNamed: 'core-traits'.
	^ groups flatCollect: [ :e | self packagesOfGroupNamed: e ].
]

{ #category : #baselines }
BaselineOfDiya >> baseline: spec [
	<baseline>

	spec for: #common do: [

		spec 
			package: 'Diya'.

		spec group: 'API' with: #('Diya').
	
		spec group: 'default' with: #('API').	
	 ].	

]
