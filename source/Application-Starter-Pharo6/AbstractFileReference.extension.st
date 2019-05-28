Extension { #name : #AbstractFileReference }

{ #category : #'*Application-Starter-Pharo6' }
AbstractFileReference >> binaryWriteStreamDo: aBlock [

	| stream |

	stream := self writeStream.
	stream binary.
	^ [ aBlock value: stream ]
		ensure: [ stream close ]
]
