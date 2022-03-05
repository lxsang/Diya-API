Class {
	#name : #DiyaRectangle,
	#superclass : #Diya2DNode,
	#category : #'Diya-Graphics'
}

{ #category : #accessing }
DiyaRectangle >> draw [
	{
		0.0. 0.0. 1.0.
		0.0. extent y. 1.0.
		extent x. extent y. 1.0.
		extent x. 0.0. 1.0.
	} doWithIndex: [:e :i| context buffer at: i put: e].
	shader use.
	shader setUniform: #u_time value: DiyaClock uniqueInstance elapsedTime asFloat.
	shader setUniform: #u_transform value: {GL_TRUE. self tf asGLBuffer}.
	shader setUniform: #u_projection value: {GL_FALSE. context projection buffer}.
	shader setUniform: #u_resolution value: { context resolution x. context resolution y }.
	context mouse ifNotNil: [
		"in shader, window origin is bottom left conor of the window
		the mouse position should be transformed to this coodinate"
		shader setUniform: #u_mouse value: { context mouse x. context resolution y - context mouse y }.
	].
	context vao enableAttribute: 0.
	OpenGLVertexArray  vertexAttributePointerIndex: 0 size:3  type: GL_FLOAT normalized: GL_FALSE stride: 0 pointer: nil.
	context vbo subData: GL_ARRAY_BUFFER offset:0  data: context buffer.
	OpenGL drawArrays: GL_QUADS first:0  count: 4.
	context vao disableAttribute: 0.
]

{ #category : #accessing }
DiyaRectangle >> initialize [
	super initialize.
	self extent:10@10.
	translation  := nil.
	children := nil
]
