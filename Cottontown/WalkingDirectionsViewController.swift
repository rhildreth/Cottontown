//
//  WalkingDirectionsViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 11/11/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//

import UIKit
import MapKit


class WalkingDirectionsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var walkingMap: MKMapView!
    @IBOutlet var walkingDirectionsText: UITextView!
    
    let cottontownLoc = CLLocationCoordinate2DMake(34.019176, -81.038619)
    let sccb = CLLocationCoordinate2DMake(34.020290, -81.037219)
    let cemetery = CLLocationCoordinate2DMake( 34.022360, -81.039209)
    
    
    let locationManager = CLLocationManager()   // It is safe to start location services before the authorization status of the app is determined
    
    var timer: Timer!
    
    var currentPolyline: MKPolyline? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5.0
        locationManager.activityType = .other
        locationManager.headingFilter = 15.0
//        locationManager.startUpdatingLocation()
//        locationManager.startUpdatingHeading()
        
        walkingMap.showsUserLocation = true
        walkingMap.delegate = self
        walkingMap.setRegion(MKCoordinateRegionMakeWithDistance(cottontownLoc, 750.0, 750.0), animated: false)
    

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        }
    
    override func viewDidAppear(_ animated: Bool) {
        if determineStatus() {
            walkingMap.showsUserLocation = true
        } else {
            walkingMap.showsUserLocation = false
            //            NSLog("Location Services not available")
        }
        
        self.timer = Timer(timeInterval: 5.0, repeats: true) { myTimer in
            self.locationManager.requestLocation()
            print(myTimer)
        }
        
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    deinit {
        timer.invalidate()
        print("timer invalidate")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }

    

    func determineStatus() -> Bool {
        
//        guard CLLocationManager.locationServicesEnabled() else {        // redundant test - see .denied below
//            print("Loc services not enabled in Walking Directinos")
//            return false
//        }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse:
            return true
        case .notDetermined:        // user has not yet made a choice regarding whether this app can use location services
            self.locationManager.requestWhenInUseAuthorization()
            return false
        case .restricted, .authorizedAlways:
            return false
        case .denied:   // The user explicitly denied the use of location services for this app or location services are currently disabled in Settings
            return false
        }
    }
    
    func updateDirections() {
        print("timer fired")
    }
    
    
    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //        NSLog("did change authorization status")
        switch status {
        case .authorizedWhenInUse:
            
            print("locationManager didChangeAuthorization status to authorized when in use")
            
        default:
            break
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Every time a user location update comes in we create another direction request to make sure the user is on track
        
        guard let userLocation = locations.last else {return}
        guard userLocation.horizontalAccuracy < 10 else {return}
        
        print("\nUser location:", userLocation)
        walkingDirectionsText.text = "\n" + walkingDirectionsText.text + "Accuracy: " +  String(userLocation.horizontalAccuracy) + "\n"
        
        let request = MKDirectionsRequest()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: cemetery))
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.transportType = .walking
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in     // typealias MKDirectionsHandler = (MKDirectionsResponse?, Error?) -> Void
            guard error == nil else {
                print("Directions calculate error:", error!)
                return
            }
            guard let response = response else {return}
            
            let walkingRoute = response.routes[0]               // MKRoute - no alternated routes requested, so just take the first value
            let walkingSteps = walkingRoute.steps               // [MKRouteStep]
            
            if let currentPolyline = self.currentPolyline {
                self.walkingMap.remove(currentPolyline)
            }
            self.currentPolyline = walkingRoute.polyline
            self.walkingMap.add(walkingRoute.polyline)
            self.walkingMap.setVisibleMapRect(walkingRoute.polyline.boundingMapRect, animated: true)
            
            print("Total distance:", walkingRoute.distance)
            print("Transport:", walkingRoute.transportType)
            print("seconds:", walkingRoute.expectedTravelTime)
            print("advisory:", walkingRoute.advisoryNotices)
            print("name:", walkingRoute.name)
            
            for step in walkingSteps {
                print("\n",step.instructions)
                print(step.distance)
                self.walkingDirectionsText.text = self.walkingDirectionsText.text + step.instructions + "-----" + String(step.distance) + "\n"
            }
            
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        print(newHeading,"degrees")
//        walkingDirectionsText.text = walkingDirectionsText.text + String(newHeading.trueHeading) + " degrees\n"
//    }

}
