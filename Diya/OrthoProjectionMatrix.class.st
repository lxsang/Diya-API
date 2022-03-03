Class {
	#name : #OrthoProjectionMatrix,
	#superclass : #ProjectionMatrix,
	#instVars : [
		'viewport',
		'near',
		'far'
	],
	#category : #'Diya-Math'
}

{ #category : #'as yet unclassified' }
OrthoProjectionMatrix class >> fromDisplay: display [
	^ self viewport: (Rectangle origin: 0@0 corner: (display w) @ (display h) ) near: -1.0 far: 1.0.
]

{ #category : #'as yet unclassified' }
OrthoProjectionMatrix class >> viewport:v near:n far:f [
	^ self new setViewport: v near:n  far:f; yourself. 
]

{ #category : #accessing }
OrthoProjectionMatrix >> bottom [
	^ viewport origin  y
]

{ #category : #initialization }
OrthoProjectionMatrix >> calculate [
	self at:1 at:1 put: (2.0 /(self right - self left)).
	self at:2 at:2 put: (2.0 / (self top - self bottom)).
	self at:3 at:3 put: (2.0 / (self far - self near)) negated.
	self at:4 at:1 put: ((self right + self left)/ (self right - self left)) negated.
	self at:4 at:2 put: ((self top + self bottom) / (self top - self bottom)) negated.
	self at:4 at:3 put: ((self far + self near)/(self far - self near)) negated.
]

{ #category : #initialization }
OrthoProjectionMatrix >> default [
	viewport := Rectangle origin: -1.0@ -1.0 corner: 1.0@1.0.
	near := -1.0.
	far := 1.0.
	
]

{ #category : #accessing }
OrthoProjectionMatrix >> far [
	^ far
]

{ #category : #accessing }
OrthoProjectionMatrix >> far: anObject [
	far := anObject
]

{ #category : #accessing }
OrthoProjectionMatrix >> left [
	^ viewport origin x
]

{ #category : #accessing }
OrthoProjectionMatrix >> near [
	^ near
]

{ #category : #accessing }
OrthoProjectionMatrix >> near: anObject [
	near := anObject
]

{ #category : #accessing }
OrthoProjectionMatrix >> right [
	^ viewport corner x
]

{ #category : #initialization }
OrthoProjectionMatrix >> setViewport: v near: n far:f [
	viewport := v.
	near := n.
	far := f.
	self update.
]

{ #category : #accessing }
OrthoProjectionMatrix >> top [
	^ viewport corner y
]

{ #category : #accessing }
OrthoProjectionMatrix >> viewport [
	^ viewport
]

{ #category : #accessing }
OrthoProjectionMatrix >> viewport: anObject [
	viewport := anObject
]
