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
	target on: #keydown do:[:e| self stdlog: 'keydown...'. running := false.].
	target on: #quit do: [:e| running := false].
	target on: #(fingerdown fingermotion mousemotion) do:[:e|
		pointer position: e mapped worldPosition.
		DiyaRenderer mouse: (e mapped x) @ (e mapped y).
	].
]

{ #category : #initialization }
DiyaApplicationLauncher >> defaultApplication [
	^DiyaExampleApp
]

{ #category : #initialization }
DiyaApplicationLauncher >> defineLayout [
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
	self loadNode.
]

{ #category : #initialization }
DiyaApplicationLauncher >> initialize [
	super initialize.
	node := DiyaCompositeNode new.
	currapp := nil.
]

{ #category : #initialization }
DiyaApplicationLauncher >> launch: app [
	currapp ifNotNil: [
		currapp quit.
	].
	currapp := app uniqueInstance.
	self context assets: currapp am.
	currapp target: self appNode.
	currapp onloaded:[
		self stdlog: 'Application LOADED'.
	].
]

{ #category : #initialization }
DiyaApplicationLauncher >> onloaded: aBlock [
	|loader|
	running := true.
	loader := DiyaDefaultSystemLoader on: target.
	loader job: [ DiyaFontManager uniqueInstance loadFonts. ] name: 'Loading fonts...'.
	loader job: [ self defineLayout ] name: 'Define layout...'. 
	loader onloaded: [
		node children do:[:c| target addNode: c at: c position].
		node := target.
		aBlock value.
		self launch: self defaultApplication.
	]
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
