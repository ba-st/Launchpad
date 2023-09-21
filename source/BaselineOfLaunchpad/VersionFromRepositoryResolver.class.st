Class {
	#name : #VersionFromRepositoryResolver,
	#superclass : #Object,
	#category : #BaselineOfLaunchpad
}

{ #category : #accessing }
VersionFromRepositoryResolver >> valueFor: projectName [

	| packageName version |
	packageName := ('BaselineOf<1s>' expandMacrosWith: projectName) asSymbol.
	version := ''.
	self class environment at: #IceRepository ifPresent: [ :icebergRepository | 
		version := icebergRepository registry detect: [ :repository | 
			           repository includesPackageNamed: packageName ]
			           ifFound: [ :repository | self versionFromGitRepository: repository ]
			           ifNone: [ self versionFromMonticelloRepository: packageName ]
		].
	^ version
]

{ #category : #private }
VersionFromRepositoryResolver >> versionFromGitRepository: repository [

	| projectCommitish |

	projectCommitish := repository project commitish.
	^ String streamContents: [ :stream | 
		  projectCommitish tagNames do: [ :tag | 
			  stream
				  nextPutAll: tag;
				  space
			  ].
		  stream
			  nextPut: $[;
			  nextPutAll: projectCommitish id;
			  nextPut: $]
		  ]
]

{ #category : #private }
VersionFromRepositoryResolver >> versionFromMonticelloRepository: aPackageName [

	self class environment at: #MCWorkingCopy ifPresent: [ :workingCopy | 
		workingCopy allManagers detect: [ :manager | manager packageName = aPackageName ]
			ifFound: [ :manager | ^ manager versionInfo id printString ]
		].
	^ ''
]
