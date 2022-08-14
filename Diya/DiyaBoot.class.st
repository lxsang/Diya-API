Class {
	#name : #DiyaBoot,
	#superclass : #DiyaSingleton,
	#instVars : [
		'window',
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

{ #category : #'class initialization' }
DiyaBoot class >> initialize [
	Smalltalk globals at: #DiyaDisplay put: nil.
	Smalltalk globals at: #DiyaSystemClock put: nil.
	Smalltalk globals at: #DiyaRenderer put: nil.
	Smalltalk globals at: #DiyaSystemSettings put: nil.
]

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
	context ifNil: [ ^DiyaCoreAPIError signal: SDL2 getErrorMessage ].
	^context 
	
]

{ #category : #events }
DiyaBoot >> createWindow [
	SDL2
		glSetAttribute: SDL_GL_MULTISAMPLEBUFFERS value: 1;
		glSetAttribute: SDL_GL_MULTISAMPLESAMPLES value: 2.

	OpenGL enable: GL_MULTISAMPLE.
	
	window := SDL2 createWindow: 'Diya'
			x: 0
			y: 0
			width: display w
			height: display h
			flags: SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL.
	window ifNil: [ ^DiyaCoreAPIError signal: SDL2 getErrorMessage ].
	"handle fullscreen: SDL_WINDOW_FULLSCREEN."
	"SDL2 glSetAttribute: SDL_GL_CONTEXT_PROFILE_MASK value: SDL_GL_CONTEXT_PROFILE_ES.
	SDL2 glSetAttribute: SDL_GL_CONTEXT_MAJOR_VERSION value: 2.
	SDL2 glSetAttribute: SDL_GL_CONTEXT_MINOR_VERSION value: 0.
	SDL2 glSetAttribute: SDL_GL_ACCELERATED_VISUAL value: 1."
	"SDL2 glSetAttribute: SDL_GL_DOUBLEBUFFER value: 1.
	SDL2 glSetAttribute: SDL_GL_DEPTH_SIZE value: 24."
	
	^window
]

{ #category : #events }
DiyaBoot >> init [
	| status |
	SDL2 setHint: 'SDL_RENDER_DRIVER' value: 'opengles2'.
	status := SDL2 init: SDL_INIT_EVERYTHING.
	status = 0 
		ifFalse: [ ^ DiyaCoreAPIError signal: SDL2 getErrorMessage ].
	display := SDL_DisplayMode externalNew autoRelease.
	SDL2 SDLGetCurrentDisplayMode: display from:0.
	SDL2 showCursor: 0.
	DiyaSingleton resetAll.
	Smalltalk globals at: #Display ifAbsentPut:display.
	Smalltalk globals at: #DiyaDisplay put:display.
	Smalltalk globals at: #DiyaSystemSettings put: DiyaSettings uniqueInstance.
	Smalltalk globals at: #DiyaSystemClock put: DiyaClock uniqueInstance.
	DiyaFontManager uniqueInstance loadFonts.
]

{ #category : #events }
DiyaBoot >> initialize [
	display := nil.
	window := nil.
	context := nil.
	clock := DiyaSystemClock.
]

{ #category : #events }
DiyaBoot >> render [
	|launcher|
	launcher := DiyaApplicationLauncher uniqueInstance.
	launcher setup.
	"Init the Open  GL view port and enable 2D texture"
	OpenGL viewportX: 0 Y:0 W: display w H: display h.
	OpenGL enable: GL_TEXTURE_2D.
	[ launcher running ] whileTrue: [
		DiyaSystemClock tick.
		launcher main.
		DiyaRenderer render.
		SDL2 delay:
			(0 max:
				(1000/ DiyaSystemSettings maxFPS) asInteger - (DiyaSystemClock lapDelta)).
	].
]

{ #category : #events }
DiyaBoot >> run [
	|envar arr|
	envar := Smalltalk getenv:'DIYA_RES'.
	arr := nil.
	envar ifNotNil: [
		arr := (envar splitOn: 'x') collect: [ :e| e asInteger ] .
		arr size = 2 ifFalse:[
			arr := nil.
		]
	].
	arr
		ifNil: [ 
			self init.
			self startx.
		 ]
		ifNotNil: [ 
			self run: (arr at:1) @ (arr at: 2)
		]
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
	stream nextPutAll: DiyaDisplay asString; cr.
	stream cr.
	self stdout nextPutAll: stream contents
	
]

{ #category : #events }
DiyaBoot >> startx [
	display ifNil: [ ^DiyaCoreAPIError signal: 'Please run #init before this method' ].
	self createWindow.
	self createGLContext.
	"SDL2 glMakeCurrent: window  context: context." 
	self showSystemInfo.
	DiyaRendererContext
		uniqueInstance
			display: display;
			window: window;
			useProjection: OrthoProjectionMatrix.
	Smalltalk globals at: #DiyaRenderer put: DiyaRendererContext uniqueInstance.
	self render.
	context delete.
	window destroy.
	DiyaSingleton resetAll.
	SDL2 quit.
]
