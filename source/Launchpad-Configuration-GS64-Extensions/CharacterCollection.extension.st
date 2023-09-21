Extension { #name : #CharacterCollection }

{ #category : #'*Launchpad-Configuration-GS64-Extensions' }
CharacterCollection >> asBoolean [

	self asLowercase = 'true' ifTrue: [ ^ true ].
	self asLowercase = 'false' ifTrue: [ ^ false ].
	
	InstanceCreationFailed signal: ( '<1s> can''t be interpreted as a boolean' expandMacrosWith: self )
]
