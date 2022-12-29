Extension { #name : #String }

{ #category : #'*Launchpad-Configuration' }
String >> asBoolean [

	self asLowercase = 'true' ifTrue: [ ^ true ].
	self asLowercase = 'false' ifTrue: [ ^ false ].
	
	InstanceCreationFailed signal: ( '<1s> can''t be interpreted as a boolean' expandMacrosWith: self )
]
