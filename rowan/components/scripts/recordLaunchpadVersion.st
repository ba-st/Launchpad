| project repoPath commitHash tags version |
project := Rowan projectNamed: 'Launchpad'.
repoPath  := project repositoryRoot pathString.
commitHash := (Rowan gitTools performGitCommand: 'rev-parse' in: repoPath with: #( 'HEAD')) trimSeparators.
tags := (Rowan gitTools performGitCommand: 'tag' in: repoPath with: #( '--points-at HEAD')) substrings.
version := String streamContents: [ :stream | 
  tags do: [ :tag | 
    stream
      nextPutAll: tag;
      space
    ].
  stream
    nextPut: $[;
    nextPutAll: commitHash;
    nextPut: $]
  ].
LaunchpadRootCommand version: version
