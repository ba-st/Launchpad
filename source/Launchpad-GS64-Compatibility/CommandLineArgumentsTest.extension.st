Extension { #name : #CommandLineArgumentsTest }

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineArgumentsTest >> testAllFileTyped [
	self assert: (self commandLine allFilesWithExtension: #txt) equals: #('noOpt2.txt' 'opt12.txt').
	self assertEmpty: (self commandLine allFilesWithExtension: #foo)
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineArgumentsTest >> testHasFilesTyped [
	self assert: (self commandLine hasFileWithExtension: #txt).
	self deny: (self commandLine hasFileWithExtension: #foo)
]
