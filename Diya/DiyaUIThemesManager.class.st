Class {
	#name : #DiyaUIThemesManager,
	#superclass : #DiyaSingleton,
	#instVars : [
		'themes',
		'currentThemeName'
	],
	#category : #'Diya-UIThemes'
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
	self addTheme: #default stylesheet: DiyaDefaultTheme new. 
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
