# Cottontown 2.0

This is an update of the Cottontown iPhone app I wrote in 2011.  This app is a walking tour of the Cottontown National Historic District in Columbia, SC that I wrote for the Historic Columbia (HC).  I also live in this neighborhood.

I've decided to make this version of my app open source for a number of reasons.  This is my first serious attempt at writing a Swift app and I wanted to share my learning experiences and perhaps get suggestions from others.  I hope the app can be a framework for other projects within [HC](http://www.historiccolumbia.org/take-a-tour) and other similar organizations. Finally, the app will provide some concrete examples for my high school students in the Swift and iOS App Development courses I taught at Midlands Technical College for the Richland District Two Institute of Innovation (R2i2).

Some of the features I'm including in some builds are not absolutely needed by the app, but are learning exercises for iOS features I want to explore (like iBeacons).

#### Features & Functions Tested

* iBeacon support, Push notifications, and Local notifications with custom actions were implemented but will not be included in release 2.0.  To clean up the app in preparation for release to the app store, these features were removed from the app on May 4, 2016 on commit 13c2555.
* Universal app base on Split View Controllers
* Supports iPad multitasking
* YouTube support using Google youtube-ios-player-helper api (implemented, but removed in the 2.0 release. Videos are now local.  YouTube code left in for flexibility in future releases.)
* 3D touch - pressing on stop location gives a Peek and Pop for the location in the Map View (long press will do the same thing on non-3D devices)
* Optimized size for images used
* Dynamic text used in all views
* Accessibility for vision impaired
* Launch screen added 
* Three additional tour stops were added and descriptions updated for numerous stops
* Ran Instruments to check CPU and memory usage
* Tested functions in Airplane mode

Defer the following due to time constraints:

* Localize for Spanish, German, and French
*  Quick Action on the app icon to go directly to the Map View

#### Software

I'm using the latest public releases of Xcode (7.3.1) and OSX (10.11.4)

####Pictures

No pictures may be used without written permission from Historic Columbia.

####Acknowledgements

I would like to thank Robin Waites and the [Historic Columbia](http://www.historiccolumbia.org) for their continued support for this project. 
 