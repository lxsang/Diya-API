Class {
	#name : #DiyaBoot,
	#superclass : #DiyaSingleton,
	#instVars : [
		'running',
		'window',
		'renderer',
		'context',
		'display',
		'clock'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes',
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'Diya-Runtime'
}

{ #category : #'instance creation' }
DiyaBoot class >> startUp: status [
	self startx.
]

{ #category : #'instance creation' }
DiyaBoot class >> startx [
	self uniqueInstance run
]

{ #category : #events }
DiyaBoot >> createGLContext [
	context :=  SDL2 glCreateContext:  window.
	context ifNil: [ ^self error: SDL2 getErrorMessage ].
	^context 
	
]

{ #category : #events }
DiyaBoot >> createRenderer [
	renderer := window primCreateRenderer: -1 flags: SDL_RENDERER_ACCELERATED.
	renderer ifNil: [ ^self error: SDL2 getErrorMessage ].
	^renderer 
	
]

{ #category : #events }
DiyaBoot >> createWindow [
	window := SDL2 createWindow: 'Diya'
			x: 0
			y: 0
			width: display w
			height: display h
			flags: SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL.
	window ifNil: [ ^self error: SDL2 getErrorMessage ].
	"handle fullscreen: SDL_WINDOW_FULLSCREEN."
	^window
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
	context := nil.
	clock := DiyaClock uniqueInstance.
]

{ #category : #events }
DiyaBoot >> processEvent: event [
	|mappedEvt|
	mappedEvt := event mapped.
	mappedEvt type = SDL_KEYDOWN ifTrue: [ Transcript show: 'keydown...'. ^running := false. ].
	mappedEvt type = SDL_QUIT ifTrue:[ ^running:= false ].
	mappedEvt type = SDL_FINGERDOWN ifTrue:[^self setCursorPosition: mappedEvt ].
	mappedEvt type = SDL_FINGERMOTION ifTrue:[^self setCursorPosition: mappedEvt ].
	mappedEvt type = SDL_MOUSEMOTION ifTrue:[DiyaRendererContext uniqueInstance mouse: mappedEvt].
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
		self step.
		SDL2 glSwapWindow: window.
		SDL2 delay: 50. 
	].
]

{ #category : #events }
DiyaBoot >> render:sr [
	|event|
	event := SDL_Event new.
	[ running ] whileTrue: [ 
		[ (SDL2 pollEvent: event) > 0 ] whileTrue: [
			self processEvent: event
		].
		OpenGL viewportX: 0 Y:0 W: display w H: display h .
		sr render.
		SDL2 glSwapWindow: window.
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
	"
	this function should be used only in
	SDK environment, in real embeded system
	it is always the #run command that is executed
	automatically.
	"
	OpenGLTypes initialize.
	OpenGLConstants initialize.
	self init.
	display w: screenSize x.
	display h: screenSize y.
	self startx.
	self class reset.
	DiyaClock reset.
	DiyaRendererContext reset.
	Smalltalk garbageCollect.
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
	renderer ifNotNil:[
		renderer primGetRendererInfo: rinfo.
		stream nextPutAll: 'SDL_RENDER_DRIVER selected: '; nextPutAll: rinfo name readString; cr.
	].
	stream nextPutAll:'Display resolution: ';
		nextPutAll:display w asString;
		nextPutAll: 'x';
		nextPutAll: display h asString; cr. 
	self stdout nextPutAll: stream contents
	
]

{ #category : #events }
DiyaBoot >> startx [
	|sr|
	display ifNil: [ ^self error: 'Please run #init before this method' ].
	self createWindow.
	self createGLContext.
	self createRenderer.
	self showSystemInfo.
	DiyaRendererContext uniqueInstance display: display.
	sr := SimpleDiyaRenderer new.
	sr setup.
	self render:sr.
	sr destroy.
	context delete.
	renderer destroy.
	window destroy.
	SDL2 quit.
]

{ #category : #events }
DiyaBoot >> step [
	"renderer drawColorR: 0
				g: 0
				b: 0
				a: 255."
	OpenGL begin: GL_TRIANGLES.
	"draw a simple triangle here"
	OpenGL color3fR: 0.1 G:0.2  B: 0.3.
	OpenGL vertex3fX: 0 Y: 0  Z: 0.
	OpenGL vertex3fX: 1 Y: 0  Z: 0.
	OpenGL vertex3fX: 0 Y: 1  Z: 0.  
	OpenGL end.
]
