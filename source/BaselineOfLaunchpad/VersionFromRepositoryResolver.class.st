Class {
	#name : #VersionFromRepositoryResolver,
	#superclass : #Object,
	#category : #BaselineOfLaunchpad
}

{ #category : #accessing }
VersionFromRepositoryResolver >> valueFor: aPackageName [

	| version |

	version := ''.
	self class environment at: #IceRepository ifPresent: [ :icebergRepository | 
		version := icebergRepository registry detect: [ :repository | 
			           repository includesPackageNamed: aPackageName ]
			           ifFound: [ :repository | self versionFromGitRepository: repository ]
			           ifNone: [ self versionFromMonticelloRepository: aPackageName ]
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
