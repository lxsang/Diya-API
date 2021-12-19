Class {
	#name : #DiyaInit,
	#superclass : #Object,
	#classVars : [
		'singleton'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'Diya-Core'
}

{ #category : #'instance creation' }
DiyaInit class >> uniqueInstance [ 
	singleton ifNil: [ singleton := self new ].
	^ singleton
]

{ #category : #events }
DiyaInit >> checkDrivers [
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
DiyaInit >> eventLoop [
	|status dm|
	self checkDrivers.
	status := SDL2 init: SDL_INIT_EVERYTHING.
	status = 0 ifFalse:[
		^ self error: SDL2 getErrorMessage.
	].
	Transcript show: 'Current selected video driver ', (SDL2 SDLGetCurrentVideoDriver); cr.
	dm := SDL_DisplayMode new.
	SDL2 SDLGetCurrentDisplayMode: dm from:0.
	Transcript show: dm w asString, 'x',dm h asString;cr. 
	SDL2 quit
]
