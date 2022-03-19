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
DiyaBoot >> bindGlobalEventTo: aNode [
	|pointer|
	pointer := aNode addNode: (DiyaCircle r: 10) at: 200@200. 
	pointer color: Color orange.
	"pointer borderColor: Color red.
	pointer borderWidth: 3."
	aNode on: #keydown do:[:e| Transcript show: 'keydown...';cr. running := false.].
	aNode on: #quit do: [:e| running := false].
	aNode on: #fingerdown do:[:e| self setCursorPosition: e mapped ].
	aNode on: #fingermotion do:[:e| self setCursorPosition: e mapped ].
	aNode on: #mousemotion do:[:e|
		pointer position: e mapped worldPosition.
		DiyaRendererContext uniqueInstance mouse: (e mapped x) @ (e mapped y).
	].
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
DiyaBoot >> exampleNodes: tree [
	|root node node1 ell tex txtNode|
	root := tree addNode: (Diya2DNode new) at: 0@10.
	tex := (DiyaImageTex  fromFile:Smalltalk imageDirectory / 'assets'/'mrsang.png').
	txtNode := root addNode: (DiyaText data: 'Event') at: 10@50.
	txtNode color: Color orange.
	txtNode extent: 200@40.
	
	node1 := root addNode: (DiyaRectangle size:100@150 shader: DiyaExampleShader uniqueInstance) at: 100 @ 400.
	node1 rotation: (Float pi / 8.0).
	node1 scale: 1.2@1.2.
	node1 on: #mousebuttondown do:[:e| txtNode data: 'Mouse ', (node1 local: e mapped worldPosition) asIntegerPoint asString].
	node1 on: #fingerdown do:[:e| Transcript show:'finger down on image'; cr].
	
	node := root addNode: (DiyaRectangle size: 200@200) at: 250 @ 430.
	node texture: tex.
	node color: (Color r: 1.0 g:1.0  b:1.0  alpha:1.0 ).
	node borderColor: Color red.
	node borderWidth: 3.0.
	
	"style := DiyaFontManager uniqueInstance style: 'Regular' from:'Ubuntu'.
	tex1 := (style textureOf: 18).
	style := DiyaFontManager uniqueInstance style: 'Regular' from: 'bootstrap-icons'.
	node := root addNode: (DiyaRectangle size: tex1 extent) at: 250 @ 300.
	node color: (Color orange).
	node texture: tex1.
	node borderColor: Color red.
	node borderWidth: 3.0."
	
	
	node := root addNode: (DiyaText data: String loremIpsum) at: 10@400.
	node extent: 250@320.
	node wordWrap: true.
	
	node := root addNode: (DiyaLine from: 10@620 to: 200@635).
	node color: (Color red).
	node borderWidth: 2.0.
	
	
	ell := root addNode: (DiyaEllipse rx:150  ry: 100) at: 320@300.
	ell borderColor: Color red.
	ell color: Color white.
	ell rotation: Float pi / 6.0.
	ell borderWidth: 3.0.
	"node rotation: Float pi / 2.0."
	ell texture: tex.
	ell on: #mousebuttondown do:[:e| txtNode data: 'Ellipse clicked', (ell local:e mapped worldPosition) asIntegerPoint asString].
	ell on: #fingerdown do:[:e| Transcript show:'finger down on ellipse'; cr].

	
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
		ifFalse: [ ^ DiyaCoreAPIError signal: SDL2 getErrorMessage ].
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
	root := DiyaRootNode new.
	self exampleNodes: root.
	DiyaRenderer uniqueInstance root: root.
	text := root addNode:(DiyaText data: 'tick') at: (display w - 80)@40.
	text extent: 80@40.
	text fontSize: 18.
	text color: Color red.
	self bindGlobalEventTo: root.
	DiyaRendererContext uniqueInstance.
	self GLinit.
	[ running ] whileTrue: [
		delta := DiyaClock uniqueInstance delta asMilliSeconds.
		fps := ((1000/delta) asInteger).
		text data: ('FPS:', fps asString).
		DiyaClock uniqueInstance tick.
		[(SDL2 pollEvent: event) > 0] whileTrue: [
			root trigger: (DiyaEvent from: event mapped).
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
	display ifNil: [ ^DiyaCoreAPIError signal: 'Please run #init before this method' ].
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
