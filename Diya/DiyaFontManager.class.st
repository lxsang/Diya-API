Class {
	#name : #DiyaFontManager,
	#superclass : #DiyaSingleton,
	#instVars : [
		'families'
	],
	#category : #'Diya-Fonts'
}

{ #category : #'instance creation' }
DiyaFontManager class >> cleanUpInstance: singleton [
	singleton reset.
]

{ #category : #'class initialization' }
DiyaFontManager class >> initialize [
	self uniqueInstance reset.
]

{ #category : #'as yet unclassified' }
DiyaFontManager class >> searchPaths [
 ^ { 
		Smalltalk imageDirectory / 'fonts'
 }
]

{ #category : #initialization }
DiyaFontManager >> defaultFamily [
	^self error: 'No font found'
	
	
]

{ #category : #initialization }
DiyaFontManager >> face: styleName from: familyName [
	|family|
	family := families at: familyName  ifAbsent: [ self defaultFamily ].
	^family face: styleName 
	
]

{ #category : #accessing }
DiyaFontManager >> families [
	^ families
]

{ #category : #accessing }
DiyaFontManager >> familyNames [
	^ families keys
]

{ #category : #initialization }
DiyaFontManager >> initialize [ 
	super initialize.
	families := Dictionary new.
]

{ #category : #initialization }
DiyaFontManager >> loadFace: face [
	|family|
	family := families at: face familyName  ifAbsentPut:[DiyaFontFamily fromFace: face].
	family addFace: face
]

{ #category : #initialization }
DiyaFontManager >> loadFile: aFile [
	| path face i numfaces |
	path := aFile fullName convertToWithConverter: UTF8TextConverter new.
	i := 0.
	numfaces := nil.
	[ face := FreeTypeFace basicNew
		filename: path;
		index: i.
	face newFaceFromFile: path index: i.
	face loadFields.
	numfaces ifNil: [ numfaces := face numFaces ].
	self loadFace: face.
	i := i + 1.
	i < numfaces ] whileTrue: [  ]
]

{ #category : #initialization }
DiyaFontManager >> loadFonts [
	self loadFonts: false.
	
]

{ #category : #initialization }
DiyaFontManager >> loadFonts: force [
	force ifTrue:[self reset].
	self class searchPaths do:[:path| self loadPath: path].
	
]

{ #category : #initialization }
DiyaFontManager >> loadPath: path [
	path entries do:[:entry| entry isFile ifTrue:[self loadFile: entry ]].
	
]

{ #category : #initialization }
DiyaFontManager >> reset [
 	"reset all stored faces"
	families := Dictionary new.
]
