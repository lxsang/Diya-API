Class {
	#name : #DiyaDefaultStyle,
	#superclass : #Diya2DNodeStyle,
	#category : #'Diya-Graphics'
}

{ #category : #initialization }
DiyaDefaultStyle >> initialize [ 
	super initialize.
	bgcolor := (Color r: 0.2118 g: 0.2118  b: 0.2118).
	color := Color white.
	border := 1.
	fontSize := 18.
	fontFamilly := DiyaFontManager uniqueInstance defaultFamily.
	fontStyle := DiyaFontManager uniqueInstance defaultStyle.
	borderColor := (Color r: 0.051 g: 0.051  b: 0.051).
	bgcolor2 := (Color r: 0.1529 g: 0.1529  b: 0.1529)
]
