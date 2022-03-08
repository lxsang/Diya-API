Class {
	#name : #OpenGLTexImage2D,
	#superclass : #DiyaBaseObject,
	#instVars : [
		'target',
		'level',
		'internalFormat',
		'width',
		'height',
		'border',
		'format',
		'type',
		'data'
	],
	#pools : [
		'OpenGLConstants',
		'OpenGLTypes'
	],
	#category : #'Diya-OpenGL'
}

{ #category : #accessing }
OpenGLTexImage2D >> border [
	^ border
]

{ #category : #accessing }
OpenGLTexImage2D >> border: anObject [
	border := anObject
]

{ #category : #accessing }
OpenGLTexImage2D >> data [
	^ data
]

{ #category : #accessing }
OpenGLTexImage2D >> data: anObject [
	data := anObject
]

{ #category : #accessing }
OpenGLTexImage2D >> debug [
	self
		stdlog: 'Target:',target hex;
		stdlog: 'level:',level asString;
		stdlog: 'border :',border asString;
		stdlog: 'width :',width asString;
		stdlog: 'height :',height asString;
		stdlog: 'type :',type hex;
		stdlog: 'format :',format hex;
		stdlog: 'internalformat :',internalFormat hex
]

{ #category : #accessing }
OpenGLTexImage2D >> drop [
	^self subclassResponsibility
]

{ #category : #accessing }
OpenGLTexImage2D >> extent [
	^ width @ height 
]

{ #category : #accessing }
OpenGLTexImage2D >> format [
	^ format
]

{ #category : #accessing }
OpenGLTexImage2D >> format: anObject [
	format := anObject
]

{ #category : #accessing }
OpenGLTexImage2D >> height [
	^ height
]

{ #category : #accessing }
OpenGLTexImage2D >> height: anObject [
	height := anObject
]

{ #category : #accessing }
OpenGLTexImage2D >> internalFormat [
	^ internalFormat
]

{ #category : #accessing }
OpenGLTexImage2D >> internalFormat: anObject [
	internalFormat := anObject
]

{ #category : #accessing }
OpenGLTexImage2D >> level [
	^ level
]

{ #category : #accessing }
OpenGLTexImage2D >> level: anObject [
	level := anObject
]

{ #category : #accessing }
OpenGLTexImage2D >> mipmap [
	^false
]

{ #category : #accessing }
OpenGLTexImage2D >> setup [
	^self subclassResponsibility
]

{ #category : #accessing }
OpenGLTexImage2D >> target [
	^ target
]

{ #category : #accessing }
OpenGLTexImage2D >> target: anObject [
	target := anObject
]

{ #category : #accessing }
OpenGLTexImage2D >> type [
	^ type
]

{ #category : #accessing }
OpenGLTexImage2D >> type: anObject [
	type := anObject
]

{ #category : #accessing }
OpenGLTexImage2D >> width [
	^ width
]

{ #category : #accessing }
OpenGLTexImage2D >> width: anObject [
	width := anObject
]
