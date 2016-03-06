# Cottontown 2.0 Beta

This is an update of the Cottontown iPhone app I wrote in 2011.  This app is a walking tour of the Cottontown National Historic District in Columbia, SC that I wrote for the Historic Columbia Foundation (HCF).  I also live in this neighborhood.

I've decided to make this version of my app open source for a number of reasons.  This is my first serious attempt at writing a Swift app and I wanted to share my learning experiences and perhaps get suggestions from others.  I hope the app can be a framework for other projects within [HCF](http://www.historiccolumbia.org/take-a-tour) and other similar organizations. Finally, the app will provide some concrete examples for my high school students in the Swift and iOS App Development courses I taught at Midlands Technical College for the Richland District Two Institute of Innovation (R2i2).

The initial commit has basic functionality designed around a tab view controller with a table view for tour stops and a map to display stop locations.  Some of the features I'm including are not absolutely needed by the app, but are learning exercises for iOS features I want to explore (like iBeacons).

#### Features

This is not meant to be a complete list of features, but more to track what things I've attempted and what is yet to be implemented.  Obviously at this point there are many things I've coded but am still in the process of debugging.

* iBeacon support (this will not be included in the release version)
* Local notifications with custom actions (custom actions will not be needed in the release version)
* Universal app base on Split View Controllers
* Support for iPad multitasking
* Defaults in Settings app
* Remote push notifications
* YouTube support using Google youtube-ios-player-helper api

//TODO:

* Localize for Spanish, German, and French
* 3D touch - pressing on stop location gives a Peek and Pop for the location in the Map View (long press will do the same thing on non-3D devices)
* Quick Action on the app icon to go directly to the Map View
* Accessibility for vision impaired
* Optimize size for images used
* Proper sizing for assets
* Launch screen
* Add additional tour stops and content to existing stops
* Remove Reveal Framework when debugging is complete
* Run Instruments to check CPU and memory usage
* Dynamic text in page views
* Test functions in Airplane mode

#### Software

I'm using the latest public releases of Xcode (7.2.1) and OSX (10.11.3)

####Pictures

No pictures may be used without written permission from The Historic Columbia Foundation.

####Acknowledgements

I would like to thank Robin Waites and the [Historic Columbia Foundation](http://www.historiccolumbia.org) for their continued support for this project. 
 