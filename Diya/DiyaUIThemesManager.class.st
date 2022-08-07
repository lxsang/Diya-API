Class {
	#name : #DiyaUIThemesManager,
	#superclass : #DiyaSingleton,
	#instVars : [
		'themes',
		'currentThemeName'
	],
	#category : #'Diya-Graphics'
}

{ #category : #adding }
DiyaUIThemesManager >> addTheme:name stylesheet:sheet [
	themes at:name put: sheet
]

{ #category : #accessing }
DiyaUIThemesManager >> currentTheme [
	^ themes at: self currentThemeName  ifAbsent: [ 
		DiyaCoreAPIError signal: 'Undefined theme named', self currentThemeName
	]
]

{ #category : #accessing }
DiyaUIThemesManager >> currentThemeName [
	^ currentThemeName
]

{ #category : #accessing }
DiyaUIThemesManager >> currentThemeName: anObject [
	currentThemeName := anObject
]

{ #category : #initialization }
DiyaUIThemesManager >> defaultTheme [
	^ themes at: #default
]

{ #category : #initialization }
DiyaUIThemesManager >> defineDefaultTheme [
	self addTheme: #default stylesheet: (DiyaStyleSheet new
		define: #global styles: {
			#bgColor -> (Color r: 0.2118 g: 0.2118  b: 0.2118).
			#color -> Color white.
			#border -> 0.
			#fontSize -> 18.
			#fontFamily -> DiyaFontManager uniqueInstance defaultFamily.
			#textIconFamily -> 'bootstrap-icons'.
			#fontStyle -> DiyaFontManager uniqueInstance defaultStyle.
			#borderColor -> Color transparent.
			#xAlign -> #left.
			#yAlign -> #middle.
			#iconSize -> 24.
	 	} 
	)
]

{ #category : #initialization }
DiyaUIThemesManager >> initialize [
	super initialize.
	themes := Dictionary new.
	self defineDefaultTheme.
	self currentThemeName: #default.
]

{ #category : #accessing }
DiyaUIThemesManager >> themes [
	^ themes
]
