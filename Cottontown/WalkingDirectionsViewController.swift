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
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.distanceFilter = 3.0
            locationManager.startUpdatingLocation()
            walkingMap.showsUserLocation = true
        }
        

        walkingMap.delegate = self
    
        walkingMap.setRegion(MKCoordinateRegionMakeWithDistance(cottontownLoc, 750.0, 750.0), animated: false)
    
        let request = MKDirectionsRequest()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: cemetery))
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: sccb))
        request.transportType = .walking
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            guard let response = response else {return}
            
            let walkingRoute = response.routes[0]               // MKRoute
            let walkingSteps = walkingRoute.steps               // [MKRouteStep]
            
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
            }
            
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if determineStatus() {
            walkingMap.showsUserLocation = true
        } else {
            walkingMap.showsUserLocation = false
            //            NSLog("Location Services not available")
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }

    

    func determineStatus() -> Bool {
        
        guard CLLocationManager.locationServicesEnabled() else {
            print("Loc services not enabled in Walking Directinos")
            return false
        }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            return false
        case .restricted:
            return false
        case .denied:
            return false
        }
    }
    
    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //        NSLog("did change authorization status")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            
            walkingMap.showsUserLocation = true
            self.doThisWhenAuthorized?()
        default:
            break
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Found user's location: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

}
