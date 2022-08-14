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
	pointer styleName: #pointer.
	root on: #keydown do:[:e| self stdlog: 'keydown...'. running := false.].
	root on: #quit do: [:e| running := false].
	root on: #(fingerdown fingermotion mousemotion) do:[:e|
		pointer position: e mapped worldPosition.
		DiyaRenderer mouse: (e mapped x) @ (e mapped y).
	].
]

{ #category : #initialization }
DiyaApplicationLauncher >> defaultApplication [
	^DiyaExampleApp
]

{ #category : #initialization }
DiyaApplicationLauncher >> initialize [
	super initialize.
	root := DiyaRenderer root.
	currapp := nil.
]

{ #category : #initialization }
DiyaApplicationLauncher >> launch: app [
	currapp ifNotNil: [
		currapp quit.
		root empty.
	].
	currapp := app uniqueInstance.
	self context assets: currapp am.
	[
		self stdlog: 'Loading application'.
		currapp root visibility: false.
		currapp setup.
		currapp root forceReload.
		self appNode addNode: currapp root.
		currapp root visibility: true.
		self stdlog: 'Application LOADED'.
	] fork.
]

{ #category : #initialization }
DiyaApplicationLauncher >> main [
	| fps delta|
	delta := DiyaSystemClock delta asMilliSeconds.
	fps := DiyaSystemSettings maxFPS.
	delta = 0 ifFalse:[ fps :=  (1000/ delta) asInteger].
	txtFPS data: ('FPS:', fps asString).
	[(SDL2 pollEvent: event) > 0] whileTrue: [
		root trigger: (DiyaEvent from: event mapped).
	].
	currapp ifNotNil: [currapp main.].
]

{ #category : #accessing }
DiyaApplicationLauncher >> running [
	^ running
]

{ #category : #initialization }
DiyaApplicationLauncher >> setup [
	event := SDL_Event new.
	DiyaUIThemesManager uniqueInstance currentTheme
		define: #fps_text styles: { 
			#color -> Color red.
			#fontSize -> 18.
			#bgColor -> Color transparent.
		};
		define: #pointer styles: { 
			#borderColor -> Color red.
			#bgColor -> Color orange.
			#border -> 3
		}.
	root addNode: (DiyaCompositeNode new) at: 0@0.
	txtFPS := root addNode:(DiyaText data: '') at: ( self context resolution x - 80)@(self context resolution y - 40).
	txtFPS extent: 80@40.
	txtFPS styleName: #fps_text.
	self bindGlobalEvent.
	running := true.
	self launch: self defaultApplication.
]
