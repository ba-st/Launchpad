Extension { #name : #OSPlatform }

{ #category : #'*Launchpad-Configuration' }
OSPlatform >> environmentAt: aVariableName ifPresent: aBlock ifAbsent: anAbsentBlock [

	^ self environment
		  at: aVariableName
		  ifPresent: aBlock
		  ifAbsent: anAbsentBlock
]
