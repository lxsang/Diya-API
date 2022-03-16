Class {
	#name : #DiyaBoot,
	#superclass : #DiyaSingleton,
	#instVars : [
		'running',
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

{ #category : #'instance creation' }
DiyaBoot class >> maxFPS [
	^60
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
DiyaBoot >> GLinit. [
	OpenGL viewportX: 0 Y:0 W: display w H: display h.
	OpenGL enable: GL_TEXTURE_2D.
]

{ #category : #events }
DiyaBoot >> createGLContext [
	context :=  SDL2 glCreateContext:  window.
	context ifNil: [ ^self error: SDL2 getErrorMessage ].
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
	window ifNil: [ ^self error: SDL2 getErrorMessage ].
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
DiyaBoot >> exampleNodes [
	|root node style tex|
	root := DiyaRootNode new.
	tex := (DiyaImageTex  fromFile:Smalltalk imageDirectory / 'assets'/'mrsang.png').
	node := root addNode: (DiyaRectangle size: 200@200) at: 250 @ 430.
	node texture: tex.
	node color: (Color r: 1.0 g:1.0  b:1.0  alpha:1.0 ).
	node borderColor: Color red.
	node borderWidth: 3.0.
	
	style := DiyaFontManager uniqueInstance style: 'Regular' from:'Ubuntu'.
	node := root addNode: (DiyaRectangle size: 208@288) at: 250 @ 50.
	node color: (Color orange).
	node texture: (style textureOf: 16).
	node borderColor: Color red.
	node borderWidth: 3.0.
	
	node := root addNode: (DiyaRectangle size:100@150 shader: DiyaExampleShader uniqueInstance) at: 20 @ 400.
	node rotation: (Float pi / -8.0).
	node scale: 1.5@1.5.
	
	node := root addNode: (DiyaText data: String loremIpsum) at: 10@340.
	node extent: 250@320.
	node wordWrap: true.
	
	node := root addNode: (DiyaLine from: 10@620 to: 200@635).
	node color: (Color red).
	node borderWidth: 2.0.
	
	
	node := root addNode: (DiyaCircle  r: 100) at: 200@200.
	node borderColor: Color red.
	node color: Color white.
	node borderWidth: 3.0.
	node texture: tex.
	"node rotation:(Float pi / 4.0)".
	
	node := root addNode: (DiyaConvexPolygon points:{250@100. 400@250. 450@80. 350@60}).
	node color: Color green.
	node borderColor: Color red.
	node texture: tex.
	node borderWidth: 3.0.
	^ root
]

{ #category : #events }
DiyaBoot >> init [
	| status |
	SDL2 setHint: 'SDL_RENDER_DRIVER' value: 'opengles2'.
	status := SDL2 init: SDL_INIT_EVERYTHING.
	status = 0 
		ifFalse: [ ^ self error: SDL2 getErrorMessage ].
	display := SDL_DisplayMode externalNew autoRelease.
	SDL2 SDLGetCurrentDisplayMode: display from:0.
	DiyaRendererContext reset.
	DiyaFontManager reset.
	OpenGLSL resetShaders.
	DiyaFontManager uniqueInstance loadFonts.
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
	mappedEvt type = SDL_KEYDOWN ifTrue: [ Transcript show: 'keydown...';cr. ^running := false. ].
	mappedEvt type = SDL_QUIT ifTrue:[ ^running:= false ].
	mappedEvt type = SDL_FINGERDOWN ifTrue:[^self setCursorPosition: mappedEvt ].
	mappedEvt type = SDL_FINGERMOTION ifTrue:[^self setCursorPosition: mappedEvt ].
	mappedEvt type = SDL_MOUSEMOTION ifTrue:[DiyaRendererContext uniqueInstance mouse: (mappedEvt x) @ (mappedEvt y)].
	mappedEvt free.
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
	|event root text delta fps|
	event := SDL_Event new.
	root := self exampleNodes.
	DiyaRenderer uniqueInstance root: root.
	text := root addNode:(DiyaText data: 'tick') at: (display w - 80)@40.
	text extent: 80@40.
	text fontSize: 18.
	text color: Color red.
	DiyaRendererContext uniqueInstance.
	self GLinit.
	[ running ] whileTrue: [
		delta := DiyaClock uniqueInstance delta asMilliSeconds.
		fps := ((1000/delta) asInteger).
		text data: ('FPS:', fps asString).
		DiyaClock uniqueInstance tick.
		[(SDL2 pollEvent: event) > 0] whileTrue: [
			self processEvent: event
		].
		DiyaRenderer uniqueInstance render.
		
		SDL2 glSwapWindow: window.
		delta := DiyaClock uniqueInstance delta asMilliSeconds.
		SDL2 delay: (0 max: (1000/ self class maxFPS) asInteger - delta).
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
	stream nextPutAll:'Display resolution: ';
		nextPutAll:display w asString;
		nextPutAll: 'x';
		nextPutAll: display h asString; cr. 
	self stdout nextPutAll: stream contents
	
]

{ #category : #events }
DiyaBoot >> startx [
	display ifNil: [ ^self error: 'Please run #init before this method' ].
	self createWindow.
	self createGLContext.
	"SDL2 glMakeCurrent: window  context: context." 
	self showSystemInfo.
	DiyaRendererContext
		uniqueInstance display: display;
		useProjection: OrthoProjectionMatrix.
	self render.
	context delete.
	window destroy.
	DiyaFontManager reset.
	DiyaRendererContext reset.
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
