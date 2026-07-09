Extension { #name : 'LaunchpadApplicationContext' }

{ #category : '*Launchpad-Examples' }
LaunchpadApplicationContext >> runZnHelloWithPort: portNumber debugLevel: debugLevel [
	"Context extension that allows easy launchpad parameter testing"
	
	LaunchpadZnHelloApplication startServerOn: portNumber debug: debugLevel 
]
