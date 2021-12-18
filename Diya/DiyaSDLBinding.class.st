Class {
	#name : #DiyaSDLBinding,
	#superclass : #DiyaFFIBase,
	#category : #'Diya-Graphics-SDL'
}

{ #category : #accessing }
DiyaSDLBinding class >> checkSymbol [
	^ 'SDL_Init'
]

{ #category : #accessing }
DiyaSDLBinding class >> libNames [
	#(
		'libSDL2-2.0.so.0'			"Linux 1"
		'libSDL2-2.0.so.0.2.1'	"Linux 2"
	) 
]
