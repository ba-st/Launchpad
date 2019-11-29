Extension { #name : #ApplicationStarterCommandLineHandler }

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> currentTimeStampString [

	self
		deprecated: 'Please use the class side method instead'
		on: '2019-11-15'
		in: 'v2'
		transformWith: '`@receiver currentTimeStampString' -> '`@receiver class currentTimeStampString'.
	^ self class currentTimeStampString
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> defaultLogFile [

	self
		deprecated: 'Please use the class side method instead'
		on: '2019-11-15'
		in: 'v2'
		transformWith: '`@receiver defaultLogFile' -> '`@receiver class defaultLogFile'.
	^ self class defaultLogFile
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> defaultLogsPath [

	self
		deprecated: 'Please use the class side method instead'
		on: '2019-11-15'
		in: 'v2'
		transformWith: '`@receiver defaultLogsPath' -> '`@receiver class defaultLogsPath'.
	^ self class defaultLogsPath
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> defaultStackDumpFile [

	self
		deprecated: 'Please use the class side method instead'
		on: '2019-11-15'
		in: 'v2'
		transformWith: '`@receiver defaultStackDumpFile' -> '`@receiver class defaultStackDumpFile'.
	^ self class defaultStackDumpFile
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> dumpStackAndReport: aSignal [

	self
		deprecated: 'Please use the class side method instead'
		on: '2019-11-15'
		in: 'v2'
		transformWith: '`@receiver dumpStackAndReport: `@signal' -> '`@receiver class dumpStackAndReport: `@signal'.
	^ self class dumpStackAndReport: aSignal
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logError: anErrorMessage [

	self
		deprecated: 'Please use CurrentLogger value error: instead'
		on: '2019-11-15'
		in: 'v2'
		transformWith: '`@receiver logError: ̀@message' -> '`CurrentLogger value logAsError: `@message'.

	CurrentLogger value logAsError: anErrorMessage
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logError: anErrorMessage during: aBlock [

	self
		deprecated: 'Please use CurrentLogger value error:during: instead'
		on: '2019-11-15'
		in: 'v2'
		transformWith:
			'`@receiver logError: ̀@message during: ̀@block'
				-> '`CurrentLogger value logAsError: `@message during: `@block'.

	CurrentLogger value logAsError: anErrorMessage during: aBlock
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logInfo: aMessage [

	self
		deprecated: 'Please use CurrentLogger value info: instead'
		on: '2019-11-15'
		in: 'v2'
		transformWith: '`@receiver logInfo: ̀@message' -> '`CurrentLogger value logAsInfo: `@message'.

	CurrentLogger value logAsInfo: aMessage
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logInfo: anErrorMessage during: aBlock [

	self
		deprecated: 'Please use CurrentLogger value info:during: instead'
		on: '2019-11-15'
		in: 'v2'
		transformWith:
			'`@receiver logInfo: ̀@message during: ̀@block'
				-> '`CurrentLogger value logAsInfo: `@message during: `@block'.

	CurrentLogger value logAsInfo: anErrorMessage during: aBlock
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logPrefix [

	self
		deprecated: 'Please use the class side method instead'
		on: '2019-11-15'
		in: 'v2'
		transformWith: '`@receiver logPrefix' -> '`@receiver class logPrefix'.
	^ self class logPrefix
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logWarning: anErrorMessage [

	self
		deprecated: 'Please use CurrentLogger value warning: instead'
		on: '2019-11-15'
		in: 'v2'
		transformWith: '`@receiver logWarning: ̀@message' -> '`CurrentLogger value logAsWarning: `@message'.

	CurrentLogger value logAsWarning: anErrorMessage
]

{ #category : #'*Application-Starter-Migration-V1-V2' }
ApplicationStarterCommandLineHandler >> logWarning: anErrorMessage during: aBlock [

	self
		deprecated: 'Please use CurrentLogger value warning:during: instead'
		on: '2019-11-15'
		in: 'v2'
		transformWith:
			'`@receiver logWarning: ̀@message during: ̀@block'
				-> '`CurrentLogger value logAsWarning: `@message during: `@block'.

	CurrentLogger value logAsWarning: anErrorMessage during: aBlock
]
