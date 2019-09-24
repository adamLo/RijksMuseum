# RijksMuseum
Quardio assessment task that implements a sample app displaying Agenda and Collections from **RijksMuseum** API

## Task description

### The case
Het Rijksmuseum in Amsterdam is the most prominent museum of The Netherlands with masterpieces like the Nachtwacht from Rembrandt, they also provide an API to give us some insight into their collection. We want to display two sets of information from that API, one is a view with an overview of the upcoming events in the museum. The other is a view of thumbnails of an artist of your choosing (e.g. Rembrandt) present in the Rijksmuseum (an empty overview will not do), include the title of work.

You will be using the following endpoints:
https://www.rijksmuseum.nl/api/nl/agenda/[date]
https://www.rijksmuseum.nl/api/nl/collection/?q=[query]

For more information on the API see http://rijksmuseum.github.io You can use yW6uq3BV as the required API key to do the requests or create your own.

### Requirements

#### Networking
- The app must perform HTTP requests on at least one of the two endpoints of the REST API.
- One to acquire the events for the upcoming week. Try to optimize so that the time to retrieve the data is minimized. Retrieve the information in JSON format.
- The other is to acquire thumbnail images and accompanying title from one artist.
- The app must update the UI with the obtained data in a single event. Images may be retrieved as efficient as possible and may be loaded lazily.

#### Caching
- The app must cache the data obtained from the API to local storage, including the images.
- Cached data must be refreshed every 5 minutes, this is not necessary for image data.
- When the app starts and cache is available, you should not hit the remote API if not needed, according to the rule above.

#### Responsiveness
- The UI must be updated in real-time, according to the refresh rule explained above.

#### Resilience
- The user should be informed if an error occurred while fetching data.
- If no network is available when a request is due, the app should park the call and perform it as soon as the network is back.

#### Third-party libraries
- Try to use as few third-party libraries as possible, you can use third parties as long as explain the need for them in the documentation.
- You are allowed to use a third-party library for HTTP handling, please explain why you will use it.

## Installation
This project uses CocoaPods as dependency manager. 
Please run

```
pod install
```

and open workplace file instead of project file.

## Third party libraries

### ReachabilitySwift
Used to check connection to API host

### KingFisher
Caches and fetches images from network

### ActionSheetPicker-3.0
Implements picker action sheets to select items from list, date etc.