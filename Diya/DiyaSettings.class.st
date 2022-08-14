Class {
	#name : #DiyaSettings,
	#superclass : #DiyaSingleton,
	#instVars : [
		'maxFPS',
		'fontPaths',
		'assetPath',
		'renderAtOnce'
	],
	#category : #'Diya-Core'
}

{ #category : #'as yet unclassified' }
DiyaSettings class >> defaultSettingFile [
	^ Smalltalk imageDirectory / 'settings.json'
]

{ #category : #accessing }
DiyaSettings >> assetPath [
	^ assetPath
]

{ #category : #accessing }
DiyaSettings >> assetPath: anObject [
	assetPath := anObject
]

{ #category : #accessing }
DiyaSettings >> fontPaths [
	^ fontPaths
]

{ #category : #accessing }
DiyaSettings >> fontPaths: anObject [
	fontPaths := anObject
]

{ #category : #initialization }
DiyaSettings >> initialize [
	super initialize.
	maxFPS := 60.
	renderAtOnce := false.
	fontPaths := { Smalltalk imageDirectory / 'fonts' }.
	assetPath := Smalltalk imageDirectory / 'assets'.
	self loadFromFile.
	self logSettings
]

{ #category : #initialization }
DiyaSettings >> loadFromFile [
	|d v|
	self class defaultSettingFile exists ifFalse: [
		self stderror: 'Setting file not found. Using default settings'.
		^self
	].
	d := STON fromStream: self class defaultSettingFile readStream.
	maxFPS := d at:'max_fps' ifAbsent:[maxFPS].
	v := d at:'asset_dir' ifAbsent:[nil].
	v ifNotNil: [ assetPath := v ].
	renderAtOnce := d at: 'render_all_at_once' ifAbsent:[renderAtOnce ].
	fontPaths := fontPaths , (d at:'font_dirs' ifAbsent:[#()]).
]

{ #category : #initialization }
DiyaSettings >> logSettings [
	self stdlog: 'max_fps = ', maxFPS asString.
	self stdlog: 'font_dirs = ', fontPaths asString.
	self stdlog: 'asset_dir = ', assetPath asString.
	self stdlog: 'render_all_at_once = ', renderAtOnce asString.
]

{ #category : #accessing }
DiyaSettings >> maxFPS [
	^ maxFPS
]

{ #category : #accessing }
DiyaSettings >> maxFPS: anObject [
	maxFPS := anObject
]

{ #category : #accessing }
DiyaSettings >> renderAtOnce [
	^ renderAtOnce
]

{ #category : #accessing }
DiyaSettings >> renderAtOnce: anObject [
	renderAtOnce := anObject
]
