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
	currapp setup.
	currapp root forceReload.
	Transcript show: 'APPLICATION INIT'; cr.
	self context assets: currapp am.
	self appNode addNode: currapp root.
]

{ #category : #initialization }
DiyaApplicationLauncher >> main [
	| fps delta|
	delta := DiyaClock uniqueInstance delta asMilliSeconds.
	fps := DiyaBoot maxFPS.
	delta = 0 ifFalse:[ fps :=  (1000/ delta) asInteger].
	txtFPS data: ('FPS:', fps asString).
	[(SDL2 pollEvent: event) > 0] whileTrue: [
		root trigger: (DiyaEvent from: event mapped).
	].
	currapp ifNotNil: [currapp main.].
	"root render."
	root stepDown.
	self process.
	root render.
]

{ #category : #initialization }
DiyaApplicationLauncher >> process [
	|Q  node maxProcessingTime|
	maxProcessingTime := 1000 / DiyaBoot maxFPS - 100.
	Q := root processingQueue select:[:e| e visibility].
	Q ifEmpty:[^ self].
	[
		node := Q removeFirst.
		node process.
		root cleanDirtyNode: node.
	 	Q isNotEmpty and: DiyaClock uniqueInstance lapDelta asMilliSeconds < maxProcessingTime
	] whileTrue
	
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
