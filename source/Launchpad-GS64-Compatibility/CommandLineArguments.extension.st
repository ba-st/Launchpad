Extension { #name : #CommandLineArguments }

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineArguments >> allFilesWithExtension: anExtension [
	^ self arguments select: [ :arg|
		arg endsWith: anExtension ]
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineArguments >> copyWithoutPassword [
	^ self class withArguments: (arguments reject: [ :each | each beginsWith: '--deploymentPassword' ])
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineArguments >> hasFileWithExtension: aFileExtension [
	"return true if the first argument has the given file extension"
	^ self arguments anySatisfy: [ :arg|
		arg endsWith: aFileExtension]
]
