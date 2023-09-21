Class {
	#name : #VersionFromRepositoryResolver,
	#superclass : #Object,
	#category : #'Launchpad-GS64-Extensions'
}

{ #category : #accessing }
VersionFromRepositoryResolver >> valueFor: projectName [

	| repoPath commitHash tags |
	repoPath := (Rowan projectNamed: projectName) repositoryRoot pathString.
	commitHash := (Rowan gitTools
		               performGitCommand: 'rev-parse'
		               in: repoPath
		               with: #( 'HEAD' )) trimSeparators.
	tags := (Rowan gitTools
		         performGitCommand: 'tag'
		         in: repoPath
		         with: #( '--points-at HEAD' )) substrings.
	^ String streamContents: [ :stream |
		  tags do: [ :tag |
			  stream
				  nextPutAll: tag;
				  space ].
		  stream
			  nextPut: $[;
			  nextPutAll: commitHash;
			  nextPut: $] ]
]
