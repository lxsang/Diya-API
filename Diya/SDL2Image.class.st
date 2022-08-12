Class {
	#name : #SDL2Image,
	#superclass : #DiyaFFIBase,
	#pools : [
		'SDL2Constants',
		'SDL2ConstantsHint',
		'SDL2Types'
	],
	#category : #'Diya-SDL2'
}

{ #category : #'as yet unclassified' }
SDL2Image class >> SDLImgLoad: file [
	^ self ffiCall: #(SDL_Surface * IMG_Load(const char *file))
]

{ #category : #accessing }
SDL2Image class >> checkSymbol [
	^'IMG_Load' 
]

{ #category : #accessing }
SDL2Image class >> libNames [
	^#(
		'libSDL2_image.so'
		'libSDL2_image-2.0.so.0'
		'libSDL2_image-2.0.so'
		'libSDL2_image-2.0.so.0.2.3'
	)
]
