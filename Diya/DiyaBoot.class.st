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
DiyaBoot >> createRenderer [
	renderer := window primCreateRenderer: -1 flags: SDL_RENDERER_ACCELERATED.
	renderer ifNil: [ ^self error: SDL2 getErrorMessage ].
	^renderer 
	
]

{ #category : #events }
DiyaBoot >> createWindow [
	|handle|
	handle := SDL2 createWindow: 'Diya'
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
	| status |
	status := SDL2 init: SDL_INIT_EVERYTHING.
	status = 0
		ifFalse: [ ^ self error: SDL2 getErrorMessage ].
	display := SDL_DisplayMode externalNew autoRelease.
	SDL2 SDLGetCurrentDisplayMode: display from:0.
]

{ #category : #events }
DiyaBoot >> initialize [
	running := true.
	display := nil.
	window := nil.
	renderer := nil.
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
	self startx. 
]

{ #category : #running }
DiyaBoot >> run: screenSize [
	self run: screenSize app: nil
]

{ #category : #running }
DiyaBoot >> run: screenSize app: application [
	self init.
	display w: screenSize x.
	display h: screenSize y.
	self startx 
]

{ #category : #events }
DiyaBoot >> setCursorPosition: mappedEvt [
	window warpMouseX:((mappedEvt x)* (display w) )
			Y: ((mappedEvt y) * (display h))
]

{ #category : #logging }
DiyaBoot >> showSystemInfo [
	|stream numdriver rinfo|
	stream := (String new: 255) writeStream.
	stream nextPutAll:'System: ';
			nextPutAll:(Smalltalk globals at: #CODENAME ifAbsent:['']);
			nextPutAll: '-v';
			nextPutAll:(Smalltalk  globals at: #VERSION ifAbsent: ['']);cr.
	numdriver := SDL2 SDLGetNumVideoDrivers.
	stream nextPutAll: 'Supported video dirvers:'.
	0 to: numdriver -1 do: [ :i |
		stream nextPutAll: (SDL2 SDLGetVideoDriver: i); nextPutAll: ' '.
	].
	stream cr.
	stream nextPutAll: 'Current selected video driver: ';
			nextPutAll:(SDL2 SDLGetCurrentVideoDriver);cr.
	numdriver := SDL2 SDLGetNumRenderDrivers.
	stream nextPutAll: 'SDL_RENDER_DRIVER available:'.
	rinfo := SDL_RendererInfo externalNew autoRelease.
	0 to: numdriver - 1 do:[:i|
		SDL2 SDLGetRendererDriverInfo: rinfo from: i.
		 stream nextPutAll:  rinfo name readString; nextPutAll:' '.
	].
	stream cr.
	renderer primGetRendererInfo: rinfo.
	stream nextPutAll: 'SDL_RENDER_DRIVER selected: '; nextPutAll: rinfo name readString; cr.
	stream nextPutAll:'Display resolution: ';
		nextPutAll:display w asString;
		nextPutAll: 'x';
		nextPutAll: display h asString; cr. 
	self stdout nextPutAll: stream contents
	
]

{ #category : #events }
DiyaBoot >> startx [
	display ifNil: [ ^self error: 'Please run #init before this method' ].
	window := self createWindow.
	renderer := self createRenderer.
	self showSystemInfo.
	self render.
	renderer destroy.
	window destroy.
	SDL2 quit.
	self class reset.
	Smalltalk garbageCollect.
]
