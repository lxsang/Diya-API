Class {
	#name : #'SDL_DisplayMode',
	#superclass : #SDL2Structure,
	#classVars : [
		'OFFSET_DRIVERDATA',
		'OFFSET_FORMAT',
		'OFFSET_H',
		'OFFSET_REFRESH_RATE',
		'OFFSET_W'
	],
	#pools : [
		'SDL2Types'
	],
	#category : #'Diya-SDL2'
}

{ #category : #'field definition' }
SDL_DisplayMode class >> fieldsDesc [
	^#(
		Uint32 format;
		int w;
		int h;
		int refresh_rate;
		void* driverdata;
	)
]

{ #category : #converting }
SDL_DisplayMode >> asString [
	^ 'SDL display: ', self width asString, 'x', self height asString, ' - ', self depth asString, ' bits depth'.
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> depth [
	|format depth|
	format := SDL2 SDLAllocFormat: self format.
	depth := format BitsPerPixel.
	SDL2 SDLFreeFormat: format.
	^depth
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> driverdata [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_DRIVERDATA) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> driverdata: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_DRIVERDATA put: anObject getHandle.
]

{ #category : #other }
SDL_DisplayMode >> forceDisplayUpdate [
	
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> format [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_FORMAT
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> format: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_FORMAT put: anObject
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> h [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_H
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> h: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_H put: anObject
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> height [
	^ self h
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> refresh_rate [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_REFRESH_RATE
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> refresh_rate: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_REFRESH_RATE put: anObject
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> w [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_W
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> w: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_W put: anObject
]

{ #category : #'accessing structure variables' }
SDL_DisplayMode >> width [
	^ self w
]
