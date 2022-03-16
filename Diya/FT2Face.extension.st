Extension { #name : #FT2Face }

{ #category : #'*Diya' }
FT2Face >> getFirstChar: gindex [
	^self ffiCall: #(FT_ULong FT_Get_First_Char(self,FT_UInt  *gindex)).
]

{ #category : #'*Diya' }
FT2Face >> getNextChar: charcode iptr: gindex [
	^self ffiCall: #( FT_ULong FT_Get_Next_Char(self,FT_ULong charcode,FT_UInt *gindex )).
]
