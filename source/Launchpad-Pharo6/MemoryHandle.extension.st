Extension { #name : #MemoryHandle }

{ #category : #'*Launchpad-Pharo6' }
MemoryHandle >> writeStream [

	"Return a writestream on my contents.
	Using myself as target collection allows to share the internal bytearray between multiple streams."

	^ RWBinaryOrTextStream on: self from: 1 to: entry fileSize
]
