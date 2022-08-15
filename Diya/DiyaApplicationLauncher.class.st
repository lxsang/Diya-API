Class {
	#name : #DiyaApplicationLauncher,
	#superclass : #DiyaApplicationModel,
	#instVars : [
		'currapp',
		'txtFPS',
		'running'
	],
	#category : #'Diya-Applications'
}

{ #category : #initialization }
DiyaApplicationLauncher >> appNode [
	^node children first
]

{ #category : #initialization }
DiyaApplicationLauncher >> bindGlobalEvent [
	|pointer |
	pointer := node addNode: (DiyaCircle r: 10) at: 200@200. 
	pointer styleName: #pointer.
	node on: #keydown do:[:e| self stdlog: 'keydown...'. running := false.].
	node on: #quit do: [:e| running := false].
	node on: #(fingerdown fingermotion mousemotion) do:[:e|
		pointer position: e mapped worldPosition.
		DiyaRenderer mouse: (e mapped x) @ (e mapped y).
	].
]

{ #category : #initialization }
DiyaApplicationLauncher >> defaultApplication [
	^DiyaExampleApp
]

{ #category : #initialization }
DiyaApplicationLauncher >> initLoader [
	
]

{ #category : #initialization }
DiyaApplicationLauncher >> initialize [
	super initialize.
	node := DiyaRenderer root.
	currapp := nil.
]

{ #category : #initialization }
DiyaApplicationLauncher >> launch: app [
	currapp ifNotNil: [
		currapp quit.
		node empty.
	].
	currapp := app uniqueInstance.
	self context assets: currapp am.
	self appNode addNode: currapp loader node.
	currapp onloaded:[
		self appNode empty.
		currapp node visibility: false.
		self appNode addNode: currapp node.
		currapp node visibility: true.
		self stdlog: 'Application LOADED'.
	].
]

{ #category : #initialization }
DiyaApplicationLauncher >> onloaded: aBlock [
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
	node addNode: (DiyaCompositeNode new) at: 0@0.
	txtFPS := node addNode:(DiyaText data: '') at: ( self context resolution x - 80)@(self context resolution y - 40).
	node addNode: (DiyaTimerNode timeout: 0 do: [:n| self updateFPS ] ).
	txtFPS extent: 80@40.
	txtFPS styleName: #fps_text.
	self bindGlobalEvent.
	running := true.
	self launch: self defaultApplication.
	aBlock value.
]

{ #category : #accessing }
DiyaApplicationLauncher >> running [
	^ running
]

{ #category : #initialization }
DiyaApplicationLauncher >> updateFPS [
	| fps delta|
	delta := DiyaSystemClock delta.
	fps := DiyaSystemSettings maxFPS.
	delta = 0 ifFalse:[ fps :=  (1000/ delta) asInteger].
	txtFPS data: ('FPS:', fps asString).
]
