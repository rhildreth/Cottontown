# Cottontown 2.0 Beta

This is an update of the Cottontown iPhone app I wrote in 2011.  This app is a walking tour of the Cottontown National Historic District in Columbia, SC that I wrote for the Historic Columbia Foundation (HCF).  I also live in this neighborhood.

I've decided to make this version of my app open source for a number of reasons.  This is my first serious attempt at writing a Swift app and I wanted to share my learning experiences and perhaps get suggestions from others.  I hope the app is also adaptable to other tours within [HCF](http://www.historiccolumbia.org/take-a-tour) and other similar organizations. Finally, the app will provide some concrete examples for my students in the Swift and iOS App Development courses I teach at Midlands Technical College.

The initial commit has basic functionality designed around a tab view controller with a table view for tour stops and a map to display stop locations.  Some of the features I'm including are not absolutely needed by the app, but are learning exercises for iOS features I want to try (like iBeacons).

#### Features

This is not meant to be a complete list of features, but more to track what things I've attempted and what is yet to be implemented.  Obviously at this point there are many things I've tried but am still in the process of debugging.

* iBeacon support
* Local notifications with custom actions 
* Universal app base on Split View Controllers
* Support for iPad multitasking
* Defaults in Settings app

//TODO:

* Remote push notifications
* Localize for Spanish and German
* 3D touch - pressing on stop location opens location in map view (long press will do the same thing on non-3D devices)
* Accessibility for vision impaired
* Optimize images used
* Proper sizing for assets
* Launch screen
* Add additional tour stops
* Add YouTube support using Google youtube-ios-player-helper api
* Remove Reveal Framework when debugging is complete
* Run Instruments to check CPU and memory usage
* Dynamic text in page views