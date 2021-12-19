Class {
	#name : #DiyaBoot,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'running',
		'window',
		'renderer',
		'display'
	],
	#classVars : [
		'singleton'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'Diya-Runtime'
}

{ #category : #'instance creation' }
DiyaBoot class >> reset [
	singleton := nil
]

{ #category : #'instance creation' }
DiyaBoot class >> startUp: status [
	self startx.
]

{ #category : #'instance creation' }
DiyaBoot class >> startx [
	self uniqueInstance run
]

{ #category : #'instance creation' }
DiyaBoot class >> uniqueInstance [ 
	singleton ifNil: [ singleton := self new ].
	^ singleton
]

{ #category : #events }
DiyaBoot >> checkDrivers [
	|ndriver usableDrivers|
	ndriver  := SDL2 SDLGetNumVideoDrivers.
	usableDrivers := OrderedCollection new.
	Transcript show: 'Available drivers: '.
	0 to: ndriver - 1 do: [ :i | |dname|
		dname := SDL2 SDLGetVideoDriver: i.
		Transcript show: dname, ' '.
		(SDL2 SDLVideoInit: dname) = 0 ifTrue:[
			usableDrivers add: dname.
			SDL2 SDLVideoQuit 
		]
	].
	Transcript cr.
	
]

{ #category : #events }
DiyaBoot >> createRenderer [
	|numdriver rinfo|
	numdriver := SDL2 SDLGetNumRenderDrivers.
	Transcript show: 'SDL_RENDER_DRIVER available:'.
	rinfo := SDL_RendererInfo externalNew autoRelease.
	0 to: numdriver - 1 do:[:i|
		SDL2 SDLGetRendererDriverInfo: rinfo from: i.
		 Transcript show: rinfo name readString, ' '.
	].
	Transcript cr.
	renderer := window primCreateRenderer: -1 flags: SDL_RENDERER_ACCELERATED.
	renderer ifNil: [ ^self error: SDL2 getErrorMessage ].
	renderer primGetRendererInfo: rinfo.
	Transcript show: 'SDL_RENDER_DRIVER selected: ', rinfo name readString;cr.
	^renderer 
	
]

{ #category : #events }
DiyaBoot >> createWindow [
	|handle|
	handle := SDL2 createWindow: 'Diya test'
			x: 0
			y: 0
			width: display w
			height: display h
			flags: SDL_WINDOW_SHOWN.
	handle ifNil: [ ^self error: SDL2 getErrorMessage ].
	"handle fullscreen: SDL_WINDOW_FULLSCREEN."
	^handle
]

{ #category : #events }
DiyaBoot >> init [
	| status nvdrivers |
	Transcript show:'System: ',
		(Smalltalk globals at: #CODENAME ifAbsent:['']),
		'-v',(Smalltalk  globals at: #VERSION ifAbsent: ['']);
		cr.
	status := SDL2 init: SDL_INIT_EVERYTHING.
	status = 0
		ifFalse: [ ^ self error: SDL2 getErrorMessage ].
	nvdrivers := SDL2 SDLGetNumVideoDrivers.
	Transcript show: 'Supported video dirvers:'.
	0 to: nvdrivers -1 do: [ :i |
		Transcript show: (SDL2 SDLGetVideoDriver: i), ' '.
	].
	Transcript cr.
	Transcript show: 'Current selected video driver: ',
				(SDL2 SDLGetCurrentVideoDriver);
				cr.
]

{ #category : #events }
DiyaBoot >> initialize [
	running := true
]

{ #category : #events }
DiyaBoot >> processEvent: event [
	|mappedEvt|
	mappedEvt := event mapped.
	mappedEvt type = SDL_KEYDOWN ifTrue: [ Transcript show: 'keydown...'. ^running := false. ].
	mappedEvt type = SDL_QUIT ifTrue:[ ^running:= false ].
	mappedEvt type = SDL_FINGERDOWN ifTrue:[^self setCursorPosition: mappedEvt ].
	mappedEvt type = SDL_FINGERMOTION ifTrue:[^self setCursorPosition: mappedEvt ].
]

{ #category : #events }
DiyaBoot >> randomColorChannel [
	| rand |
	rand := Random new.
	rand := (rand next) * 255.
	rand := rand asInteger.
	^ rand
]

{ #category : #events }
DiyaBoot >> render [
	|event|
	event := SDL_Event new.
	[ running ] whileTrue: [ 
		[ (SDL2 pollEvent: event) > 0 ] whileTrue: [
			self processEvent: event
		].
		renderer drawColorR: self randomColorChannel
				g: self randomColorChannel
				b: self randomColorChannel
				a: 255.
		renderer clear.
		renderer present.
		SDL2 delay: 50. 
	].
]

{ #category : #events }
DiyaBoot >> run [
	self init.
	Transcript show: 'Current selected video driver: ', (SDL2 SDLGetCurrentVideoDriver); cr.
	display := SDL_DisplayMode externalNew autoRelease.
	SDL2 SDLGetCurrentDisplayMode: display from:0.
	Transcript show:'Display resolution: ', display w asString, 'x',display h asString;cr. 
	window := self createWindow.
	renderer := self createRenderer.
	self render.
	renderer destroy.
	window destroy.
	SDL2 quit.
	Transcript show: 'System quit'; cr.
]

{ #category : #events }
DiyaBoot >> setCursorPosition: mappedEvt [
	Transcript show: 'x: ', mappedEvt x asString, ' - y: ', mappedEvt y asString; cr.
	window warpMouseX:((mappedEvt x)* (display w) )
			Y: ((mappedEvt y) * (display h))
]
