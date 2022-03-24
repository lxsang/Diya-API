Class {
	#name : #DiyaDefaultStyle,
	#superclass : #DiyaNodeStyle,
	#category : #'Diya-Graphics'
}

{ #category : #initialization }
DiyaDefaultStyle >> initialize [ 
	super initialize.
	self set: #bgcolor value:(Color r: 0.2118 g: 0.2118  b: 0.2118).
	self set: #color value: Color white.
	self set: #border value: 1.
	self set: #fontSize value: 18.
	self set: #fontFamily value: DiyaFontManager uniqueInstance defaultFamily.
	self set: #fontStyle value: DiyaFontManager uniqueInstance defaultStyle.
	self set: #borderColor value: (Color r: 0.051 g: 0.051  b: 0.051).
	self set: #bgcolor2 value: (Color r: 0.1529 g: 0.1529  b: 0.1529).
	self set: #textAlign value: #left.
	self set: #textVAlign value: #top
]
