Extension { #name : #AbstractFileReference }

{ #category : #'*Launchpad-Pharo6' }
AbstractFileReference >> binaryWriteStreamDo: aBlock [

	| stream |

	stream := self writeStream.
	stream binary.
	^ [ aBlock value: stream ]
		ensure: [ stream close ]
]
