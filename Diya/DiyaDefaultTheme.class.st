Class {
	#name : #DiyaDefaultTheme,
	#superclass : #DiyaStyleSheet,
	#category : #'Diya-UIThemes'
}

{ #category : #define }
DiyaDefaultTheme >> defineGlobal [
	self define: #global styles: {
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
]

{ #category : #define }
DiyaDefaultTheme >> defineLoadingBar [
	self define: #loadingBar styles: {
			#bgColor -> Color red.
			#border -> 1.
			#borderColor -> Color white.
	 	}; 
		define: #loadingProgress styles: {
			#bgColor -> Color white.
			#border -> 0.
			#fontSize -> 18.
	 	}
]

{ #category : #initialization }
DiyaDefaultTheme >> initialize [
	super initialize.
	self defineGlobal.
	self defineLoadingBar.
]
