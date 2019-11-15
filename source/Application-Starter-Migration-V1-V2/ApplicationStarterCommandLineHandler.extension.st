Extension { #name : #ApplicationStarterCommandLineHandler }

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logError: anErrorMessage [

	self
		deprecated: 'Please use CurrentLogger value error: instead'
		transformWith: '`@receiver logError: ̀@message' -> '`CurrentLogger value error: `@message'.

	CurrentLogger value error: anErrorMessage
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logError: anErrorMessage during: aBlock [

	self
		deprecated: 'Please use CurrentLogger value error:during: instead'
		transformWith:
			'`@receiver logError: ̀@message during: ̀@block'
				-> '`CurrentLogger value error: `@message during: `@block'.

	CurrentLogger value error: anErrorMessage during: aBlock
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logInfo: aMessage [

	self
		deprecated: 'Please use CurrentLogger value info: instead'
		transformWith: '`@receiver logInfo: ̀@message' -> '`CurrentLogger value info: `@message'.

	CurrentLogger value info: aMessage
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logInfo: anErrorMessage during: aBlock [

	self
		deprecated: 'Please use CurrentLogger value info:during: instead'
		transformWith:
			'`@receiver logInfo: ̀@message during: ̀@block'
				-> '`CurrentLogger value info: `@message during: `@block'.

	CurrentLogger value info: anErrorMessage during: aBlock
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logWarning: anErrorMessage [

	self
		deprecated: 'Please use CurrentLogger value warning: instead'
		transformWith: '`@receiver logWarning: ̀@message' -> '`CurrentLogger value warning: `@message'.

	CurrentLogger value warning: anErrorMessage
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logWarning: anErrorMessage during: aBlock [

	self
		deprecated: 'Please use CurrentLogger value warning:during: instead'
		transformWith:
			'`@receiver logWarning: ̀@message during: ̀@block'
				-> '`CurrentLogger value warning: `@message during: `@block'.

	CurrentLogger value warning: anErrorMessage during: aBlock
]
