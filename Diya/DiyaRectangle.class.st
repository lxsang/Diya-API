Class {
	#name : #DiyaRectangle,
	#superclass : #Diya2DPrimShape,
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaRectangle >> draw [
	{
		0.0. extent y. 0.0. 0.0.            
      0. 0. 0.0. 1.0.
      extent x. 0.0. 1.0. 1.0.
		0.0. extent y. 0.0. 0.0.
      extent x. 0.0. 1.0. 1.0.
      extent x. extent y. 1.0. 0.0.
	} doWithIndex: [:e :i| context buffer at: i put: e].
	texture ifNotNil: [
		self texture setup.
		context texture0 setImage2D: self texture.
		context texture0 active.
	].
	context vao enableAttribute: 0.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:4  type: GL_FLOAT normalized: GL_FALSE stride: 16 pointer: nil.
	context vbo subData: GL_ARRAY_BUFFER offset:0  data: context buffer size: 96.
	OpenGL drawArrays: GL_TRIANGLES first:0  count: 6.
	context vao disableAttribute: 0.
	texture ifNotNil: [self texture drop]
]

{ #category : #accessing }
DiyaRectangle >> initialize [
	super initialize.
	self extent:10@10.
	translation  := nil.
	children := nil
]
