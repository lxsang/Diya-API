Class {
	#name : #DiyaApplicationLauncher,
	#superclass : #DiyaApplicationModel,
	#instVars : [
		'currapp',
		'txtFPS',
		'event',
		'running'
	],
	#category : #'Diya-Applications'
}

{ #category : #initialization }
DiyaApplicationLauncher >> appNode [
	^root children first
]

{ #category : #initialization }
DiyaApplicationLauncher >> bindGlobalEvent [
	|pointer |
	pointer := root addNode: (DiyaCircle r: 10) at: 200@200. 
	pointer color: Color orange.
	pointer borderColor: Color red.
	pointer borderWidth: 2.
	root on: #keydown do:[:e| Transcript show: 'keydown...';cr. running := false.].
	root on: #quit do: [:e| running := false].
	root on: #(fingerdown fingermotion mousemotion) do:[:e|
		pointer position: e mapped worldPosition.
		DiyaRendererContext uniqueInstance mouse: (e mapped x) @ (e mapped y).
	].
]

{ #category : #initialization }
DiyaApplicationLauncher >> defaultApplication [
	^DiyaExampleApp
]

{ #category : #'as yet unclassified' }
DiyaApplicationLauncher >> delta: delta [
	|fps|
	delta = 0 ifTrue:[^self].
	fps := ((1000/delta) asInteger).
	txtFPS data: ('FPS:', fps asString).
]

{ #category : #initialization }
DiyaApplicationLauncher >> initialize [
	super initialize.
	root := DiyaRootNode new.
	currapp := nil.
]

{ #category : #initialization }
DiyaApplicationLauncher >> launch: app [
	currapp ifNotNil: [
		currapp quit.
		root empty.
	].
	currapp := app uniqueInstance.
	self appNode addNode: currapp root.
	self context assets: currapp am.
	currapp setup.
]

{ #category : #initialization }
DiyaApplicationLauncher >> main [
	[(SDL2 pollEvent: event) > 0] whileTrue: [
		root trigger: (DiyaEvent from: event mapped).
	].
	currapp ifNotNil: [currapp main.].
	root render.
]

{ #category : #accessing }
DiyaApplicationLauncher >> running [
	^ running
]

{ #category : #initialization }
DiyaApplicationLauncher >> setup [
	event := SDL_Event new.
	root addNode: (Diya2DNode new) at: 0@10.
	txtFPS := root addNode:(DiyaText data: 'tick') at: ( self context resolution x - 80)@40.
	txtFPS extent: 80@40.
	txtFPS fontSize: 18.
	txtFPS color: Color red.
	self bindGlobalEvent.
	running := true.
	self launch: self defaultApplication.
]
