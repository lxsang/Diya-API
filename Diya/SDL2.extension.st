Extension { #name : #SDL2 }

{ #category : #'*Diya' }
SDL2 class >> SDLAllocFormat: pixel_format [
	^ self ffiCall: #(SDL_PixelFormat * SDL_AllocFormat(Uint32 pixel_format))
	
]

{ #category : #'*Diya' }
SDL2 class >> SDLClearError [
	^ self ffiCall: #(void SDL_ClearError(void))
	
]

{ #category : #'*Diya' }
SDL2 class >> SDLFreeFormat: handle [
	^ self ffiCall: #(void SDL_FreeFormat(SDL_PixelFormat *handle))
	
]

{ #category : #'*Diya' }
SDL2 class >> SDLGetCurrentDisplayMode: mode from:index [
	^ self ffiCall: #(int SDL_GetCurrentDisplayMode(int index, SDL_DisplayMode* mode))
	
]

{ #category : #'*Diya' }
SDL2 class >> SDLGetCurrentVideoDriver [
	^self ffiCall: #(const char* SDL_GetCurrentVideoDriver(void))
	
]

{ #category : #'*Diya' }
SDL2 class >> SDLGetNumRenderDrivers [
	^self ffiCall: #(int SDL_GetNumRenderDrivers(void))
	
]

{ #category : #'*Diya' }
SDL2 class >> SDLGetNumVideoDrivers [
	^ self ffiCall: #(int SDL_GetNumVideoDrivers(void))
	
]

{ #category : #'*Diya' }
SDL2 class >> SDLGetRendererDriverInfo: info from: index [
	^self ffiCall: #(int SDL_GetRenderDriverInfo(int index, SDL_RendererInfo * info))
]

{ #category : #'*Diya' }
SDL2 class >> SDLGetVideoDriver: index [
	^self ffiCall: #(const char* SDL_GetVideoDriver(int index))
	
]

{ #category : #'*Diya' }
SDL2 class >> SDLVideoInit:driver_name [
	^self ffiCall: #(int SDL_VideoInit(const char *driver_name))
	
]

{ #category : #'*Diya' }
SDL2 class >> SDLVideoQuit [
	^ self ffiCall: #(void SDL_VideoQuit(void))
]

{ #category : #'*Diya' }
SDL2 class >> findSDL2 [
	"Look for SDL2 using different names."
	#(0							"Static"
	SDL2
	'libSDL2-2.0.0.dylib'		"Mac"
	'libSDL2-2.0.so.0'			"Linux 1"
	'libSDL2-2.0.so.0.2.1'	"Linux 2"
	'SDL2.dll'					"Windows"
	) do: [ :eachName | 
		[ (self checkLibraryName: eachName) ifTrue: [ ^ eachName ] ] 
		ifError: [nil] ].
	self error: 'Failed to find SDL2 library.'
]
